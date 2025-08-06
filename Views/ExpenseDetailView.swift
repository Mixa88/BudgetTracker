//
//  ExpenseDetailView.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 06.08.2025.
//

import SwiftUI
import SwiftData

struct ExpenseDetailView: View {
    let expense: Expense
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteAlert = false
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack {
                    Text("Amount")
                    Text(expense.amount, format: .currency(code: "USD"))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial, in: .rect(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Category")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(expense.category?.name ?? "Unknown")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Date:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(expense.date.formatted(date: .long, time: .omitted))
                            .fontWeight(.semibold)
                            
                    }
                }
                .padding()
                
                if !expense.note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note")
                            .font(.headline)
                        Text(expense.note)
                    }
                    .padding()
                }
                
                Spacer()
                
            }
            .padding()
        }
        .navigationTitle(expense.note.isEmpty ? "Expense Detail" : expense.note)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete Expense", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteExpense)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this expense", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteExpense() {
        modelContext.delete(expense)
        dismiss()
    }
}

private struct DetailPreviewContainer: View {
    
    let result: Result<(Expense, ModelContainer), Error>
    
    init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Expense.self, Category.self, configurations: config)
            
            let sampleExpense = Expense(
                    amount: 199.99,
                    note: "New Sneakers",
                    date: .now
                )
                let sampleCategory = Category(name: "Clothes")
            
            sampleExpense.category = sampleCategory
                        
                        
            container.mainContext.insert(sampleCategory)
            container.mainContext.insert(sampleExpense)
            
            container.mainContext.insert(sampleExpense)
            
            self.result = .success((sampleExpense, container))
        } catch {
            self.result = .failure(error)
        }
    }
    
    var body: some View {
        switch result {
        case .success(let (expense, container)):
            
            NavigationStack {
                ExpenseDetailView(expense: expense)
            }
            .modelContainer(container)
            
        case .failure(let error):
            
            Text("Failed to create preview: \(error.localizedDescription)")
        }
    }
}

#Preview {
    DetailPreviewContainer()
}
