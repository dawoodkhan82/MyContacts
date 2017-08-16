//
//  ContactsTableViewController.swift
//  MyContacts
//
//  Created by Dawood Khan on 8/11/17.
//  Copyright © 2017 Dawood Khan. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    private let contactsDataModel = ContactsDataModel()
    var contactsCopy: [Contacts]?
    var favoriteContactsArray: [Contacts]?
    var nonFavoriteContactsArray: [Contacts]?
    var updatedFavoriteContact: Contacts?
    var updatedFavoriteContactsArray: [Contacts]?
    var updatedNonFavoriteContactsArray: [Contacts]?
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContactsArrays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func loadContactsArrays() {
        contactsDataModel.requestData { [] (contacts: [Contacts]) in
            self.contactsCopy = contacts
            self.favoriteContactsArray = contacts.filter() {$0.isFavorite!}
            self.nonFavoriteContactsArray = contacts.filter() {!$0.isFavorite!}
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if (updatedFavoriteContactsArray != nil) {
                return updatedFavoriteContactsArray!.count
            } else {
                return 4
            }
        } else {
            if (updatedNonFavoriteContactsArray != nil) {
                return updatedNonFavoriteContactsArray!.count
            } else {
                return 14
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ContactTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        DispatchQueue.main.async {
            var contact: Contacts
            if (indexPath.section == 0) {
                if (self.updatedFavoriteContactsArray != nil) {
                    contact = self.updatedFavoriteContactsArray![indexPath.row]
                    if (self.updatedFavoriteContactsArray?.contains(where: {$0.name == contact.name}))! {
                        cell.favoriteButton.setImage(UIImage(named: "Favorite — True"), for: .normal)
                    }
                } else {
                    contact = self.favoriteContactsArray![indexPath.row]
                }
            } else {
                if (self.updatedNonFavoriteContactsArray != nil) {
                    contact = self.updatedNonFavoriteContactsArray![indexPath.row]
                    if (self.updatedNonFavoriteContactsArray?.contains(where: {$0.name == contact.name}))! {
                        cell.favoriteButton.setImage(UIImage(named: "Favorite — False"), for: .normal)
                    }
                } else {
                    contact = self.nonFavoriteContactsArray![indexPath.row]
                }
            }
            cell.nameLabel.text = contact.name
            cell.companyLabel.text = contact.companyName
            if (self.updatedFavoriteContactsArray == nil) {
                if (contact.isFavorite)! {
                    cell.favoriteButton.setImage(UIImage(named: "Favorite — True"), for: .normal)
                } else {
                    cell.favoriteButton.setImage(UIImage(named: "Favorite — False"), for: .normal)
                }
            }
            if let url = URL.init(string: contact.largeImageURL!) {
                cell.profileImage.downloadedFrom(url: url)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "FAVORITE CONTACTS"
        } else {
           return "OTHER CONTACTS"
        }
    }
    
    var selectedContact: Contacts?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let indexPath = tableView.indexPathForSelectedRow!
            
            if (indexPath.section == 0) {
                if (self.updatedFavoriteContactsArray != nil) {
                    self.selectedContact = self.updatedFavoriteContactsArray?[indexPath.row]
                } else {
                    self.selectedContact = self.favoriteContactsArray?[indexPath.row]
                }
            } else {
                if (self.updatedNonFavoriteContactsArray != nil) {
                    self.selectedContact = self.updatedNonFavoriteContactsArray?[indexPath.row]
                } else {
                    self.selectedContact = self.nonFavoriteContactsArray?[indexPath.row]
                }
            }
            self.performSegue(withIdentifier: "showDetailView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailView") {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.contact = selectedContact
            destinationVC.favoriteContactsArray = favoriteContactsArray
            destinationVC.nonFavoriteContactsArray = nonFavoriteContactsArray
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
