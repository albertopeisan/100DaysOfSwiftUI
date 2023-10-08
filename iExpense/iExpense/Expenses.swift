//
//  Expenses.swift
//  iExpense
//
//  Created by Alberto Peinado Santana on 18/8/23.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personalExpenses: [ExpenseItem] {
        return items.filter { item in
            item.type == "Personal"
        }
    }
    
    var businessExpenses: [ExpenseItem] {
        return items.filter { item in
            item.type == "Business"
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }

}
