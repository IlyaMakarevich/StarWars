//
//  Collection+Extensions.swift
//  StarWars
//
//  Created by Ilya Makarevich on 6.09.23.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
