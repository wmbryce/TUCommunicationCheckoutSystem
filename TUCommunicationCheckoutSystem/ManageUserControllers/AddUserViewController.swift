//
//  AddUserViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by ZhenyuanLiu on 3/31/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import os.log

class AddUserViewController: UIViewController {

    var newUser:User?
    
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var IDNumberInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var CourseInput: UITextField!
    //@IBOutlet weak var PasswordInput: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        NameInput.delegate = self as? UITextFieldDelegate
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var AddUser: UIBarButtonItem!
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === AddUser
            else {
                os_log("the save button was not pressed cancelling", log: OSLog.default, type: .debug)
                return
        }
        let Name = NameInput.text ?? ""
        let IDNumber = IDNumberInput.text ?? ""
        let Email = EmailInput.text ?? ""
        let Course = CourseInput.text ?? ""
        //let Password = PasswordInput.text ?? ""
        
        newUser = User(Id_num:IDNumber, name:Name, entry_email:Email, classId:Course, isAdmin:false, authorized:false, password:"")
        
    }
    
    private func updateSaveButtonState() {
        //let text = NameInput.text ?? ""
        //AddUser.isEnabled = !(NameInput.text?.isEmpty ?? true)
        //AddItem.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
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
