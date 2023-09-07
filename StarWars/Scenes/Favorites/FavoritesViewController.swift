//
//  FavoritesViewController.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController, FavoritesView {
    var configurator = FavoritesConfiguratorImpl()
    var presenter: FavoritesPresenter!

    private let tableView = UITableView()
    
    private var shownSections = [TableViewSectionModel]()

    private let noResultsLabel = UILabel().with {
        $0.text = "You have no favorites. Add It on Search screen"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .black.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    
    private lazy var tableViewManager: TableViewManager = {
        let manager = TableViewManager(tableView: tableView)
        manager.isEditable = false
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(favoritesViewController: self)
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "green")
        title = "Favorites"
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(noResultsLabel)
        noResultsLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.centerX.equalToSuperview()
        }
    }

    
    func showResult(_ result: FavoriteInfos) {
        guard result.hasItems else {
            noResultsLabel.isHidden = false
            tableViewManager.sections = []
            return
        }
        
        noResultsLabel.isHidden = true
        let peopleModels: [TableViewCellModelable] = result.people.map {
            let characterItem = CharacterCellInfo(name: $0.name,
                                                  gender: $0.gender,
                                                  shipsCount: $0.shipsCount,
                                                  favoriteChecker: nil)
            return CharacterCellViewModel(item: characterItem,
                                          selectHandler: {})
        }
                                          
        
        let starshipModels: [TableViewCellModelable] = result.starships.map {
            let starshipItem = StarshipCellInfo(name: $0.name,
                                                model: $0.model,
                                                producer: $0.producer,
                                                passengers: $0.passengers,
                                                favoriteChecker: nil)
            return StarshipViewModel(item: starshipItem, selectHandler: {})
        }
        
        let planetsModel: [TableViewCellModelable] = result.planets.map {
            return PlanetViewModel(item: .init(name: $0.name,
                                               diameter: $0.diameter,
                                               population: $0.population,
                                               favoriteChecker: nil), selectHandler: {})
        }
        
        var resultsSections = [TableViewSectionModel]()
        
        if !peopleModels.isEmpty {
            let peopleHeader = HeaderViewModel(item: .init(title: "Characters"))
            let peopleSection = TableViewSectionModel(headerModel: peopleHeader, models: peopleModels)
            resultsSections.append(peopleSection)
        }
    
        if !starshipModels.isEmpty {
            let starshipHeader = HeaderViewModel(item: .init(title: "Starships"))
            let starshipSection = TableViewSectionModel(headerModel: starshipHeader, models: starshipModels)
            resultsSections.append(starshipSection)
        }
        
        if !planetsModel.isEmpty {
            let planetHeader = HeaderViewModel(item: .init(title: "Planets"))
            let planetSection = TableViewSectionModel(headerModel: planetHeader, models: planetsModel)
            resultsSections.append(planetSection)
        }
       
        shownSections = resultsSections
        tableViewManager.sections = resultsSections
    }
}


