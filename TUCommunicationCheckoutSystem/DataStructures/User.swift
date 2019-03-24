//
//  User.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/7/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Foundation
import os.log

struct User {
    
    let ref:DatabaseReference?
    let key:String
    var ID_number:Int
    var name:String
    var email:String
    var classId:String
    var isAdmin:Bool
    var authorized:Bool

    //Definition of variable keys
    init(Id_num:Int, name:String, entry_email:String, classId:String, isAdmin:Bool, authorized:Bool){
        
        self.ref = nil
        self.key = ""
        self.ID_number = Id_num
        self.name = name
        self.email = entry_email
        self.classId = classId
        self.isAdmin = isAdmin
        self.authorized = authorized
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String: AnyObject],
        let ID_num = value["ID_number"] as? Int,
        let name = value["name"] as? String,
        let entry_email = value["email"] as? String,
        let classId = value["classID"] as? String,
        let isAdmin = value["isAdmin"] as? Bool,
        let authorized = value["authorized"] as? Bool
        else {
            print("returning nil")
            return nil
        }
        self.ID_number = ID_num
        self.name = name
        self.email = entry_email
        self.classId = classId
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.isAdmin = isAdmin
        self.authorized = authorized
        
    }
    
    func toAnyObject() -> Any {
        return [
            "ID_number": ID_number,
            "name": name,
            "email": email,
            "classID":classId,
            "isAdmin":isAdmin,
            "authorized":authorized
        ]
    }
}
