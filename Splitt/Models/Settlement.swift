//
//  Settlement.swift
//  Splitt
//

import Foundation
import SwiftData

@Model
final class Settlement {
    var id: UUID
    var payer: String // Person who paid
    var recipient: String // Person who received
    var amount: Double
    var date: Date
    var notes: String
    var groupId: UUID?

    init(payer: String, recipient: String, amount: Double, notes: String = "", groupId: UUID? = nil) {
        self.id = UUID()
        self.payer = payer
        self.recipient = recipient
        self.amount = amount
        self.date = Date()
        self.notes = notes
        self.groupId = groupId
    }
}
