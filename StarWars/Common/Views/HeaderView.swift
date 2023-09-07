//
//  HeaderView.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

struct HeaderInfo {
    let title: String
}

final class HeaderView: UITableViewHeaderFooterView {

    var title: String? {
        didSet {
            label.text = title
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private let label = UILabel().with {
        $0.textColor = .black
    }

    func setupView() {
        contentView.backgroundColor = .black.withAlphaComponent(0.1)
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
