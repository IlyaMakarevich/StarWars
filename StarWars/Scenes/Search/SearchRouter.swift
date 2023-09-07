//
//  SearchRouter.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import Foundation

protocol SearchViewRouter {
    func presentDetailsView()
}

final class SearchViewRouterImpl: SearchViewRouter {
    
    private weak var searchViewController: SearchViewController?
    
    init(searchViewController: SearchViewController) {
        self.searchViewController = searchViewController
    }
    
    func presentDetailsView() {
        //
    }
}
