//
//  Friend.swift
//  Splitt
//

import Foundation
import SwiftData

@Model
final class Friend {
    var id: UUID
    var name: String
    var email: String
    var phoneNumber: String
    var avatarColor: String
    var createdAt: Date

    var user: User?

    init(name: String, email: String = "", phoneNumber: String = "") {
        self.id = UUID()
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.avatarColor = ["#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A", "#98D8C8", "#F7DC6F", "#BB8FCE", "#85C1E2"].randomElement() ?? "#4ECDC4"
        self.createdAt = Date()
    }

    var initials: String {
        let names = name.split(separator: " ")
        if names.count >= 2 {
            return String(names[0].prefix(1) + names[1].prefix(1)).uppercased()
        } else if let first = names.first {
            return String(first.prefix(2)).uppercased()
        }
        return "??"
    }
}
