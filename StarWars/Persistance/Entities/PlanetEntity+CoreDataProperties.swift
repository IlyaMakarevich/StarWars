//
//  PlanetEntity+CoreDataProperties.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//
//

import Foundation
import CoreData


extension PlanetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanetEntity> {
        return NSFetchRequest<PlanetEntity>(entityName: "PlanetEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var diameter: String?
    @NSManaged public var population: String?

}

extension PlanetEntity : Identifiable {

}
