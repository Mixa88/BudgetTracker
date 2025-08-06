//
//  ContentView.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 05.08.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query(sort: \Category.name) var allCategories: [Category]
    @State private var sortOrder = SortDescriptor(\Expense.date, order: .reverse)
    
    @State private var selectedCategory: Category?
    
    @State private var showingAddScreen = false

    var body: some View {
        NavigationStack {
            // Используем твой готовый View для списка
            FilteredExpenseListView(selectedCategory: selectedCategory, sortOrder: sortOrder)
                .navigationTitle(selectedCategory?.name.capitalized ?? "All expenses 💸")
                .navigationDestination(for: Expense.self) { expense in
                    // Переход на экран деталей
                    ExpenseDetailView(expense: expense)
                }
                .toolbar {
                    // Кнопка для добавления нового расхода
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Expense", systemImage: "plus") {
                            showingAddScreen.toggle()
                        }
                    }
                    
                    // Меню для фильтрации по категориям
                    ToolbarItem(placement: .topBarLeading) {
                        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                            // Кнопка для сброса фильтра
                            Button("Показать все") {
                                selectedCategory = nil
                            }
                            
                            // Список категорий
                            ForEach(allCategories) { category in
                                Button(category.name.capitalized) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    
                    // Меню для сортировки
                    ToolbarItem(placement: .topBarLeading) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down.circle") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("По дате (сначала новые)")
                                    .tag(SortDescriptor(\Expense.date, order: .reverse))
                                
                                Text("По дате (сначала старые)")
                                    .tag(SortDescriptor(\Expense.date, order: .forward))
                                
                                Text("По сумме (сначала большие)")
                                    .tag(SortDescriptor(\Expense.amount, order: .reverse))
                                
                                Text("По сумме (сначала маленькие)")
                                    .tag(SortDescriptor(\Expense.amount, order: .forward))
                            }
                            .pickerStyle(.inline)
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddExpenseView()
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Category.self, Expense.self], inMemory: true)
}
