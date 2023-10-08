//
//  Friend.swift
//  FriendFaceChallenge
//
//  Created by Alberto Peinado Santana on 25/8/23.
//

import Foundation

struct Friend: Codable, Identifiable {
    let id: UUID
    let name: String
}
