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
    
    @IBOutlet weak var NumberInput: UITextField!
    @IBOutlet weak var Item1Input: UITextField!
    @IBOutlet weak var Item2Input: UITextField!
    @IBOutlet weak var Item3Input: UITextField!
    @IBOutlet weak var Item4Input: UITextField!
    @IBOutlet weak var Item5Input: UITextField!
    @IBOutlet weak var Item6Input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NumberInput.delegate = self as? UITextFieldDelegate
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
        let kitNumber = NumberInput.text ?? ""
        let Item1 = Int(Item1Input.text ?? "")
        let Item2 = Int(Item2Input.text ?? "")
        let Item3 = Int(Item3Input.text ?? "")
        let Item4 = Int(Item4Input.text ?? "")
        let Item5 = Int(Item5Input.text ?? "")
        let Item6 = Int(Item6Input.text ?? "")
        let Items = [Item1,Item2,Item3,Item4,Item5,Item6]
        let Checkin_out_Date = formattedDate()
        
        newKit = Kit(kitNumber: kitNumber, items: Items as! Array<Int>, checkIn: Checkin_out_Date, checkOut: Checkin_out_Date, lastUsers: [], available: true)
        
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
        AddItem.isEnabled = !(NumberInput.text?.isEmpty ?? true)
        //AddItem.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == NumberInput && !(NumberInput.text?.isEmpty ?? true) {
            let baseNum = NumberInput.text
            Item1Input.text = baseNum! + "0001"
            Item2Input.text = baseNum! + "0002"
            Item3Input.text = baseNum! + "0003"
            Item4Input.text = baseNum! + "0004"
            Item5Input.text = baseNum! + "0005"
            Item6Input.text = baseNum! + "0006"
            
        }
        updateSaveButtonState()
        navigationItem.title = textField.text
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
