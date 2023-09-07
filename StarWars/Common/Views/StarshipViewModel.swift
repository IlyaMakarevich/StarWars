//
//  StarshipViewModel.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

struct StarshipCellInfo {
    let name: String
    let model: String
    let producer: String
    let passengers: String
    let favoriteChecker: FavoriteCheckerUseCase?
}

struct StarshipViewModel: TableViewCellModelable {

    typealias Item = StarshipCellInfo
    typealias Cell = StarshipCell

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
        cell.setModel(item.model)
        cell.setProducer(item.producer)
        cell.setPassengers(item.passengers)
        cell.setFavoriteState(item.favoriteChecker?.isStarshipFavorite(with: item.name))
        cell.selectHandler = {
            selectHandler()
        }
        cell.accessibilityIdentifier = "starshipCell"
    }
}
