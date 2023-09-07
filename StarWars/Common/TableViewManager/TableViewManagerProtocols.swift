//
//  TableViewManagerProtocols.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

// Protocol for sections info. Each section contains section models

public struct TableViewSectionModel {
    public var headerModel: TableHeaderModelable?
    public var models: [TableViewCellModelable]

    public init (headerModel: TableHeaderModelable?, models: [TableViewCellModelable]) {
        self.headerModel = headerModel
        self.models = models
    }
}

// Protocol for cell info

public enum RegistrationInfo {
    case fromClass(AnyClass)
    case fromNib(name: String, bundle: Bundle?)

    public var nib: UINib? {
        switch self {
        case let .fromNib(name, bundle):
            return UINib(nibName: name, bundle: bundle)
        case .fromClass:
            return nil
        }
    }

    public var reuseIdentifier: String {
        switch self {
        case let .fromNib(name, _):
            return name
        case let .fromClass(className):
            return String(describing: className)
        }
    }
}

public protocol TableViewCellModelable {
    var rowHeight: CGFloat { get }
    var registrationInfo: RegistrationInfo { get }
    var diffKey: String { get }

    func apply(cell: UITableViewCell)
}

// Protocol for header info

public protocol TableHeaderModelable {
    var headerHeight: CGFloat { get }
    var registrationInfo: RegistrationInfo { get }

    func apply(view: UIView)
}

// Protocol for table view info. There may be sections or just models so it means just one section

public protocol TableViewManagerable {
    var sections: [TableViewSectionModel]? { get set }
    var models: [TableViewCellModelable]? { get set }

    func indexPath(for model: TableViewCellModelable) -> IndexPath?
}
