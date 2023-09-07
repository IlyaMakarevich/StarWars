//
//  SearchViewController.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import UIKit
import SnapKit
import Combine

enum SearchError {
    case connection
    case server
    
    var message: String {
        switch self {
        case .connection:
            return "Check your internet connection"
        case .server:
            return "Something went wrong."
        }
    }
}

class SearchViewController: UIViewController, SearchView {
    var configurator = SearchConfiguratorImpl()
    var presenter: SearchPresenter!
   
    private let searchBar = UISearchBar().with {
        $0.placeholder = "Enter search request"
    }
    private var searchBarTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private lazy var tableViewManager: TableViewManager = {
        let manager = TableViewManager(tableView: tableView)
        manager.isEditable = false
        return manager
    }()
    
    private let hintLabel = UILabel().with {
        $0.text = "Enter at least 2 symbols"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .black.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    
    private let noResultsLabel = UILabel().with {
        $0.text = "Sorry, nothing found ☹️"
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .black.withAlphaComponent(0.5)
        $0.isHidden = true
    }
    
    private let placeholderLabel = UILabel().with {
        $0.text = "🔍 Use top search bar to find  People, Planets, Spaceships"
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        $0.textColor = .black.withAlphaComponent(0.5)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(searchViewController: self)
        setupUI()
        bindUI()
        searchBar.delegate = self
    }
    
    private func setupUI() {
        title = "Search"
        view.backgroundColor = UIColor(named: "pink")
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(noResultsLabel)
        noResultsLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    private func bindUI() {
        searchBarTextSubject
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.presenter.search(text: text)
            }
            .store(in: &cancellables)
    }
    
    func showResult(_ result: SearchScreenItems, favoriteCheckerUseCase: FavoriteCheckerUseCase) {
        guard result.hasItems else {
            noResultsLabel.isHidden = false
            tableViewManager.sections = []
            return
        }
        
        noResultsLabel.isHidden = true
        let peopleModels: [TableViewCellModelable] = result.people?.results.map { char in
            let characterItem = CharacterCellInfo(name: char.name,
                                                  gender: char.gender,
                                                  shipsCount: char.starships.count,
                                                  favoriteChecker: favoriteCheckerUseCase)
            return CharacterCellViewModel(item: characterItem,
                                          selectHandler: { [weak self] in
                if favoriteCheckerUseCase.isCharacterFavorite(with: char.name) {
                    self?.presenter.deleteCharacter(char.name)
                } else {
                    self?.presenter.save(.character(.init(name: char.name,
                                                          gender: char.gender,
                                                          shipsCount: char.starships.count)))
                }
            })
        } ?? []
        
        let starshipModels: [TableViewCellModelable] = result.starships?.results.map { starship in
            let starshipItem = StarshipCellInfo(name: starship.name,
                                                model: starship.model,
                                                producer: starship.manufacturer,
                                                passengers: starship.passengers,
                                                favoriteChecker: favoriteCheckerUseCase)
            return StarshipViewModel(item: starshipItem, selectHandler: { [weak self] in
                if favoriteCheckerUseCase.isStarshipFavorite(with: starship.name) {
                    self?.presenter.deleteStarship(starship.name)
                } else {
                    self?.presenter.save(.starship(.init(name: starship.name,
                                                         model: starship.model,
                                                         producer: starship.manufacturer,
                                                         passengers: starship.passengers)))
                }
            })
        } ?? []
        
        let planetsModel: [TableViewCellModelable] = result.planets?.results.map { planet in
            return PlanetViewModel(item: .init(name: planet.name,
                                               diameter: planet.diameter,
                                               population: planet.population,
                                               favoriteChecker: favoriteCheckerUseCase), selectHandler: { [weak self] in
                if favoriteCheckerUseCase.isPlanetFavorite(with: planet.name) {
                    self?.presenter.deletePlanet(planet.name)
                } else {
                    self?.presenter.save(.planet(.init(name: planet.name,
                                                       diameter: planet.diameter,
                                                       population: planet.population)))
                }
            })
        } ?? []
        
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
       
        tableViewManager.sections = resultsSections
    }
    
    func showErrorState(error: SearchError) {
        showAlert(type: error)
        if error == .server {
            tableViewManager.sections = []
        }
    }

    
    func resetTable() {
        tableViewManager.sections = []
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        placeholderLabel.isHidden = !searchText.isEmpty
        hintLabel.isHidden = searchText.count != 1
        
        noResultsLabel.isHidden = true
        
        if searchText.count < 2 {
            presenter.resetResults()
        }
        searchBarTextSubject.send(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ".lowercased().contains(text.lowercased())
    }
}

private extension SearchViewController {
    func showAlert(type: SearchError) {
        let alert = UIAlertController(title: "Error", message: type.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
