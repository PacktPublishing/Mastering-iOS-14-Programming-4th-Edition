//
//  MenuViewController.swift
//  AppClipExample
//
//  Created by Mario Eguiluz on 06/10/2020.
//  Images for coffee, chocolate and tea using resources from Flaticon.com
//

import UIKit

class MenuViewController: UIViewController {

  @IBOutlet private var buttonCoffee: UIButton!
  @IBOutlet private var buttonMocha: UIButton!
  @IBOutlet private var buttonEspresso: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? PaymentViewController else { return }
    destinationVC.item = item(for: segue)
  }

  @IBAction func selectedItem(sender: Any?) {
    guard let selectedButton = sender as? UIButton else { return }
    let selectedItem: Item
    switch selectedButton {
    case buttonCoffee:
      selectedItem = .coffee
    case buttonMocha:
      selectedItem = .mocha
    case buttonEspresso:
      selectedItem = .espresso
    default:
      selectedItem = .coffee
    }
    let destination = PaymentViewController.create(with: selectedItem)
    navigationController?.showDetailViewController(destination!, sender: nil)
  }
}

extension MenuViewController {
  private func item(for segue: UIStoryboardSegue) -> Item {
    switch segue.identifier {
      case "coffeeSegue": return .coffee
      case "mochaSegue": return .mocha
      case "espressoSegue": return .espresso
      default: return .coffee
    }
  }
}
