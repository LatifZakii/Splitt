//
//  BalanceCalculator.swift
//  Splitt
//

import Foundation

struct BalanceCalculator {
    /// Calculate balances for all members based on expenses and settlements
    /// Positive balance = person is owed money
    /// Negative balance = person owes money
    static func calculateBalances(expenses: [Expense], settlements: [Settlement]) -> [String: Double] {
        var balances: [String: Double] = [:]

        // Process expenses
        for expense in expenses {
            let payer = expense.paidBy

            // Payer gets credited the full amount
            balances[payer, default: 0] += expense.amount

            // Each participant gets debited their share
            for (participant, amount) in expense.splitDetails {
                balances[participant, default: 0] -= amount
            }
        }

        // Process settlements
        for settlement in settlements {
            // Payer paid out money (reduces their balance)
            balances[settlement.payer, default: 0] -= settlement.amount

            // Recipient received money (increases their balance)
            balances[settlement.recipient, default: 0] += settlement.amount
        }

        return balances
    }

    /// Simplify debts to minimize number of transactions needed
    /// Returns array of (from, to, amount) tuples representing who should pay whom
    static func simplifyDebts(balances: [String: Double]) -> [(from: String, to: String, amount: Double)] {
        var result: [(from: String, to: String, amount: Double)] = []

        // Separate creditors (positive balance) and debtors (negative balance)
        var creditors = balances.filter { $0.value > 0.01 }.sorted { $0.value > $1.value }
        var debtors = balances.filter { $0.value < -0.01 }.sorted { $0.value < $1.value }

        var creditorIndex = 0
        var debtorIndex = 0

        while creditorIndex < creditors.count && debtorIndex < debtors.count {
            let creditor = creditors[creditorIndex]
            let debtor = debtors[debtorIndex]

            let creditorAmount = creditor.value
            let debtorAmount = abs(debtor.value)

            let settlementAmount = min(creditorAmount, debtorAmount)

            result.append((
                from: debtor.key,
                to: creditor.key,
                amount: settlementAmount
            ))

            // Update balances
            creditors[creditorIndex].value -= settlementAmount
            debtors[debtorIndex].value += settlementAmount

            // Move to next creditor or debtor if current one is settled
            if creditors[creditorIndex].value < 0.01 {
                creditorIndex += 1
            }
            if abs(debtors[debtorIndex].value) < 0.01 {
                debtorIndex += 1
            }
        }

        return result
    }
}
