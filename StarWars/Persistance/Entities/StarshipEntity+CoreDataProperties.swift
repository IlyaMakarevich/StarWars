//
//  StarshipEntity+CoreDataProperties.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//
//

import Foundation
import CoreData


extension StarshipEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarshipEntity> {
        return NSFetchRequest<StarshipEntity>(entityName: "StarshipEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var model: String?
    @NSManaged public var producer: String?
    @NSManaged public var passengers: String?

}

extension StarshipEntity : Identifiable {

}
