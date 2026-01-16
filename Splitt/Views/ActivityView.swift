//
//  ActivityView.swift
//  Splitt
//

import SwiftUI
import SwiftData

struct ActivityView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Query(sort: \Settlement.date, order: .reverse) private var settlements: [Settlement]

    var allActivities: [ActivityItem] {
        var items: [ActivityItem] = []

        for expense in expenses {
            items.append(ActivityItem(type: .expense, date: expense.date, expense: expense))
        }

        for settlement in settlements {
            items.append(ActivityItem(type: .settlement, date: settlement.date, settlement: settlement))
        }

        return items.sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if allActivities.isEmpty {
                    EmptyStateView(
                        icon: "clock.fill",
                        title: "No Activity Yet",
                        message: "Your expenses and payments will appear here"
                    )
                } else {
                    List {
                        ForEach(allActivities) { item in
                            if item.type == .expense, let expense = item.expense {
                                ActivityExpenseRow(expense: expense)
                            } else if item.type == .settlement, let settlement = item.settlement {
                                ActivitySettlementRow(settlement: settlement)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Activity")
        }
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let type: ActivityType
    let date: Date
    var expense: Expense?
    var settlement: Settlement?

    enum ActivityType {
        case expense
        case settlement
    }
}

struct ActivityExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.teal.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: "dollarsign.circle.fill")
                    .foregroundStyle(.teal)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.expenseDescription)
                    .font(.headline)

                HStack {
                    Text(expense.paidBy)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("•")
                        .foregroundStyle(.secondary)

                    Text("paid $\(expense.amount, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(expense.date, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ActivitySettlementRow: View {
    let settlement: Settlement

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(settlement.payer)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                    Text(settlement.recipient)
                }
                .font(.headline)

                Text("paid $\(settlement.amount, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(settlement.date, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ActivityView()
        .modelContainer(for: [Expense.self, Settlement.self], inMemory: true)
}
