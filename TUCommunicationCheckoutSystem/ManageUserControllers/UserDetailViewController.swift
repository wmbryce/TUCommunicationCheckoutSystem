//
//  UserDetailViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 3/24/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var TrinityIDLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var CourseLabel: UILabel!
    @IBOutlet weak var AuthorizedLabel: UILabel!
    @IBOutlet weak var AdminLabel: UILabel!
    
    @IBOutlet weak var IDvalue: UILabel!
    @IBOutlet weak var EmailValue: UILabel!
    @IBOutlet weak var CourseValue: UILabel!
    @IBOutlet weak var AuthorizedSwitch: UISwitch!
    @IBOutlet weak var AdminSwitch: UISwitch!
   
    var userOfInterest: User? {
        didSet{
            refershUI()
        }
    }

    func refershUI(){
        loadViewIfNeeded()
        let name = userOfInterest?.name
        UserNameLabel.text = name!
        let ID = userOfInterest?.ID_number
        IDvalue.text = String(ID!)
        let email = userOfInterest?.email
        EmailValue.text = email!
        let course = userOfInterest?.classId
        CourseValue.text = course!
        let isAdmin = userOfInterest?.isAdmin
        AdminSwitch.setOn(isAdmin!,animated: false)
        let isAuthorized = userOfInterest?.authorized
        AuthorizedSwitch.setOn(isAuthorized!,animated:false)
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
