//
//  HeaderViewModel.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation
import UIKit

struct HeaderViewModel: TableHeaderModelable {

    typealias Item = HeaderInfo
    typealias View = HeaderView

    var registrationInfo: RegistrationInfo = RegistrationInfo.fromClass(View.self)

    let item: Item

    var headerHeight: CGFloat {
        return 60
    }

    init(item: Item) {
        self.item = item
    }

    func apply(view: UIView) {
        guard let view = view as? View else {
            return
        }
        view.title = item.title
    }
}
