//
//  CoreDataTemplateApp.swift
//  CoreDataTemplate
//
//  Created by Alberto Peinado Santana on 24/8/23.
//

import SwiftUI

@main
struct CoreDataTemplateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
