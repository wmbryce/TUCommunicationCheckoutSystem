//
//  Inventory-Items.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 1/29/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import Foundation
import Firebase


struct Kit {
    
    let ref:DatabaseReference?
    let key: String
    var kitNumber: String
    var items: Array<String>
    var checkIn: String
    var checkOut: String
    var lastUsers: Array<String>
    var available: Bool
    
    init(kitNumber:String, items:Array<String>, checkIn: String, checkOut: String, lastUsers: Array<String>, available: Bool){
        self.ref = nil
        self.key = ""
        self.kitNumber = kitNumber
        self.items = items
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.lastUsers = lastUsers
        self.available = available
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let number = value["number"] as? String,
            let items = value["items"] as? Array<String>,
            let checkIn = value["checkIn"] as? String,
            let checkOut = value["checkOut"] as? String,
            let lastUsers = value["LastUsers"] as? Array<String>,
            let available = value["avaliable"] as? Bool
            else {
                print("returning nil")
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.kitNumber = number
        self.items = items
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.lastUsers = lastUsers
        self.lastUsers = []
        self.available = available
    }
    // Properties
    
    func toAnyObject() -> Any {
        return [
            "number": kitNumber,
            "items": items,
            "checkIn": checkIn,
            "checkOut":checkOut,
            "LastUsers":lastUsers,
            "avaliable":available
        ]
    }
}
