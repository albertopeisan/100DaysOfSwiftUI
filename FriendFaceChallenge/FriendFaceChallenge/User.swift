//
//  User.swift
//  FriendFaceChallenge
//
//  Created by Alberto Peinado Santana on 25/8/23.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
    
    var formattedRegisteredDate: String {
        registered.formatted(date: .abbreviated, time: .omitted)
    }
}
