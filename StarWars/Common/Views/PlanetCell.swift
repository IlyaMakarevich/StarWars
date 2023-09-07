//
//  PlanetCell.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit
import SnapKit
import Combine

class PlanetCell: TableViewCell {
    
    var selectHandler: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    private let favoriteButton = UIButton()
    
    private let nameLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.numberOfLines = 0
    }
    
    private let diameterLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let populationLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
    }
    
    func setName(_ text: String) {
        nameLabel.text = "Name: " + text
    }
    
    func setDiameter(_ text: String) {
        diameterLabel.text = "Diameter: " + text
    }
    
    func setPopulation(_ text: String) {
        populationLabel.text = "Population: " + String(text)
    }
    
    func setFavoriteState(_ isFavorite: Bool?) {
        guard let isFavorite else {
            favoriteButton.isHidden = true
            return
        }
        let image = isFavorite ? UIImage(named: "favorite") : UIImage(named: "notfavorite")
        favoriteButton.setImage(image, for: .normal)
        self.isFavorite = isFavorite
    }
    private var isFavorite: Bool = false
    
    
    override func setupView() {
        super.setupView()
        bindUI()
        
        backgroundColor = .white

        let labelsStack = UIStackView()
        labelsStack.spacing = 10
        labelsStack.axis = .vertical
        labelsStack.distribution = .fillProportionally

        labelsStack.addArrangedSubviews([nameLabel, diameterLabel, populationLabel])
        
        contentView.addSubview(labelsStack)
        
        nameLabel.snp.contentCompressionResistanceVerticalPriority = .greatestFiniteMagnitude
        
        labelsStack.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(80)
        }
        
        contentView.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(28)
        }
    }
    
    func bindUI() {
        favoriteButton.tapPublisher()
            .sink { [weak self] in
                guard let self else { return }
                self.setFavoriteState(!self.isFavorite)
                self.selectHandler?()
            }
            .store(in: &cancellables)
    }
}
