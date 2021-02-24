//
//  MasterViewController.swift
//  todo_start
//
//  Created by Mario Eguiluz on 16/02/2021.
//

import UIKit

protocol CategorySelectionDelegate: class {
  func selected(category: Category)
}

class MasterViewController: UITableViewController {

  let datasource = Datasource()
  var categories: [Category] = []
  weak var delegate: CategorySelectionDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    categories = datasource.load()
    tableView.tableFooterView = UIView()
    tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! CategoryTableViewCell
    let category = categories[indexPath.row]
    cell.configure(with: category)
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedCategory = categories[indexPath.row]
    delegate?.selected(category: selectedCategory)

    if let detailViewController = delegate as? DetailViewController,
       let detailNavigationController = detailViewController.navigationController {
      splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
      detailViewController.title = selectedCategory.title
    }
  }
}
