//
//  FavoritesPresenter.swift
//  StarWars
//
//  Created by Ilya Makarevich on 7.09.23.
//

import Foundation

protocol FavoritesView: AnyObject {
    func showResult(_ result: FavoriteInfos)
}

protocol FavoritesPresenter {
    func viewDidLoad()
}

final class FavoritesPresenterImpl: FavoritesPresenter {
    private weak var view: FavoritesView?
    private var favoriteCheckerUseCase: FavoriteCheckerUseCase
    
    private let router: FavoritesRouter
    
    private lazy var allItems = {
        let allItems = favoriteCheckerUseCase.fetchAllInfos()
        return allItems
    }()
    
    init(view: FavoritesView,
         favoriteCheckerUseCase: FavoriteCheckerUseCase,
         router: FavoritesRouter) {
        self.view = view
        self.favoriteCheckerUseCase = favoriteCheckerUseCase
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showResult(allItems)
    }
    
}
