//
//  MenuView.swift
//  AppClipExample
//
//  Created by Mario Eguiluz on 19/10/2020.
//

import UIKit

@IBDesignable class MenuView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func prepareForInterfaceBuilder() {
    setupView()
  }

  func setupView() {
    self.layer.cornerRadius = cornerRadius
    self.layer.shadowColor = shadowColor.cgColor
    self.layer.shadowRadius = shadowRadius
    self.layer.shadowOpacity = shadowOpacity
  }

  @IBInspectable
  var cornerRadius: CGFloat = 40 {
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }

  @IBInspectable
  var shadowColor: UIColor = .black {
    didSet {
      self.layer.shadowColor = shadowColor.cgColor
    }
  }

  @IBInspectable
  var shadowRadius: CGFloat = 0 {
    didSet {
      self.layer.shadowRadius = shadowRadius
    }
  }

  @IBInspectable
  var shadowOpacity: Float = 0 {
    didSet {
      self.layer.shadowOpacity = shadowOpacity
    }
  }
}
