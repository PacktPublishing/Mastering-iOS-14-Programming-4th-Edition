//
//  DetailsViewController.swift
//  Contacts App
//
//  Created by Chris Barker on 11/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit
import Contacts

class DetailsViewController: UIViewController {

    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var contactPhoneNumber: UILabel!
    @IBOutlet weak var contactEmailAddress: UILabel!
    @IBOutlet weak var contactAddress: UILabel!
    
    var contact: ContactModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactImageView.image = contact?.contactImage
        contactName.text = contact?.fullName
        contactPhoneNumber.text = contact?.primaryPhoneNumber
        contactEmailAddress.text = contact?.primaryEmailAddress
        contactAddress.text = contact?.addressLine1
    }
    
}
