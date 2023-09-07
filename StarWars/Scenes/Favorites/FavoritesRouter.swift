//
//  FavoritesRouter.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//

import Foundation

protocol FavoritesRouter {
    func presentDetailsView()
}

final class FavoritesRouterImpl: FavoritesRouter {
    
    private weak var favoritesViewController: FavoritesViewController?
    
    init(favoritesViewController: FavoritesViewController) {
        self.favoritesViewController = favoritesViewController
    }
    
    func presentDetailsView() {
        //
    }
}

