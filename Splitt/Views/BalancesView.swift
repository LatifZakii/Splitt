//
//  BalancesView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct BalancesView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var settlements: [Settlement]

    let group: Group
    let balances: [String: Double]
    @State private var showingSettlement = false
    @State private var selectedPayer = ""
    @State private var selectedRecipient = ""

    var simplifiedDebts: [(from: String, to: String, amount: Double)] {
        BalanceCalculator.simplifyDebts(balances: balances)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    ForEach(balances.keys.sorted(), id: \.self) { member in
                        let balance = balances[member] ?? 0
                        HStack {
                            Text(member)
                            Spacer()
                            if balance > 0 {
                                Text("gets back $\(balance, specifier: "%.2f")")
                                    .foregroundStyle(.green)
                            } else if balance < 0 {
                                Text("owes $\(abs(balance), specifier: "%.2f")")
                                    .foregroundStyle(.orange)
                            } else {
                                Text("settled up")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Suggested Settlements") {
                    if simplifiedDebts.isEmpty {
                        Text("All settled up!")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(simplifiedDebts.indices, id: \.self) { index in
                            let debt = simplifiedDebts[index]
                            Button {
                                selectedPayer = debt.from
                                selectedRecipient = debt.to
                                showingSettlement = true
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(debt.from)
                                                .foregroundStyle(.primary)
                                            Image(systemName: "arrow.right")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            Text(debt.to)
                                                .foregroundStyle(.primary)
                                        }
                                        .font(.subheadline)

                                        Text("$\(debt.amount, specifier: "%.2f")")
                                            .font(.headline)
                                            .foregroundStyle(.teal)
                                    }

                                    Spacer()

                                    Image(systemName: "checkmark.circle")
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                }

                if !settlements.filter({ $0.groupId == group.id }).isEmpty {
                    Section("Payment History") {
                        ForEach(settlements.filter { $0.groupId == group.id }.sorted(by: { $0.date > $1.date })) { settlement in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(settlement.payer)
                                    Image(systemName: "arrow.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text(settlement.recipient)
                                }
                                .font(.subheadline)

                                HStack {
                                    Text("$\(settlement.amount, specifier: "%.2f")")
                                        .font(.headline)
                                        .foregroundStyle(.green)

                                    Spacer()

                                    Text(settlement.date, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Balances")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingSettlement) {
                RecordSettlementView(
                    group: group,
                    payer: selectedPayer,
                    recipient: selectedRecipient,
                    suggestedAmount: simplifiedDebts.first(where: { $0.from == selectedPayer && $0.to == selectedRecipient })?.amount ?? 0
                )
            }
        }
    }
}

struct RecordSettlementView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let group: Group
    let payer: String
    let recipient: String
    let suggestedAmount: Double

    @State private var amount: String

    init(group: Group, payer: String, recipient: String, suggestedAmount: Double) {
        self.group = group
        self.payer = payer
        self.recipient = recipient
        self.suggestedAmount = suggestedAmount
        _amount = State(initialValue: String(format: "%.2f", suggestedAmount))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text(payer)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(recipient)
                    }
                    .font(.headline)
                }

                Section("Amount") {
                    HStack {
                        Text("$")
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Record Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        recordSettlement()
                    }
                    .disabled(Double(amount) == nil || Double(amount) ?? 0 <= 0)
                }
            }
        }
    }

    private func recordSettlement() {
        guard let amountValue = Double(amount), amountValue > 0 else { return }

        let settlement = Settlement(
            payer: payer,
            recipient: recipient,
            amount: amountValue,
            notes: "Payment in \(group.name)",
            groupId: group.id
        )

        modelContext.insert(settlement)
        dismiss()
    }
}
