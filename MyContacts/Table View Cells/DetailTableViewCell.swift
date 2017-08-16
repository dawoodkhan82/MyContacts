//
//  DetailTableViewCell.swift
//  MyContacts
//
//  Created by Dawood Khan on 8/14/17.
//  Copyright © 2017 Dawood Khan. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var dataTypeLabel: UILabel!
    @IBOutlet var phoneTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
