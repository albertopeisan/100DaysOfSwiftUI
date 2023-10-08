//
//  FriendFaceChallengeApp.swift
//  FriendFaceChallenge
//
//  Created by Alberto Peinado Santana on 25/8/23.
//

import SwiftUI

@main
struct FriendFaceChallengeApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
