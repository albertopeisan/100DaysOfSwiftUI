//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Alberto Peinado Santana on 25/8/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16
    
    public var wrappedTitle: String {
        title ?? ""
    }
    
    public var wrappedDirector: String {
        director ?? ""
    }
}

extension Movie : Identifiable {

}
