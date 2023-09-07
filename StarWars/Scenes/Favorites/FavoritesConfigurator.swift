//
//  FavoritesConfigurator.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//

import Foundation

protocol FavoritesConfigurator {
    func configure(favoritesViewController: FavoritesViewController)
}

class FavoritesConfiguratorImpl: FavoritesConfigurator {
    func configure(favoritesViewController: FavoritesViewController) {
        let favoriteCheckerUseCase = FavoriteCheckerUseCaseImpl()
        let router = FavoritesRouterImpl(favoritesViewController: favoritesViewController)
        let presenter = FavoritesPresenterImpl(view: favoritesViewController,
                                               favoriteCheckerUseCase: favoriteCheckerUseCase,
                                               router: router)
        favoritesViewController.presenter = presenter
    }
    
    
}

