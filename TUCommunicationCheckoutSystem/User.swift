//
//  User.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/7/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import Foundation

import UIKit
import Foundation
import os.log

class User: NSObject{

    var ID_number:Int
    var name:String
    var email:String
    var classId:String

    //Definition of variable keys
    struct PropertyKey {
        static let ID_number = "ID"
        static let name = "name"
        static let email = "email"
        static let classId = "classId"

    }
    //Initialization function
    init?(Id_num:Int, name:String, entry_email:String, classId:String ){
        
        self.ID_number = Id_num
        self.name = name
        self.email = entry_email
        self.classId = classId
        
    }
}
