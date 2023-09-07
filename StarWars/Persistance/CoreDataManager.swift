//
//  CoreDataManager.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//

import CoreData
import UIKit

final class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func saveCharacter(name: String, gender: String, shipsCount: Int) {
        guard let characterEntityDescription = NSEntityDescription.entity(forEntityName: "CharacterEntity", in: context) else {
            return
        }
        let character = CharacterEntity(entity: characterEntityDescription, insertInto: context)
        character.name = name
        character.gender = gender
        character.shipsCount = Int32(shipsCount)
        appDelegate.saveContext()
    }
    
    func deleteCharacter(name: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterEntity")
        request.predicate = NSPredicate(format: "name = %@", name)
        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]
        resultData.forEach { context.delete($0) }
        appDelegate.saveContext()
    }
    
    func saveStarship(name: String, model: String, producer: String, passengers: String) {
        guard let starshipEntityDescription = NSEntityDescription.entity(forEntityName: "StarshipEntity", in: context) else {
            return
        }
        let starship = StarshipEntity(entity: starshipEntityDescription, insertInto: context)
        starship.name = name
        starship.model = model
        starship.producer = producer
        starship.passengers = passengers
        appDelegate.saveContext()
    }
    
    func deleteStarship(name: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StarshipEntity")
        request.predicate = NSPredicate(format: "name = %@", name)
        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]
        resultData.forEach { context.delete($0) }
        appDelegate.saveContext()
    }
    
    func savePlanet(name: String, diameter: String, population: String) {
        guard let planetEntityDescription = NSEntityDescription.entity(forEntityName: "PlanetEntity", in: context) else {
            return
        }
        let planet = PlanetEntity(entity: planetEntityDescription, insertInto: context)
        planet.name = name
        planet.diameter = diameter
        planet.population = population
        appDelegate.saveContext()
    }
    
    func deletePlanet(name: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanetEntity")
        request.predicate = NSPredicate(format: "name = %@", name)
        let result = try? context.fetch(request)
        let resultData = result as! [NSManagedObject]
        resultData.forEach { context.delete($0) }
        appDelegate.saveContext()
    }
    
    func fetchCharacters() -> [CharacterEntity]? {
        let fetchRequest: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            debugPrint("Error fetching characters")
            return []
        }
    }
    
    func fetchStarships() -> [StarshipEntity]? {
        let fetchRequest: NSFetchRequest<StarshipEntity> = StarshipEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            debugPrint("Error fetching starships")
            return []
        }
    }
    
    func fetchPlanets() -> [PlanetEntity]? {
        let fetchRequest: NSFetchRequest<PlanetEntity> = PlanetEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            debugPrint("Error fetching planets")
            return []
        }
    }
    
    func deleteAllRecords() {
        let deleteFetchCharacter: NSFetchRequest<NSFetchRequestResult>? = CharacterEntity.fetchRequest()
        let deleteFetchStarship: NSFetchRequest<NSFetchRequestResult>? = StarshipEntity.fetchRequest()
        let deleteFetchPlanet: NSFetchRequest<NSFetchRequestResult>? = PlanetEntity.fetchRequest()

        let requestsToDelete = [deleteFetchCharacter, deleteFetchStarship, deleteFetchPlanet]
        requestsToDelete.forEach {
            guard let request = $0 else { return }
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(deleteRequest)
                appDelegate.saveContext()
            } catch {
                print ("Error while deleting")
            }
        }

    }
}
