//
//  DetailViewController.swift
//  MyContacts
//
//  Created by Dawood Khan on 8/11/17.
//  Copyright © 2017 Dawood Khan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var detailProfileImage: UIImageView!
    @IBOutlet var detailNameLabel: UILabel!
    @IBOutlet var detailCompanyLabel: UILabel!
    
    var contact: Contacts?
    var favoriteContactsArray: [Contacts]?
    var nonFavoriteContactsArray: [Contacts]?
    var contactsArray = [String]()
    var destinationVC: ContactsTableViewController?
    var emptyRowNumber: Int?
    let detailTypeArray = ["Home", "Mobile", "Work", "ADDRESS", "BIRTHDATE", "EMAIL"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContactDetails()
        createContactsArray()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DetailTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DetailTableViewCell else {
            fatalError("The dequeued cell is not an instance of DetailTableViewCell.")
        }
        
        if (contactsArray[indexPath.row] == "empty") {emptyRowNumber = indexPath.row}
        if (indexPath.row < 3 && contactsArray[indexPath.row] != "empty") {
            cell.phoneTypeLabel.text = detailTypeArray[indexPath.row]
            cell.dataTypeLabel.text = "PHONE"
        } else {
            cell.dataTypeLabel.text = detailTypeArray[indexPath.row]
        }
        cell.dataLabel.text = contactsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        if(indexPath.row == emptyRowNumber){
            rowHeight = 0.0
        }
        else{
            rowHeight = 90.0
        }
        return rowHeight
    }

    fileprivate func loadContactDetails() {
        if let url = URL.init(string: (contact?.largeImageURL)!) {
            detailProfileImage.downloadedFrom(url: url)
        }
        detailNameLabel.text = contact?.name
        detailCompanyLabel.text = contact?.companyName
        var isFavoriteString: String
        isFavoriteString = (contact?.isFavorite)! ? "Favorite — True" : "Favorite — False"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:isFavoriteString), style: .plain, target: self, action: #selector(favoriteButtonPressed))
    }
    
    fileprivate func createContactsArray() {
        contact?.phone?.home != nil ? contactsArray.append((contact?.phone?.home)!): contactsArray.append("empty")
        contact?.phone?.mobile != nil ? contactsArray.append((contact?.phone?.mobile)!): contactsArray.append("empty")
        contact?.phone?.work != nil ? contactsArray.append((contact?.phone?.work)!): contactsArray.append("empty")
        contact?.address != nil ? contactsArray.append("\(String(describing: contact!.address!.street!))  \(String(describing: contact!.address!.city!))  \(String(describing: contact!.address!.state!))  \(String(describing: contact!.address!.country!)) \(String(describing: contact!.address!.zipCode!))"): contactsArray.append("empty")
        contact?.birthdate != nil ? contactsArray.append((contact?.birthdate)!): contactsArray.append("empty")
        contact?.emailAddress != nil ? contactsArray.append((contact?.emailAddress)!): contactsArray.append("empty")
    }
    
    @objc func favoriteButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindSegueToHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindSegueToHome") {
            destinationVC = segue.destination as? ContactsTableViewController
            updateFavoritesArrays()
        }
    }
    
    fileprivate func updateFavoritesArrays() {
        destinationVC?.updatedFavoriteContact = contact
        if (self.contact != nil) {
            if (self.favoriteContactsArray?.contains(where: {$0.name == self.contact?.name}))! {
                if let contactIndex = self.favoriteContactsArray?.index(where: {$0.name == self.contact?.name}) {
                    self.favoriteContactsArray?.remove(at: contactIndex)
                    self.nonFavoriteContactsArray?.append(contact!)
                }
            } else {
                if let contactIndex = self.nonFavoriteContactsArray?.index(where: {$0.name == self.contact?.name}) {
                    self.nonFavoriteContactsArray?.remove(at: contactIndex)
                    self.favoriteContactsArray?.append(contact!)
                }
            }
        }
        destinationVC?.updatedFavoriteContactsArray = favoriteContactsArray
        destinationVC?.updatedNonFavoriteContactsArray = nonFavoriteContactsArray
    }
    
}

