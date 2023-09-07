//
//  MainViewController.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import UIKit
import SnapKit
import Combine

class MainViewController: UIViewController {
    
    private let backImageView = UIImageView(image: UIImage(named: "main"))
    
    private let searchButton = UIButton().with {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "pink")
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    private let favoritesButton = UIButton().with {
        $0.setTitle("Favorites", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = UIColor(named: "green")
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "lightGrey")
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        view.addSubview(backImageView)
        backImageView.pinToSuperview()
        
        let buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 10
        
        buttonsStack.addArrangedSubviews([searchButton, favoritesButton])
        
        view.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func bindUI() {
        searchButton.tapPublisher()
            .sink { _ in self.routeToSearch() }
            .store(in: &cancellables)
        
        favoritesButton.tapPublisher()
            .sink { _ in self.routeToFavorites()}
            .store(in: &cancellables)
    }
}

private extension MainViewController {
    func routeToSearch() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    func routeToFavorites() {
        let favoritesViewController = FavoritesViewController()
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}

