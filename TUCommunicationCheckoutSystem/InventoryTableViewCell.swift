//
//  InventoryTableViewCell.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/25/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var kitNameLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
