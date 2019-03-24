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
    
    /*init?(snapshot: DataSnapshot) {
        guard
            let ID_number: 
            let
            let
            let
            let
            let
            let
            else {
                print("returning nil")
                return nil
        }
    //Initialization function
    init?(Id_num:Int, name:String, entry_email:String, classId:String,  ){
        
        self.ID_number = Id_num
        self.name = name
        self.email = entry_email
        self.classId = classId
        
    }*/
}
