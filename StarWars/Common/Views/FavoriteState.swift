//
//  FavoriteState.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

enum FavoriteState {
    case favorite
    case notFavorite
    
    var image: UIImage? {
        switch self {
        case .favorite:
            return UIImage(named: "favorite")
        case .notFavorite:
            return UIImage(named: "notfavorite")
        }
    }
}
