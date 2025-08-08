//
//  CategoriesView.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 08.08.2025.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Query(sort: \Category.name) private var allCategories: [Category]
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allCategories) { category in
                    HStack {
                        Text(category.name.capitalized)
                        Spacer()
                        
                        Text(category.totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Categories 🗂️")
        }
    }
}

#Preview {
    CategoriesView()
        .modelContainer(for: [Category.self, Expense.self], inMemory: true)
}
