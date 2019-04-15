//
//  CheckItemsTableViewCell.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 4/7/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit



class CheckItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var foundButton: CheckButton!
    @IBOutlet weak var NameOrID: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setLabels (found: Bool, Name: String){
        foundButton.isChecked = found
        NameOrID.text = Name
    }
    

}


