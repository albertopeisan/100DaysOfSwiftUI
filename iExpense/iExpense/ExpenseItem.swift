//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Alberto Peinado Santana on 18/8/23.
//

import Foundation

struct ExpenseItem: Identifiable, Encodable, Decodable {
    var id: UUID = UUID()
    let name: String
    let type: String
    let amount: Double
}
