//
//  DetailViewController.swift
//  todo_start
//
//  Created by Mario Eguiluz on 16/02/2021.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var createButton: UIButton!

  var entries: [Entry]? {
    didSet {
      refreshUI()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if traitCollection.userInterfaceIdiom == .mac {
      navigationController?.setToolbarHidden(true, animated: false)
      createButton.target(forAction: #selector(createTapped), withSender: self)
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTapped))
      navigationController?.setToolbarHidden(false, animated: animated)
    }
  }

  @objc func createTapped(sender: Any?) {
    let alert = UIAlertController(title: "Example", message: "This is a modal alert", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    self.present(alert, animated: true)
  }

  private func refreshUI() {
    tableView?.reloadData()
  }
}

extension DetailViewController: CategorySelectionDelegate {
  func selected(category: Category) {
    title = category.title
    entries = category.entries
  }
}

// MARK: - Table view data source

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return entries?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = entries![indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath) as! EntryTableViewCell
    cell.configure(with: item)
    cell.selectionStyle = .none
    return cell
  }
}
