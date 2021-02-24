//
//  CategoryTableViewCell.swift
//  todo_start
//
//  Created by Mario Eguiluz on 17/02/2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!

  override class func awakeFromNib() {
    super.awakeFromNib()
  }

  func configure(with category: Category) {
    nameLabel.text = category.title
    amountLabel.text = "(\(category.entries.count))"
  }
}
