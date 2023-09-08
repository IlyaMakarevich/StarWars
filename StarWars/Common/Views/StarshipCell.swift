//
//  StarshipCell.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit
import SnapKit
import Combine


class StarshipCell: TableViewCell {
    
    var selectHandler: (() -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let favoriteButton = UIButton()
    
    private let nameLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.numberOfLines = 1
    }
    
    private let modelLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let producerLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let passengersLabel = UILabel().with {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 1
    }
    
    func setName(_ text: String) {
        nameLabel.text = "Name: " + text
    }
    
    func setModel(_ text: String) {
        modelLabel.text = "Model: " + text
    }
    
    func setProducer(_ text: String) {
        producerLabel.text = "Manufacturer: " + String(text)
    }
    
    func setPassengers(_ text: String) {
        passengersLabel.text = "Passengers count: " + String(text)
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
        labelsStack.distribution = .equalCentering
        labelsStack.addArrangedSubviews([nameLabel, modelLabel, producerLabel, passengersLabel])

        contentView.addSubview(labelsStack)
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
    
    private func bindUI() {
        favoriteButton.tapPublisher()
            .sink { [weak self] in
                guard let self else { return }
                self.setFavoriteState(!self.isFavorite)
                self.selectHandler?()
            }
            .store(in: &cancellables)
    }
}
