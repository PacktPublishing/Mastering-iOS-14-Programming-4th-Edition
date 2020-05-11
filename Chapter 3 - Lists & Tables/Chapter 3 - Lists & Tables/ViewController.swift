//
//  ViewController.swift
//  Chapter 3 - Lists & Tables
//
//  Created by Chris Barker on 09/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        requestContacts()
    }
    
    private func requestContacts() {
        
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        if authorizationStatus == .notDetermined {
            store.requestAccess(for: .contacts) { [weak self] didAuthorize, error in
                if didAuthorize {
                    self?.retrieveContacts(from: store)
                }
            }
        } else if authorizationStatus == .authorized {
            retrieveContacts(from: store)
        }
        
    }
    
    private func retrieveContacts(from store: CNContactStore) {
        
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                           CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor]
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = contacts[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        cell.setup(contact: contact)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contacts[indexPath.row]
        let alertController = UIAlertController(title: "Contact Details",
                                                message: "Hey \(contact.givenName)!!",
                                                preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Done", style: .default, handler: { action in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        
        alertController.addAction(dismissAction);
        present(alertController, animated: true, completion: nil)
        
    }
    
    
}

class ContactCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var conatctImageView: UIImageView!
    
    func setup(contact: CNContact) {
        nameLabel.text = contact.givenName
        if let imageData = contact.imageData {
            conatctImageView.image = UIImage(data: imageData)
        } else {
            conatctImageView.image = UIImage(systemName: "person.circle")
        }
    }
    
}

