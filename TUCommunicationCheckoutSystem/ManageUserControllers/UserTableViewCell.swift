//
//  UserTableViewCell.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 3/24/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {


    @IBOutlet weak var UserIDnum: UILabel!
    @IBOutlet weak var UserName: UILabel!
    
    func setLabels (ID: String, Name: String){
        UserIDnum.text = ID
        UserName.text = Name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
