//
//  Card.swift
//  Flashzilla
//
//  Created by Alberto Peinado Santana on 3/9/23.
//

import Foundation

struct Card: Codable, Identifiable {
    var id = UUID()
    let prompt: String
    let answer: String

    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
