//
//  Category.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 05.08.2025.
//

import Foundation
import SwiftData

@Model
class Category {
    @Attribute(.unique)
    var name: String
    
    var id = UUID()
    var expenses: [Expense] = []
    
    init(name: String) {
        self.name = name
    }
    

}
