//
//  CharacterEntity+CoreDataProperties.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//
//

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var shipsCount: Int32

}

extension CharacterEntity : Identifiable {

}
