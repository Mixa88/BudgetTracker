//
//  FilteredExpenseListView.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 06.08.2025.
//

import SwiftUI
import SwiftData

struct FilteredExpenseListView: View {
    @Query private var expenses: [Expense]
    
    init(selectedCategory: Category?, sortOrder: SortDescriptor<Expense>) {
        let predicate: Predicate<Expense>?
        if let category = selectedCategory {
            predicate = #Predicate<Expense> { expense in
                expense.category?.id == category.id
            
            }
        } else {
            predicate = nil
        }
        
        _expenses = Query(filter: predicate, sort: [sortOrder])
        
    }
    
    var body: some View {
        ForEach(expenses) { expense in
            HStack {
                VStack(alignment: .leading) {
                    Text(expense.note.isEmpty ? "Expense" : expense.note)
                        .font(.headline)
                    
                    if let categoryName = expense.category?.name {
                        Text(categoryName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Text(expense.amount, format: .currency(code: "USD"))
            }
        }
    }
}


