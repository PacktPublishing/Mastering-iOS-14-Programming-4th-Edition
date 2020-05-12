//
//  ContactModel.swift
//  Contacts App
//
//  Created by Chris Barker on 11/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit
import Contacts

struct ContactModel {
    
    var fullName: String?
    var primaryPhoneNumber: String?
    var primaryEmailAddress: String?
    var addressLine1: String?
    var contactImage: UIImage?
    
    init(_ contact: CNContact) {
        fullName = "\(contact.givenName) \(contact.familyName)"
        primaryPhoneNumber = contact.phoneNumbers.first?.value.stringValue
        primaryEmailAddress = contact.emailAddresses.first?.value as String?
        addressLine1 = contact.postalAddresses.first?.value.street
        contactImage = UIImage(data: contact.imageData ?? Data()) ?? UIImage(systemName: "person.circle")
    }
    
}
