//
//  AddExpenseView.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 06.08.2025.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Category.name) private var allCategories: [Category]

    @State private var amount: Double = 0.0
    @State private var note: String = ""
    @State private var date = Date()
    @State private var selectedCategory: Category?
    
    @State private var newCategoryName: String = ""
    
    var formIsValid: Bool {
        
        let isAmountValid = !amount.isZero
        
        let isCategoryValid = selectedCategory != nil || !newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty
        
        return isAmountValid && isCategoryValid
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expence Details") {
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                    TextField("Note (optional)", text: $note)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("None").tag(nil as Category?)
                        ForEach(allCategories) { category in
                            Text(category.name).tag(category as Category?)
                        }
                    }
                    
                    TextField("Or add a new category", text: $newCategoryName) {
                        
                    }
                }
                
                Section {
                    Button("Save Expense") {
                        saveExpense()
                        dismiss()
                    }
                    .disabled(!formIsValid)
                }
            }
            .onSubmit(addNewCategory)
            .navigationTitle("Add New Expense 💵")
        }
    }
    
    private func addNewCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespaces)
        if !trimmedName.isEmpty {
            let newCategory = Category(name: trimmedName)
            modelContext.insert(newCategory)
            selectedCategory = newCategory
            newCategoryName = ""
        }
    }
    
    private func saveExpense() {
        let expense = Expense(amount: amount, note: note, date: date)
        
        if let category = selectedCategory {
            expense.category = category
        }
        
        modelContext.insert(expense)
    }
}

#Preview {
    AddExpenseView()
}
