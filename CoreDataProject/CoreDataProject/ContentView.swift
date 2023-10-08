//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Alberto Peinado Santana on 23/8/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe IN %@", ["Aliens", "Firefly", "Star Trek"])) var ships: FetchedResults<Ship>
    
    @State private var lastNameFilter = "A"

    
    var body: some View {
        Group {
            VStack {
                List(ships, id: \.self) { ship in
                    Text(ship.name ?? "Unknown name")
                }
                
                Button("Add Examples") {
                    let ship1 = Ship(context: moc)
                    ship1.name = "Enterprise"
                    ship1.universe = "Star Trek"
                    
                    let ship2 = Ship(context: moc)
                    ship2.name = "Defiant"
                    ship2.universe = "Star Trek"
                    
                    let ship3 = Ship(context: moc)
                    ship3.name = "Millennium Falcon"
                    ship3.universe = "Star Wars"
                    
                    let ship4 = Ship(context: moc)
                    ship4.name = "Executor"
                    ship4.universe = "Star Wars"
                    
                    try? moc.save()
                }
            }
            
            VStack {
                FilteredList(filter: lastNameFilter)
                
                Button("Add Examples") {
                    let taylor = Singer(context: moc)
                    taylor.firstName = "Taylor"
                    taylor.lastName = "Swift"
                    
                    let ed = Singer(context: moc)
                    ed.firstName = "Ed"
                    ed.lastName = "Sheeran"
                    
                    let adele = Singer(context: moc)
                    adele.firstName = "Adele"
                    adele.lastName = "Adkins"
                    
                    try? moc.save()
                }
                
                Button("Show A") {
                    lastNameFilter = "A"
                }
                
                Button("Show S") {
                    lastNameFilter = "S"
                }
            }
        }
    }
}
