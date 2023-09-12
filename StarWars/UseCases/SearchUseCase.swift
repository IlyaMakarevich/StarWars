//
//  SearchUseCase.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import Combine
import Alamofire

struct SearchScreenItems {
    let people: InfoCharacters?
    let starships: InfoStarships?
    let planets: InfoPlanets?
    
    var hasItems: Bool {
        return people?.count ?? 0 > 0 || starships?.count ?? 0 > 0 || planets?.count ?? 0 > 0
    }
}

protocol SearchUseCase {
    func search(by text: String) -> AnyPublisher<SearchScreenItems, Never>
}

class SearchUseCaseImp: SearchUseCase {
    private var cancellables = Set<AnyCancellable>()
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func search(by text: String) -> AnyPublisher<SearchScreenItems, Never> {
        let characterSearch = apiService.searchCharacter(by: text)
        let starshipSearch = apiService.searchStarship(by: text)
        let planetSearch = apiService.searchPlanet(by: text)
        
        return Publishers.Zip3(characterSearch, starshipSearch, planetSearch)
            .map { char, starship, planet in
                if char.error != nil || starship.error != nil || planet.error != nil {
                    return .init(people: nil, starships: nil, planets: nil)
                }
                let result = SearchScreenItems(people: char.value,
                                               starships: starship.value,
                                               planets: planet.value)
                return result
            }
            .eraseToAnyPublisher()
    }
}
