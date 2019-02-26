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

class Kit: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(kitName, forKey: PropertyKey.kitName)
        aCoder.encode(items, forKey: PropertyKey.items)
        aCoder.encode(checkIn, forKey: PropertyKey.checkIn)
        aCoder.encode(checkOut, forKey: PropertyKey.checkOut)
        aCoder.encode(lastUsers, forKey: PropertyKey.lastUsers)
        aCoder.encode(available, forKey: PropertyKey.available)
    }
    
    init?(kitName:String, items:Array<(Int,String)>, checkIn: Int, checkOut: Int, lastUsers: Array<Int>, available: Bool){
        
        self.kitName = kitName
        self.items = items
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.lastUsers = lastUsers
        self.available = available
        
    }
    
    required convenience init?(coder aDecoder:NSCoder){
        guard let name = aDecoder.decodeObject(forKey:PropertyKey.kitName) as? String else {
            os_log("unable to decode the name for a Meal oject.", log: OSLog.default, type:.debug)
            return nil
            
        }
        let items = aDecoder.decodeObject(forKey: PropertyKey.items) as? Array<(Int,String)>
        
        let checkIn = aDecoder.decodeInteger(forKey: PropertyKey.checkIn)
        
        let checkOut = aDecoder.decodeInteger(forKey: PropertyKey.checkOut)
        
        let lastUsers = aDecoder.decodeObject(forKey: PropertyKey.lastUsers) as? Array<Int>
        
        let available = aDecoder.decodeBool(forKey: PropertyKey.available)
        
        self.init(kitName: name, items: items!, checkIn: checkIn, checkOut: checkOut, lastUsers: lastUsers!, available: available)
    }   ;
    // Properties
    
    var kitName: String
    var items: Array<(Int,String)>
    var checkIn: Int
    var checkOut: Int
    var lastUsers: Array<Int>
    var available: Bool
    
    // Types
    
    struct PropertyKey {
        static let kitName = "name"
        static let items = "items"
        static let checkIn = "checkIn"
        static let checkOut = "checkOut"
        static let lastUsers = "LastUsers"
        static let available = "avaliable"
    }
    
    //Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Kits")
    
    //Initialization
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
