//
//  UIEdgeInsets+Extensions.swift
//  StarWars
//
//  Created by Ilya Makarevich on 5.09.23.
//

import UIKit

extension UIEdgeInsets {

  static func top(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: size, left: 0, bottom: 0, right: 0)
  }

  static func left(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: size, bottom: 0, right: 0)
  }

  static func bottom(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: size, right: 0)
  }

  static func right(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: size)
  }

  static func vertical(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: size, left: 0, bottom: size, right: 0)
  }

  static func horizontal(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: size, bottom: 0, right: size)
  }

  static func all(_ size: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(top: size, left: size, bottom: size, right: size)
  }

  func top(_ size: CGFloat) -> UIEdgeInsets {
    var other = self
    other.top = size
    return other
  }

  func left(_ size: CGFloat) -> UIEdgeInsets {
    var other = self
    other.left = size
    return other
  }

  func bottom(_ size: CGFloat) -> UIEdgeInsets {
    var other = self
    other.bottom = size
    return other
  }

  func right(_ size: CGFloat) -> UIEdgeInsets {
    var other = self
    other.right = size
    return other
  }

  func vertical(_ size: CGFloat) -> UIEdgeInsets {
    var other = self
    other.top = size
    other.bottom = size
    return other
  }

  func horizontal(_ size: CGFloat) -> UIEdgeInsets {
    var other = self
    other.left = size
    other.right = size
    return other
  }

  var inverted: UIEdgeInsets {
    return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
  }

  func inset(rect: CGRect) -> CGRect {
    return rect.inset(by: self)
  }

  func inset(size: CGSize) -> CGSize {
    let rect = CGRect(origin: .zero, size: size)
    return rect.inset(by: self).size
  }
}

