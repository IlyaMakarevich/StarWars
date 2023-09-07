//
//  FavoriteCheckerUseCase.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//

import Foundation

struct FavoriteInfos {
    let people: [CharacterInfo]
    let starships: [StarshipInfo]
    let planets: [PlanetInfo]
    
    var hasItems: Bool {
        return people.count > 0 || starships.count > 0 || planets.count > 0
    }
}

protocol FavoriteCheckerUseCase {
    @discardableResult
    func fetchAllInfos() -> FavoriteInfos
    func isCharacterFavorite(with name: String) -> Bool
    func isStarshipFavorite(with name: String) -> Bool
    func isPlanetFavorite(with name: String) -> Bool
}

final class FavoriteCheckerUseCaseImpl: FavoriteCheckerUseCase {
    private var favoriteCharacters = [CharacterInfo]()
    private var favoriteStarships = [StarshipInfo]()
    private var favoritePlanets = [PlanetInfo]()
    
    func isCharacterFavorite(with name: String) -> Bool {
        return favoriteCharacters.first { $0.name == name} != nil
    }
    
    func isStarshipFavorite(with name: String) -> Bool {
        return favoriteStarships.first { $0.name == name} != nil
    }
    
    func isPlanetFavorite(with name: String) -> Bool {
        return favoritePlanets.first { $0.name == name} != nil
    }
    
    @discardableResult
    func fetchAllInfos() -> FavoriteInfos {
        favoriteCharacters = getCharacters()
        favoriteStarships = getStarships()
        favoritePlanets = getPlanets()
        return .init(people: favoriteCharacters,
                     starships: favoriteStarships,
                     planets: favoritePlanets)
    }
    
    private func getCharacters() -> [CharacterInfo] {
        guard let entities = CoreDataManager.shared.fetchCharacters() else {
            return []
        }
        let charactersInfos = entities.map {
            return CharacterInfo(name: $0.name ?? "",
                                 gender: $0.gender ?? "",
                                 shipsCount: Int($0.shipsCount))
        }
        return charactersInfos
    }
    
    private func getStarships() -> [StarshipInfo] {
        guard let entities = CoreDataManager.shared.fetchStarships() else {
            return []
        }
        let starshipInfos = entities.map {
            return StarshipInfo(name: $0.name ?? "",
                                model: $0.model ?? "",
                                producer: $0.producer ?? "",
                                passengers: $0.passengers ?? "")
        }
        return starshipInfos
    }
    
    private func getPlanets() -> [PlanetInfo] {
        guard let entities = CoreDataManager.shared.fetchPlanets() else {
            return []
        }
        let charactersInfos = entities.map {
            return PlanetInfo(name: $0.name ?? "",
                              diameter: $0.diameter ?? "",
                              population: $0.population ?? "")
        }
        return charactersInfos
    }
}
