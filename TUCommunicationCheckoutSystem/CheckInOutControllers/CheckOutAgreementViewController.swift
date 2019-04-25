//
//  CheckOutAgreementViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 4/18/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import Firebase

class CheckOutAgreementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let kitsRef = Database.database().reference(withPath:"kits")
    let usersRef = Database.database().reference(withPath:"users")
    var actionKit:Kit? = nil
    var itemsFound = [Bool]()
    var fees = 0
    
    @IBOutlet weak var EquipmentList: UITableView!
    @IBOutlet weak var CheckoutDateLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var CheckInLabel: UILabel!
    @IBOutlet weak var CheckOutLabel: UILabel!
    @IBOutlet weak var DueDateLabel: UILabel!
    
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserIdNumber: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        EquipmentList.delegate = self
        EquipmentList.dataSource = self
        equipmentLabel.text = "Equipment: Kit " + (actionKit?.kitNumber ?? "0")
        setFees_and_date ()
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = actionKit?.items.count ?? 0
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? CheckItemsTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
        }
        let currentItemName = actionKit?.items[indexPath.row][0] ?? "error"
        let currentItemID = actionKit?.items[indexPath.row][1] ?? "error"
        let present = itemsFound[indexPath.row]
        //if present == false{
        //    cell.
        //}
        //print(present,currentItemName,currentItemID)
        cell.setLabels(found: present, Name: currentItemName, Number: currentItemID)
        return cell
    }
    
    func setFees_and_date () {
        if (actionKit?.available)! {
            CheckInLabel.text = "Check in date: --/--/-- "
            let checkOutdate = formatedDate(dateInfo: Date())
            CheckOutLabel.text = "Check out date: " + checkOutdate
            DueDateLabel.text = "Due date: " + calcdueDate(checkOutDate: checkOutdate)
        } else {
            CheckInLabel.text = "Check in date: " + formatedDate(dateInfo: Date())
            let checkOutdate = actionKit?.checkOut
            CheckOutLabel.text = "Check out date: " + checkOutdate!
            let dueDate =  calcdueDate(checkOutDate: checkOutdate!)
            DueDateLabel.text = "Due date: " + dueDate
            
            let dueDateNum = convertStringToDate(workString: dueDate)
            
            //let diff = dueDateNum.interval(ofComponent: .day, fromDate: Date())
            //print(diff)

            
        }
        
    }
    
    func calcdueDate(checkOutDate:String) -> String {
        
        let checkOutDateDate = convertStringToDate(workString: checkOutDate)
        let tenDays = (432000.0 * 2)
        let dueDateFinal = checkOutDateDate.addingTimeInterval(tenDays)
        
        return formatedDate(dateInfo: dueDateFinal)
    }
    
    func convertStringToDate(workString:String)-> Date {
        let splitCheckout = workString.split(separator: "/")
        let CheckOutmonth = Int(splitCheckout[0])
        let CheckOutday = Int(splitCheckout[1])
        let CheckOutyear = Int(splitCheckout[2])
        var Components = DateComponents()
        Components.day = CheckOutday
        Components.month = CheckOutmonth
        Components.year = CheckOutyear
        
        let userCalendar = Calendar.current // user calendar
        let finalDate = userCalendar.date(from: Components)
        return finalDate ?? Date()
    }
    
    func formatedDate(dateInfo:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: dateInfo as Date)
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
