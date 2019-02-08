//
//  Inventory-Items.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 1/29/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import Foundation
import os.log

class Kit: NSObject{
    
    // Properties
    
    var kitName: String
    var items: Array<(Int,String)>
    var checkIn: Int
    var checkOut: Int
    var lastUsers: Array<Int>
    
    // Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls( for: .documentDirectory, in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Kits")
    
    // Types
    
    struct PropertyKey {
        static let kitName = "name"
        static let items = "description"
        static let checkIn = "checkIn"
        static let checkOut = "checkOut"
        static let lastUsers = "LastUsers"
    }
    
    //Initialization
    init?(kitName:String, items:Array<(Int,String)>){
        
        self.kitName = kitName
        self.items = items
        self.checkIn = 000000
        self.checkOut = 000000
        self.lastUsers = []
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
