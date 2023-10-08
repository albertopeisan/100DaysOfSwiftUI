//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Alberto Peinado Santana on 23/8/23.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
