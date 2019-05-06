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
    var users:[User] = []
    var actionKit:Kit? = nil
    var checkOutDate = ""
    var checkInDate = ""
    var itemsFound = [Bool]()
    var fees = 0
    let fines = [-1,-1,20,10,2,20]
    
    @IBOutlet weak var ItemsMissingLabel: UILabel!
    @IBOutlet weak var EquipmentList: UITableView!
    @IBOutlet weak var CheckoutDateLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var CheckInLabel: UILabel!
    @IBOutlet weak var CheckOutLabel: UILabel!
    @IBOutlet weak var DueDateLabel: UILabel!
    @IBOutlet weak var OverdueLabel: UILabel!
    
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserIdNumber: UITextField!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EquipmentList.delegate = self
        EquipmentList.dataSource = self
        EquipmentList.allowsSelection = false;
        equipmentLabel.text = "Equipment: Kit " + (actionKit?.kitNumber ?? "0")
        setFees_and_date()
        checkForMissingItems()
        // Do any additional setup after loading the view.
        usersRef.observe(.value, with: { snapshot in
            var newUsers: [User] = []
            for child in snapshot.children {
                //print(child)
                if let snapshot2 = child as? DataSnapshot{
                    //print("here")
                    if let newUser = User(snapshot: snapshot2){
                        //print("appends User")
                        newUsers.append(newUser)
                    }
                }
            }
            
            self.users = newUsers
            //print(self.users.count)
            
        })
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
        cell.setLabels(found: present, canCheck: false, Name: currentItemName, Number: currentItemID)
        return cell
    }
        
    @IBAction func CheckIDandEmail(_ sender: Any) {
        print("hello")
        let checkEmail = UserEmail.text
        let checkID = UserIdNumber.text
        
        for checkUser in users{
            if checkUser.ID_number == checkID{
                if checkUser.email == checkEmail{
                    if (actionKit?.available)!{
                        kitsRef.child((actionKit?.kitNumber)!).updateChildValues(["checkOut": checkOutDate,"checkIn":checkInDate,"avaliable":false,"LastUsers":([checkID!] + (actionKit?.lastUsers)!)]) {
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Authorized data could not be saved: \(error).")
                        } else {
                            print("Check out data saved successfully!")
                            
                        }
                    
                        }}                    else {
                        
                        kitsRef.child((actionKit?.kitNumber)!).updateChildValues(["checkIn":checkInDate,"avaliable":true]) {
                            (error:Error?, ref:DatabaseReference) in
                            if let error = error {
                                print("Authorized data could not be saved: \(error).")
                            } else {
                                print("Check in data saved successfully!")
                            }
                        }
                    }
                    
                    performSegue(withIdentifier: "UnwindToCheckOutView", sender: self)
                }
            }
        }
        ThrowError(reason: "That ID number and email do not exist in our database")
    }
    
    func setFees_and_date() {
        if (actionKit?.available)! {
            checkInDate = "--/--/--"
            CheckInLabel.text = "Check in date: " + checkInDate
            checkOutDate = formatedDate(dateInfo: Date())
            CheckOutLabel.text = "Check out date: " + checkOutDate
            DueDateLabel.text = "Due date: " + calcdueDate(checkOut: checkOutDate)
        } else {
            let checkInDateReal = Date()
            checkInDate = formatedDate(dateInfo: checkInDateReal)
            CheckInLabel.text = "Check in date: " + checkInDate
            checkOutDate = (actionKit?.checkOut)!
            CheckOutLabel.text = "Check out date: " + checkOutDate
            let dueDate =  calcdueDate(checkOut: checkOutDate)
            DueDateLabel.text = "Due date: " + dueDate
            
            let diff = daysBetween(dueDate: dueDate,checkInDate: checkInDate)
            if diff > 0{
                let newFee = (10*diff)
                let UserText = ("This kit is " + String(diff) + " days overdue. You will be charged $" + String(newFee) + ".00")
                print(UserText)
                OverdueLabel.text = UserText
                fees += newFee
            } else {
                OverdueLabel.text = ("It is still before kit due date")
            }
        }
    }
    
    func daysBetween(dueDate:String,checkInDate:String) -> Int{
        let splitDueDate = dueDate.split(separator: "/")
        let dueMonth = Int(splitDueDate[0])!
        let dueDay = Int(splitDueDate[1])!
        //let dueYear = Int(splitDueDate[2])!
        
        let splitCheckIn = checkInDate.split(separator: "/")
        let checkInMonth = Int(splitCheckIn[0])!
        let checkInDay = Int(splitCheckIn[1])!
        //let checkInYear = Int(splitCheckIn[2])!
        
        let longMonths = [1,3,5,7,8,10,12]
        let shortMonths = [4,6,9,11]
        
        var daysApart = 0
        //Compare Months
        //equal Months
        if dueMonth == checkInMonth{
            daysApart += dueDay - checkInDay
        }//Overdue greater months
        else if dueMonth < checkInMonth {
            if longMonths.contains(dueMonth){
                daysApart += 31 - dueDay
            } else if shortMonths.contains(dueMonth){
                daysApart += 30 - dueDay + checkInDay
            } else {
                daysApart += 28 - dueDay + checkInDay
            }
        } //Not overdue
        else if checkInMonth < dueMonth {
            if longMonths.contains(checkInMonth){
                daysApart += -31 + checkInDay - dueDay
            } else if shortMonths.contains(checkInMonth){
                daysApart += -30 + checkInDay - dueDay
            } else {
                daysApart += -28 + checkInDay - dueDay
            }
        }
        return daysApart
    }
    
    
    func checkForMissingItems(){
        var count = 0
        let workingItems = actionKit?.items
        var stringOfMissingItems:String = ""
        for itemStatus in itemsFound {
            if !(itemStatus){
                //create string of missing items to output to label
                if stringOfMissingItems.isEmpty{
                    stringOfMissingItems = workingItems![count][0]
                } else{
                    stringOfMissingItems += ", " + workingItems![count][0]
                }
                //calculate Fine for missing items
                let feeForItem = fines[count]
                if feeForItem == -1{
                    //Put Critical warning here
                    ThrowWarning(reason: "Critical items are missing from kit!")
                } else {
                    fees += feeForItem
                }
            }
            count += 1
        }
        if stringOfMissingItems.isEmpty{
            ItemsMissingLabel.text = "All items are accounted for!"
        } else {
            ItemsMissingLabel.text = "The following items were not found: " + stringOfMissingItems
        }
        AmountLabel.text = amountDueGenerator()
    }
    
    func calcdueDate(checkOut:String) -> String {
        
        let checkOutDateDate = convertStringToDate(workString: checkOut)
        print(formatedDate(dateInfo: checkOutDateDate))
        let tenDays = (432000.0 * 2)
        let dueDateFinal = checkOutDateDate.addingTimeInterval(tenDays)
        let formattedDueDate = formatedDate(dateInfo: dueDateFinal)
        print(formattedDueDate)
        return formattedDueDate
    }
    
    func convertStringToDate(workString:String)-> Date {
        let splitCheckout = workString.split(separator: "/")
        let CheckOutmonth = Int(splitCheckout[0])
        let CheckOutday = Int(splitCheckout[1])
        let CheckOutyear = Int(splitCheckout[2])
        print("Checkout year:", CheckOutyear)
        print("Split Chechout: ", splitCheckout)
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
    
    func amountDueGenerator() -> String {
        return "Amount Due: $" + String(fees) + ".00"
    }
    
    func ThrowError(reason:String) {
        let alert = UIAlertController(title: "Invaild Information",
                                      message: reason,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func ThrowWarning(reason:String) {
        let alert = UIAlertController(title: "Warning",
                                      message: reason,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
