//
//  EntryTableViewCell.swift
//  todo_start
//
//  Created by Mario Eguiluz on 17/02/2021.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
  @IBOutlet weak var labelText: UILabel!
  @IBOutlet weak var switchDone: UISwitch!
  @IBOutlet weak var pickerPriority: UIPickerView!

  override class func awakeFromNib() {
    super.awakeFromNib()
  }

  func configure(with entry: Entry) {
    labelText.text = entry.text
    switchDone.setOn(entry.done, animated: true)
    pickerPriority.selectRow(entry.priority.rawValue, inComponent: 0, animated: true)
  }
}

extension EntryTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 3
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Priority.name(for: row)
  }
}
