//
//  AddItemViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/26/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import os.log

class AddItemViewController: UIViewController {

    var newKit:Kit?
    
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var Item1Input: UITextField!
    @IBOutlet weak var Item2Input: UITextField!
    @IBOutlet weak var Item3Input: UITextField!
    @IBOutlet weak var Item4Input: UITextField!
    @IBOutlet weak var Item5Input: UITextField!
    @IBOutlet weak var Item6Input: UITextField!
    
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var AddItem: UIBarButtonItem!
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === AddItem
            else {
                os_log("the save button was not pressed cancelling", log: OSLog.default, type: .debug)
                return
        }
        let kitName = NameInput.text ?? ""
        let Item1 = Int(Item1Input.text ?? "")
        let Item2 = Int(Item2Input.text ?? "")
        let Item3 = Int(Item3Input.text ?? "")
        let Item4 = Int(Item4Input.text ?? "")
        let Item5 = Int(Item5Input.text ?? "")
        let Item6 = Int(Item6Input.text ?? "")
        let Items = [Item1,Item2,Item3,Item4,Item5,Item6]
        let Checkin_out_Date = Date()
        
        newKit = Kit(kitName: kitName, items: Items as! Array<Int>, checkIn: Checkin_out_Date as NSDate, checkOut: Checkin_out_Date as NSDate, lastUsers: [], available: true)
        
    }
    func formattedDate() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: currentDate)
        
    }
    
    private func updateSaveButtonState() {
        //let text = NameInput.text ?? ""
        AddItem.isEnabled = !(NameInput.text?.isEmpty ?? true)
        //AddItem.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameInput.delegate = self as? UITextFieldDelegate
        //NameInput.delegate = self
        /*Item1Input.delegate = (self as! UITextFieldDelegate)
        Item2Input.delegate = (self as! UITextFieldDelegate)
        Item3Input.delegate = (self as! UITextFieldDelegate)
        Item4Input.delegate = (self as! UITextFieldDelegate)
        Item5Input.delegate = (self as! UITextFieldDelegate)
        Item6Input.delegate = (self as! UITextFieldDelegate)*/
        updateSaveButtonState()
 
        // Do any additional setup after loading the view.
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
