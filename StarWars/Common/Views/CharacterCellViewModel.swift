//
//  SearchResultCellViewModel.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

struct CharacterCellInfo {
    let name: String
    let gender: String
    let shipsCount: Int
    let favoriteChecker: FavoriteCheckerUseCase?
}

struct CharacterCellViewModel: TableViewCellModelable {

    typealias Item = CharacterCellInfo
    typealias Cell = CharacterCell

    var registrationInfo: RegistrationInfo = RegistrationInfo.fromClass(Cell.self)

    let item: Item
    var selectHandler: (() -> Void)

    var rowHeight: CGFloat {
        return UITableView.automaticDimension
    }

    var diffKey: String {
        return ""
    }

    init(item: Item, selectHandler: @escaping (() -> Void)) {
        self.item = item
        self.selectHandler = selectHandler
    }

    func apply(cell: UITableViewCell) {
        guard let cell = cell as? Cell else {
            return
        }

        cell.setName(item.name)
        cell.setGender(item.gender)
        cell.setShipsCount(item.shipsCount)
        cell.setFavoriteState(item.favoriteChecker?.isCharacterFavorite(with: item.name))
        cell.selectHandler = {
            selectHandler()
        }
        cell.accessibilityIdentifier = "characterCell"
    }
}
