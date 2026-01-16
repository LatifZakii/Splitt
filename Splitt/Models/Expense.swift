//
//  Expense.swift
//  Splitt
//

import Foundation
import SwiftData

enum SplitType: String, Codable {
    case equal = "Equal"
    case unequal = "Unequal"
    case percentage = "Percentage"
    case shares = "Shares"
}

@Model
final class Expense {
    var id: UUID
    var expenseDescription: String
    var amount: Double
    var paidBy: String // Name of person who paid
    var splitType: String // Using String for SwiftData compatibility
    var splitDetails: [String: Double] // participant name -> amount they owe
    var category: String
    var date: Date
    var notes: String

    var group: Group?

    init(description: String, amount: Double, paidBy: String, splitType: SplitType = .equal, splitDetails: [String: Double] = [:], category: String = "General", notes: String = "") {
        self.id = UUID()
        self.expenseDescription = description
        self.amount = amount
        self.paidBy = paidBy
        self.splitType = splitType.rawValue
        self.splitDetails = splitDetails
        self.category = category
        self.date = Date()
        self.notes = notes
    }

    var splitTypeEnum: SplitType {
        SplitType(rawValue: splitType) ?? .equal
    }
}
