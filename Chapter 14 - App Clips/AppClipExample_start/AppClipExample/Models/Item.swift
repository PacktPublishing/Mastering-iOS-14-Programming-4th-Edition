//
//  Item.swift
//  AppClipExample
//
//  Created by Mario Eguiluz on 18/10/2020.
//

import UIKit

enum Item {
  case coffee
  case mocha
  case espresso

  func image() -> UIImage {
    switch self {
    case .coffee:
      return UIImage(named: "coffeeSmall")!
    case .mocha:
      return UIImage(named: "mochaSmall")!
    case .espresso:
      return UIImage(named: "espressoSmall")!
    }
  }

  func title() -> String {
    switch self {
    case .coffee:
      return "Regular Coffee"
    case .mocha:
      return "Mocha"
    case .espresso:
      return "Espresso"
    }
  }

  func price() -> String {
    switch self {
    case .coffee:
      return "$3"
    case .mocha:
      return "$4"
    case .espresso:
      return "$2.5"
    }
  }
}
