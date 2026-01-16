//
//  GroupDetailView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct GroupDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @Query private var settlements: [Settlement]
    let group: Group
    @State private var showingAddExpense = false
    @State private var showingBalances = false

    var balances: [String: Double] {
        BalanceCalculator.calculateBalances(
            expenses: group.expenses ?? [],
            settlements: settlements.filter { $0.groupId == group.id }
        )
    }

    var body: some View {
        List {
            // Balance Summary Section
            Section {
                Button {
                    showingBalances = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Group Balances")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            let userBalance = balances[users.first?.name ?? ""] ?? 0
                            if userBalance > 0 {
                                Text("You are owed $\(abs(userBalance), specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundStyle(.green)
                            } else if userBalance < 0 {
                                Text("You owe $\(abs(userBalance), specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundStyle(.orange)
                            } else {
                                Text("All settled up")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Expenses Section
            Section {
                if let expenses = group.expenses, !expenses.isEmpty {
                    ForEach(expenses.sorted(by: { $0.date > $1.date })) { expense in
                        ExpenseRowView(expense: expense)
                    }
                    .onDelete(perform: deleteExpenses)
                } else {
                    Text("No expenses yet")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            } header: {
                Text("Expenses")
            }

            // Members Section
            Section("Members") {
                ForEach(group.memberNames, id: \.self) { member in
                    HStack {
                        Circle()
                            .fill(Color(hex: String(member.hashValue).suffix(6).padding(toLength: 6, withPad: "0", startingAt: 0)))
                            .frame(width: 32, height: 32)
                            .overlay {
                                Text(getMemberInitials(member))
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }

                        Text(member)

                        Spacer()

                        let balance = balances[member] ?? 0
                        if balance > 0 {
                            Text("+$\(balance, specifier: "%.2f")")
                                .foregroundStyle(.green)
                                .font(.caption)
                        } else if balance < 0 {
                            Text("-$\(abs(balance), specifier: "%.2f")")
                                .foregroundStyle(.orange)
                                .font(.caption)
                        } else {
                            Text("Settled")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(group: group)
        }
        .sheet(isPresented: $showingBalances) {
            BalancesView(group: group, balances: balances)
        }
    }

    private func deleteExpenses(offsets: IndexSet) {
        guard let expenses = group.expenses else { return }
        for index in offsets {
            modelContext.delete(expenses[index])
        }
    }

    private func getMemberInitials(_ name: String) -> String {
        let names = name.split(separator: " ")
        if names.count >= 2 {
            return String(names[0].prefix(1) + names[1].prefix(1)).uppercased()
        } else if let first = names.first {
            return String(first.prefix(2)).uppercased()
        }
        return "??"
    }
}

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(Color.teal.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: getCategoryIcon(expense.category))
                    .foregroundStyle(.teal)
                    .font(.subheadline)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.expenseDescription)
                    .font(.headline)

                HStack {
                    Text(expense.paidBy)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("•")
                        .foregroundStyle(.secondary)
                        .font(.caption)

                    Text(expense.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Amount
            Text("$\(expense.amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }

    private func getCategoryIcon(_ category: String) -> String {
        switch category {
        case "Food": return "fork.knife"
        case "Transport": return "car.fill"
        case "Entertainment": return "ticket.fill"
        case "Shopping": return "cart.fill"
        case "Bills": return "doc.text.fill"
        case "Other": return "ellipsis.circle.fill"
        default: return "dollarsign.circle.fill"
        }
    }
}
