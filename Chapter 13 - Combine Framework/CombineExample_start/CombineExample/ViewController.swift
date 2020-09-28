//
//  ViewController.swift
//  CombineExample
//
//  Created by Mario Eguiluz on 10/09/2020.
//

import UIKit
import Combine

class ViewController: UIViewController {

  @Published var initialEmail: String = ""
  @Published var repeatedEmail: String = ""

  var signupButtonCancellable: AnyCancellable?

  @IBOutlet var signupButton: UIButton!

  @IBAction func emailChanged(_ sender: UITextField) {
    initialEmail = sender.text ?? ""
  }

  @IBAction func repeatedEmailChanged(_ sender: UITextField) {
    repeatedEmail = sender.text ?? ""
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func emailAvailable(_ email:String, completion: (Bool) -> Void) {
    //Simulates a call to the network that returns a completion (Bool) indicating
    //if the email address is available to use
    completion(true)
  }
}
