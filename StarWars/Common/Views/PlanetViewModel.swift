//
//  PlanetViewModel.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

struct PlanetCellInfo {
    let name: String
    let diameter: String
    let population: String
    let favoriteChecker: FavoriteCheckerUseCase?
}

struct PlanetViewModel: TableViewCellModelable {

    typealias Item = PlanetCellInfo
    typealias Cell = PlanetCell

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
        cell.setDiameter(item.diameter)
        cell.setPopulation(item.population)
        cell.setFavoriteState(item.favoriteChecker?.isPlanetFavorite(with: item.name))
        cell.selectHandler = {
            selectHandler()
        }
        cell.accessibilityIdentifier = "planetCell"
    }
}
