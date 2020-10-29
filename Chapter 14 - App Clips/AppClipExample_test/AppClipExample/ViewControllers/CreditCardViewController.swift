//
//  CreditCardViewController.swift
//  AppClipExample
//
//  Created by Mario Eguiluz on 20/10/2020.
//

import UIKit

class CreditCardViewController: UIViewController {

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
          self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
      )
    )
    present(alert, animated: true, completion: nil)
  }
}
