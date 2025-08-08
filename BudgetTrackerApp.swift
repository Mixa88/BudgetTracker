//
//  BudgetTrackerApp.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 05.08.2025.
//

import SwiftUI
import SwiftData

@main
struct BudgetTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.green)
        }
        .modelContainer(for: [Expense.self, Category.self])
    }
}
