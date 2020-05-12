//
//  ViewController.swift
//  Chapter 3 - Lists & Tables - Collection View
//
//  Created by Chris Barker on 10/05/2020.
//  Copyright © 2020 Cocoa Cabana. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                           CNContactFamilyNameKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor,
                           CNContactImageDataKey as CNKeyDescriptor,
                           CNContactEmailAddressesKey as CNKeyDescriptor,
                           CNContactPhoneNumbersKey as CNKeyDescriptor,
                           CNContactPostalAddressesKey as CNKeyDescriptor]
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contactDetailVC = segue.destination as? DetailsViewController,
            segue.identifier == "detailViewSegue",
            let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
            
            contactDetailVC.contact = ContactModel(contacts[selectedIndex.row])
            
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailViewSegue", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contact = contacts[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as? ContactCell else {
            return UICollectionViewCell()
        }
        cell.setup(contact: contact)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
//        let width = (collectionView.bounds.size.width / 2) - 10
//        return CGSize(width: width, height: 180)
    }
    
}

class ContactCell: UICollectionViewCell {
    
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var conatctImageView: UIImageView!
    
    
    func setup(contact: CNContact) {
        givenNameLabel.text = contact.givenName
        familyNameLabel.text = contact.familyName
        
        if let imageData = contact.imageData {
            conatctImageView.image = UIImage(data: imageData)
        } else {
            conatctImageView.image = UIImage(systemName: "person.circle")
        }
    }
    
}

class ContactsCollectionViewLayout: UICollectionViewLayout {
    
    override var collectionViewContentSize: CGSize {
        return .zero
    }
    
    override func prepare() {
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
}
