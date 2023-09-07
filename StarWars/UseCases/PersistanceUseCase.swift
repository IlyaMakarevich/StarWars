//
//  PersistanceUseCase.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//

import Foundation

protocol PersistanceUseCase {
    func saveCharacter(_ character: CharacterInfo)
    func deleteCharacter(_ characterName: String)
    func saveStarship(_ starship: StarshipInfo)
    func deleteStarship(_ starshipName: String)
    func savePlanet(_ planet: PlanetInfo)
    func deletePlanet(_ planetName: String)
}

final class PersistanceUseCaseImpl: PersistanceUseCase {
    func saveCharacter(_ character: CharacterInfo) {
        CoreDataManager.shared.saveCharacter(name: character.name,
                                             gender: character.gender,
                                             shipsCount: character.shipsCount)
    }
    
    func deleteCharacter(_ characterName: String) {
        CoreDataManager.shared.deleteCharacter(name: characterName)
    }
    
    func saveStarship(_ starship: StarshipInfo) {
        CoreDataManager.shared.saveStarship(name: starship.name,
                                            model: starship.model,
                                            producer: starship.producer,
                                            passengers: starship.passengers)
    }
    
    func deleteStarship(_ starshipName: String) {
        CoreDataManager.shared.deleteStarship(name: starshipName)
    }
    
    func savePlanet(_ planet: PlanetInfo) {
        CoreDataManager.shared.savePlanet(name: planet.name,
                                          diameter: planet.diameter,
                                          population: planet.population)
    }
    
    func deletePlanet(_ planetName: String) {
        CoreDataManager.shared.deletePlanet(name: planetName)
    }
}
