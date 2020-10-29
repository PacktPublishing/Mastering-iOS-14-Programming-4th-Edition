//
//  PaymentViewController.swift
//  AppClipExample
//
//  Created by Mario Eguiluz on 06/10/2020.
//

import UIKit

class PaymentViewController: UIViewController {

  @IBOutlet private var buttonItem: UIButton!
  @IBOutlet private var buttonPayByApplePay: UIButton!
  @IBOutlet private var buttonPayByCard: UIButton!
  @IBOutlet private var labelTotal: UILabel!
  @IBOutlet private var labelItem: UILabel!

  var item: Item!

  class func create(with item: Item) -> PaymentViewController? {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
      vc?.item = item
      return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    buttonItem.setImage(item.image(), for: .normal)
    labelTotal.text = "Total: \(item.price())"
    labelItem.text = item.title()
  }

  @IBAction func pay(sender: Any?) {
    let alert = UIAlertController(
      title: "Payment",
      message: "Payment is completed, thanks!",
      preferredStyle: UIAlertController.Style.alert)
    alert.addAction(
      UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.default,
        handler: { action in
          self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
      )
    )
    present(alert, animated: true, completion: nil)
  }
}
