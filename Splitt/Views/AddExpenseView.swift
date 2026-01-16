//
//  AddExpenseView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let group: Group

    @State private var description = ""
    @State private var amount = ""
    @State private var selectedPayer: String
    @State private var selectedCategory = "General"
    @State private var splitType: SplitType = .equal
    @State private var notes = ""
    @State private var customSplits: [String: String] = [:]

    let categories = ["General", "Food", "Transport", "Entertainment", "Shopping", "Bills", "Other"]

    init(group: Group) {
        self.group = group
        _selectedPayer = State(initialValue: group.memberNames.first ?? "")
        _customSplits = State(initialValue: Dictionary(uniqueKeysWithValues: group.memberNames.map { ($0, "") }))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Description", text: $description)

                    HStack {
                        Text("$")
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }

                Section("Paid By") {
                    Picker("Paid by", selection: $selectedPayer) {
                        ForEach(group.memberNames, id: \.self) { member in
                            Text(member).tag(member)
                        }
                    }
                }

                Section("Split") {
                    Picker("Split Type", selection: $splitType) {
                        Text("Equally").tag(SplitType.equal)
                        Text("Unequally").tag(SplitType.unequal)
                        Text("By Percentage").tag(SplitType.percentage)
                        Text("By Shares").tag(SplitType.shares)
                    }

                    if splitType != .equal {
                        ForEach(group.memberNames, id: \.self) { member in
                            HStack {
                                Text(member)
                                Spacer()
                                TextField(getSplitPlaceholder(), text: Binding(
                                    get: { customSplits[member] ?? "" },
                                    set: { customSplits[member] = $0 }
                                ))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                            }
                        }

                        if splitType != .equal {
                            Text(getSplitValidation())
                                .font(.caption)
                                .foregroundStyle(isSplitValid() ? .green : .orange)
                        }
                    }
                }

                Section("Notes (Optional)") {
                    TextEditor(text: $notes)
                        .frame(height: 60)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addExpense()
                    }
                    .disabled(!isValid())
                }
            }
        }
    }

    private func getSplitPlaceholder() -> String {
        switch splitType {
        case .equal: return ""
        case .unequal: return "$0.00"
        case .percentage: return "0%"
        case .shares: return "0"
        }
    }

    private func getSplitValidation() -> String {
        guard let totalAmount = Double(amount), totalAmount > 0 else {
            return "Enter amount first"
        }

        let total = calculateSplitTotal()

        switch splitType {
        case .equal:
            return ""
        case .unequal:
            if abs(total - totalAmount) < 0.01 {
                return "✓ Split totals match"
            } else {
                return "⚠ Split total: $\(total, specifier: "%.2f") (Need: $\(totalAmount, specifier: "%.2f"))"
            }
        case .percentage:
            if abs(total - 100) < 0.01 {
                return "✓ Percentages add up to 100%"
            } else {
                return "⚠ Total: \(total, specifier: "%.0f")% (Need: 100%)"
            }
        case .shares:
            return "Total shares: \(Int(total))"
        }
    }

    private func calculateSplitTotal() -> Double {
        customSplits.values.compactMap { Double($0) }.reduce(0, +)
    }

    private func isSplitValid() -> Bool {
        guard let totalAmount = Double(amount), totalAmount > 0 else {
            return false
        }

        let total = calculateSplitTotal()

        switch splitType {
        case .equal:
            return true
        case .unequal:
            return abs(total - totalAmount) < 0.01
        case .percentage:
            return abs(total - 100) < 0.01
        case .shares:
            return total > 0
        }
    }

    private func isValid() -> Bool {
        guard !description.isEmpty,
              let amountValue = Double(amount),
              amountValue > 0 else {
            return false
        }

        if splitType != .equal {
            return isSplitValid()
        }

        return true
    }

    private func addExpense() {
        guard let amountValue = Double(amount) else { return }

        var splitDetails: [String: Double] = [:]

        switch splitType {
        case .equal:
            let perPerson = amountValue / Double(group.memberNames.count)
            for member in group.memberNames {
                splitDetails[member] = perPerson
            }

        case .unequal:
            for member in group.memberNames {
                if let value = Double(customSplits[member] ?? "0") {
                    splitDetails[member] = value
                }
            }

        case .percentage:
            for member in group.memberNames {
                if let percentage = Double(customSplits[member] ?? "0") {
                    splitDetails[member] = (percentage / 100) * amountValue
                }
            }

        case .shares:
            let totalShares = calculateSplitTotal()
            for member in group.memberNames {
                if let shares = Double(customSplits[member] ?? "0") {
                    splitDetails[member] = (shares / totalShares) * amountValue
                }
            }
        }

        let expense = Expense(
            description: description,
            amount: amountValue,
            paidBy: selectedPayer,
            splitType: splitType,
            splitDetails: splitDetails,
            category: selectedCategory,
            notes: notes
        )

        expense.group = group
        modelContext.insert(expense)

        dismiss()
    }
}
