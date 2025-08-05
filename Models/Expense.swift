//
//  Expense.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 05.08.2025.
//

import Foundation
import SwiftData

@Model
class Expense {
    var id = UUID()
    var amount: Double
    var note: String
    var date: Date
    
    @Relationship(deleteRule: .nullify, inverse: \Category.expenses)
    var category: Category?
    
    init(id: UUID = UUID(), amount: Double, note: String, date: Date) {
        self.id = id
        self.amount = amount
        self.note = note
        self.date = date
    }

}
