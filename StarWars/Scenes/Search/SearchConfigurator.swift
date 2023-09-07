//
//  SearchConfigurator.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation

protocol SearchConfigurator {
    func configure(searchViewController: SearchViewController)
}

final class SearchConfiguratorImpl: SearchConfigurator {
    func configure(searchViewController: SearchViewController) {
        let searchUseCase = SearchUseCaseImp()
        let persistanceUseCase = PersistanceUseCaseImpl()
        let favoriteCheckerUseCase = FavoriteCheckerUseCaseImpl()
        let router = SearchViewRouterImpl(searchViewController: searchViewController)
        let presenter = SearchPresenterImpl(view: searchViewController,
                                            searchUseCase: searchUseCase,
                                            persistanceUseCase: persistanceUseCase,
                                            favoriteCheckerUseCase: favoriteCheckerUseCase,
                                            router: router)
        searchViewController.presenter = presenter
    }
    
    
}
