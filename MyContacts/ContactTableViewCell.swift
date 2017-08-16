//
//  ContactTableViewCell.swift
//  MyContacts
//
//  Created by Dawood Khan on 8/13/17.
//  Copyright © 2017 Dawood Khan. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
