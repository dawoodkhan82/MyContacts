//
//  ContactsDataModel.swift
//  MyContacts
//
//  Created by Dawood Khan on 8/13/17.
//  Copyright © 2017 Dawood Khan. All rights reserved.
//

import UIKit

struct Contacts: Decodable, Loopable {
    let name: String?
    let id: String?
    let companyName: String?
    let isFavorite: Bool?
    let smallImageURL: String?
    let largeImageURL: String?
    let emailAddress: String?
    let birthdate: String?
    let phone: Phone?
    let address: Address?
}

struct Phone: Decodable {
    let work: String?
    let home: String?
    let mobile: String?
}

struct Address: Decodable {
    let street: String?
    let city: String?
    let state: String?
    let country: String?
    let zipCode: String?
}

class ContactsDataModel: NSObject {
    
    func requestData(completion: @escaping ((_ contacts: [Contacts]) -> Void)) {
        let jsonUrlString = "https://s3.amazonaws.com/technical-challenge/v3/contacts.json"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            guard let data = data else { return }
            do {
                let contacts = try JSONDecoder().decode([Contacts].self, from: data)
                completion(contacts)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
        
    } 

}
