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
    @Environment(\.modelContext) var modelContext
    
    init(selectedCategory: Category?, sortOrder: SortDescriptor<Expense>) {
        let predicate: Predicate<Expense>?
        
        if let category = selectedCategory {
            let categoryID = category.id
            predicate = #Predicate<Expense> { expense in
                expense.category?.id == categoryID
            }
        } else {
            predicate = nil
        }
        
        _expenses = Query(filter: predicate, sort: [sortOrder])
    }
    
    // 1. Группируем расходы в словарь [Дата: [Расход]]
    private var groupedExpenses: [Date: [Expense]] {
        Dictionary(grouping: expenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
    }
    
    // 2. Получаем отсортированный массив дат (ключей словаря)
    private var sortedDates: [Date] {
        groupedExpenses.keys.sorted(by: >)
    }
    
    var body: some View {
        // Проверяем, есть ли вообще расходы
        if sortedDates.isEmpty {
            ContentUnavailableView("No Expenses Found", systemImage: "tray.fill")
        } else {
            List {
                // 3. Создаем секцию для каждой даты
                ForEach(sortedDates, id: \.self) { date in
                    Section(header: Text(date.formatted(date: .long, time: .omitted))) {
                        // 4. Отображаем расходы для этой конкретной даты
                        ForEach(groupedExpenses[date] ?? []) { expense in
                            NavigationLink(value: expense) {
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
                                    Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "UAH"))
                                }
                            }
                        }
                        // 5. Модификатор удаления теперь здесь, на внутреннем цикле
                        .onDelete { offsets in
                            // Вызываем новую функцию удаления
                            deleteExpense(for: date, at: offsets)
                        }
                    }
                }
            }
        }
    }
    
    // 6. Немного измененная функция удаления
    func deleteExpense(for date: Date, at offsets: IndexSet) {
        // Убедимся, что у нас есть массив расходов для этой даты
        guard let expensesForDate = groupedExpenses[date] else { return }
        
        for offset in offsets {
            let expense = expensesForDate[offset]
            modelContext.delete(expense)
        }
    }
}


