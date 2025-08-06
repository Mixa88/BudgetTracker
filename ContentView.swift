//
//  ContentView.swift
//  BudgetTracker
//
//  Created by Михайло Тихонов on 05.08.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedCategory: Category?
    @State private var showingAddScreen = false
    
    @Query(sort: \Category.name) var allCategories: [Category]
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Category.self, Expense.self], inMemory: true)
}
