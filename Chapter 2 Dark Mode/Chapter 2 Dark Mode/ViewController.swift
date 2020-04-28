//
//  ViewController.swift
//  Chapter 2 Dark Mode
//
//  Created by Chris Barker on 22/04/2020.
//  Copyright © 2020 Packt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var tertiaryLabel: UILabel!
    
    @IBOutlet weak var linkButton: UIButton!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primaryLabel.textColor = UIColor.brandLabel
        secondaryLabel.textColor = UIColor.brandSecondaryLabel
        tertiaryLabel.textColor = UIColor.brandTertiaryLabel
        
        linkButton.titleLabel?.textColor = UIColor.link
        
        separatorView.backgroundColor = UIColor.separator
        
        tableView.backgroundColor = UIColor.systemGroupedBackground
        
        headerImageView.image = UIImage.header
                
        for window in UIApplication.shared.windows {
            window.overrideUserInterfaceStyle = .dark
        }

    }
    
    // Trait change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let interfaceAppearanceChanged = previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection)
        print("Has changed: \(interfaceAppearanceChanged ?? false)")
    }
    
}

extension UIColor {
    static var brandLabel: UIColor {
        return UIColor(named: "brandLabel") ?? UIColor.label
    }
    static var brandSecondaryLabel: UIColor {
        return UIColor(named: "brandSecondaryLabel") ?? UIColor.label
    }
    static var brandTertiaryLabel: UIColor {
        return UIColor(named: "brandTertiaryLabel") ?? UIColor.label
    }
}

extension UIImage {
    static var header: UIImage {
        return UIImage(named: "header") ?? UIImage()
    }
}

