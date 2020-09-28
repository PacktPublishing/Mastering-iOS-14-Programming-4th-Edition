//
//  ViewController.swift
//  PublishersAndSubscribers
//
//  Created by Mario Eguiluz on 11/09/2020.
//

import UIKit
import Combine

struct User: Codable {
  let id: String

  static var unknown: User {
    return User(id: "-1")
  }
}

class ViewController: UIViewController {

  private var cancellable: AnyCancellable?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func postNotification() {
    let networkResponse = try! JSONEncoder().encode(User(id: "123"))
    NotificationCenter.default.post(name: Notification.Name("networkResult"), object: networkResponse)
  }

  private func postNotificationThatFails() {
    let networkResponse = Data(base64Encoded: "abcd")!
    NotificationCenter.default.post(name: Notification.Name("networkResult"), object: networkResponse)
  }
}
