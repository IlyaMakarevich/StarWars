//
//  SearchPresenter.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation
import Combine

enum SearchItemType {
    case character(CharacterInfo)
    case starship(StarshipInfo)
    case planet(PlanetInfo)
}

protocol SearchView: AnyObject {
    func showResult(_ result: SearchScreenItems, favoriteCheckerUseCase: FavoriteCheckerUseCase)
    func showErrorState(error: SearchError)
    func resetTable()
    
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol SearchPresenter {
    var searchedItems: SearchScreenItems { get }
    func viewDidLoad()
    func search(text: String)
    func resetResults()
    
    func save(_ item: SearchItemType)
    func deleteCharacter(_ name: String)
    func deleteStarship(_ name: String)
    func deletePlanet(_ name: String)
}

final class SearchPresenterImpl: SearchPresenter {
    
    private weak var view: SearchView?
    private var searchUseCase: SearchUseCase
    private var persistanceUseCase: PersistanceUseCase
    private var favoriteCheckerUseCase: FavoriteCheckerUseCase
    
    private let router: SearchViewRouter
    
    private var cancellables = Set<AnyCancellable>()
    
    var searchedItems: SearchScreenItems = .init(people: nil, starships: nil, planets: nil)
    
    init(view: SearchView,
         searchUseCase: SearchUseCase,
         persistanceUseCase: PersistanceUseCase,
         favoriteCheckerUseCase: FavoriteCheckerUseCase,
         router: SearchViewRouter) {
        self.view = view
        self.searchUseCase = searchUseCase
        self.persistanceUseCase = persistanceUseCase
        self.favoriteCheckerUseCase = favoriteCheckerUseCase
        self.router = router
    }
    
    func viewDidLoad() {
    }
    
    func search(text: String) {
        guard ReachabilityService.isConnectedToInternet else {
            view?.showErrorState(error: .connection)
            return
        }
        
        guard text.count > 1 else { return }
        
        view?.showActivityIndicator()
        searchUseCase.search(by: text)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                
                self.view?.hideActivityIndicator()
                if result.people == nil && result.starships == nil && result.planets == nil {
                    self.view?.showErrorState(error: .server)
                } else {
                    self.favoriteCheckerUseCase.fetchAllInfos()
                    self.view?.showResult(result,
                                          favoriteCheckerUseCase: self.favoriteCheckerUseCase)
                }
            }
            .store(in: &cancellables)
    }
    
    func resetResults() {
        searchedItems = .init(people: nil, starships: nil, planets: nil)
        view?.resetTable()
    }
    
    func save(_ item: SearchItemType) {
        switch item {
        case .character(let characterInfo):
            persistanceUseCase.saveCharacter(characterInfo)
        case .starship(let starshipInfo):
            persistanceUseCase.saveStarship(starshipInfo)
        case .planet(let planetInfo):
            persistanceUseCase.savePlanet(planetInfo)
        }
        favoriteCheckerUseCase.fetchAllInfos()
    }
    
    func deleteCharacter(_ name: String) {
        persistanceUseCase.deleteCharacter(name)
    }
    
    func deleteStarship(_ name: String) {
        persistanceUseCase.deleteStarship(name)
    }
    
    func deletePlanet(_ name: String) {
        persistanceUseCase.deletePlanet(name)
    }
}
