//
//  TableViewCell.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import UIKit

open class TableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    open func setupView() {}
}
