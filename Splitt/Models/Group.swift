//
//  Group.swift
//  Splitt
//

import Foundation
import SwiftData

@Model
final class Group {
    var id: UUID
    var name: String
    var groupDescription: String
    var avatarColor: String
    var iconName: String
    var createdAt: Date
    var memberNames: [String] // Store member names as array

    @Relationship(deleteRule: .cascade, inverse: \Expense.group)
    var expenses: [Expense]?

    init(name: String, description: String = "", members: [String] = [], iconName: String = "person.3.fill") {
        self.id = UUID()
        self.name = name
        self.groupDescription = description
        self.memberNames = members
        self.iconName = iconName
        self.avatarColor = ["#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A", "#98D8C8", "#F7DC6F", "#BB8FCE", "#85C1E2"].randomElement() ?? "#4ECDC4"
        self.createdAt = Date()
        self.expenses = []
    }

    var totalExpenses: Double {
        expenses?.reduce(0) { $0 + $1.amount } ?? 0
    }

    var memberCount: Int {
        memberNames.count
    }
}
