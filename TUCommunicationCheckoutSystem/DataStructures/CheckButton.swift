//
//  CheckButton.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 4/12/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class CheckButton: UIButton {
    
    let checkedImage = UIImage(named: "Checked")! as UIImage
    let uncheckedImage = UIImage(named: "Unchecked")! as UIImage
    var checkEnabled = true
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    func getValue() -> Bool{
        return isChecked
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self && checkEnabled {
            isChecked = !isChecked
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
