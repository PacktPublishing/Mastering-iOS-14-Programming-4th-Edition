//
//  ViewController.swift
//  CombineExample
//
//  Created by Mario Eguiluz on 10/09/2020.
//

import UIKit
import Combine

class ViewController: UIViewController {

  @IBOutlet var signupButton: UIButton!
  var signupButtonCancellable: AnyCancellable?

  @Published var initialEmail: String = ""
  @Published var repeatedEmail: String = ""

  var validatedEmail: AnyPublisher<String?, Never> {
    return Publishers
      .CombineLatest($initialEmail, $repeatedEmail) //1
      .map { (email, repeatedEmail) -> String? in  //2
        guard email == repeatedEmail, email.contains("@"), email.count > 5 else { return nil }
        return email
      }
      .eraseToAnyPublisher() //3
  }
  var cancellable: AnyCancellable? //4

  var isNewEmail: AnyPublisher<Bool, Never> { //1
    return $initialEmail //2
      .debounce(for: 1, scheduler: RunLoop.main) //3
      .removeDuplicates() //4
      .flatMap { email in //5
        return Future { promise in
          self.emailAvailable(email) { available in
            promise(.success(available))
          }
        }
      }
      .eraseToAnyPublisher() //6
  }

  var finalEmail: AnyPublisher<String?, Never> {
    return Publishers.CombineLatest(validatedEmail, isNewEmail).map { (email, isNew) -> String? in
      guard isNew else { return nil }
      return email
    }
    .eraseToAnyPublisher()
  }

  private func emailAvailable(_ email:String, completion: (Bool) -> Void) {
    completion(true)
  }

  @IBAction func emailChanged(_ sender: UITextField) {
    initialEmail = sender.text ?? ""
  }

  @IBAction func repeatedEmailChanged(_ sender: UITextField) {
    repeatedEmail = sender.text ?? ""
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    signupButtonCancellable = finalEmail
      .map { $0 != nil }
      .receive(on: RunLoop.main)
      .assign(to: \.isEnabled, on: signupButton)
  }

}
