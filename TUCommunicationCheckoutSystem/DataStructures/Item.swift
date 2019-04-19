//
//  File.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 4/19/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import Foundation

class item: NSObject{
    
    var name:String
    var Id:String
    
    init(name:String, Id:String) {
        self.name = name
        self.Id = Id
    }
}
