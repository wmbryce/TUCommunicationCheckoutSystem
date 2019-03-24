//
//  CheckinoutViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Suarez IPhone on 3/24/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class CheckinoutViewController: UIViewController {

    var inven: Array<String> = []
    var i: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Ugi.singleton().openConnection()
        
       let inventory = Ugi.singleton().startInventory(self as! UgiInventoryDelegate, with:UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))

        Ugi.singleton().activeInventory?.stop {
            // Code to run when inventory is stopped
        }
        
        Ugi.singleton().closeConnection()
        Ugi.singleton().activeInventory?.tags.forEach { (tag) in
            inven[i] = getkitnum(help: tag)
        }

        // Do any additional setup after loading the view.
    }
    
    func getkitnum(help:UgiTag) -> String{
       // var helped = String(help)
        var helped = String(help)
        helped = helped.replacingOccurrences(of: "0", with: "", options: NSString.CompareOptions.literal, range: nil)
        return helped
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
