//  InventoryTableViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/28/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//


import UIKit
import os.log
import Firebase

protocol KitSelectionDelegate:class {
    func kitSelected(_ newKit: Kit)
}

class InventoryTableViewController: UITableViewController {
    
    
    //Properties
    let ref = Database.database().reference(withPath: "kits")
    weak var selectionDelegate: KitSelectionDelegate?
    var kits = [Kit]()
    @IBOutlet var InventoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TableView.allowsMultipleSelectionDuringEditing = false
        
        ref.observe(.value, with: { snapshot in
            var newKits: [Kit] = []
            for child in snapshot.children {
            print(child)
                if let snapshot2 = child as? DataSnapshot{
                    if let newKit = Kit(snapshot: snapshot2){
                        newKits.append(newKit)
                }
            }
            }
            
            self.kits = newKits
            os_log("Observer works", log: OSLog.default, type: .debug);
            print(self.kits.count)
            if (self.kits.count > 0) {
                self.selectionDelegate?.kitSelected(self.kits[0])
                self.tableView.reloadData()
                
            }
        })

        InventoryTableView.delegate = self
        InventoryTableView.dataSource = self
        //selectionDelegate?.kitSelected(self.kits[0])
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteKit = kits[indexPath.row]
            deleteKit.ref?.removeValue()
        }
    }
    
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func AddKit(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Kit",
                                      message: "Please enter the kit identification number",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // 1
            guard let textField = alert.textFields?.first,
                let newkitNumber = textField.text else { return }
            if self.checkForValidKitNumber(testKit:newkitNumber){
                //Create new kit
                let Item1 = newkitNumber + "0001"
                let Item2 = newkitNumber + "0002"
                let Item3 = newkitNumber + "0003"
                let Item4 = newkitNumber + "0004"
                let Item5 = newkitNumber + "0005"
                let Item6 = newkitNumber + "0006"
                let Items = [Item1,Item2,Item3,Item4,Item5,Item6]
                let Checkin_out_Date = self.formatedDate(dateInfo:Date() as NSDate)
                
                let newKit = Kit(kitNumber: newkitNumber, items: Items as! Array<String>, checkIn: Checkin_out_Date as String, checkOut: Checkin_out_Date as String, lastUsers: ["None"], available: true)
                //Add new kit to database
                let kitRef = self.ref.child(newkitNumber.lowercased())
                kitRef.setValue(newKit.toAnyObject())
            }
    }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as? InventoryTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
            
        }
        os_log(" successfully dequeued cell now trying to set them.", log: OSLog.default, type: .debug)
        let currentKit = kits[indexPath.row]
        let ava = availableString(available: currentKit.available)
        cell.setLabels(name: currentKit.kitNumber, available: ava)
        //os_log("setting the labels works", log: OSLog.default, type: .debug)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKit = kits[indexPath.row]
        os_log("New Kit selected", log: OSLog.default, type: .debug);
        
        selectionDelegate?.kitSelected(selectedKit)
    }
    
    
    // Extra functions for string manipulation and validation checking
    
    func availableString(available:Bool) -> String {
        if available {
            return "available"
        }
        else {
            return "unavailable"
        }
    }
    func formatedDate(dateInfo:NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: dateInfo as Date)
    }
    
    // Make sure new Kits are valid
    func checkForValidKitNumber(testKit:String) -> Bool{
        if Int(testKit) == nil || (999 < Int(testKit) ?? 0 ) || ( 100 > (Int(testKit) ?? 0)){
            ThrowError(reason: "Kit number must be and integer between 100 and 999")
            return false
        }
        for i in kits{
            if testKit == i.kitNumber{
                ThrowError(reason: "That number is already in use")
                return false
            }
        
        }
        return true
    }
    func ThrowError(reason:String) {
        let alert = UIAlertController(title: "Invaild Kit",
                                      message: reason,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    /*private func saveKits() {
     let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(kits, toFile:Kit.ArchiveURL.path)
     if isSuccessfulSave {
     os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
     } else {
     os_log("Failed to save meals... ", log: OSLog.default, type: .error)
     }
     }*/
    
    /*private func loadKits() -> [Kit]? {
     return NSKeyedUnarchiver.unarchiveObject(withFile: Kit.ArchiveURL.path) as? [Kit]
     }*/
    
    /*private func loadSampleKits() {
     let today = Date()
     guard let kit1 = Kit(kitNumber: "101", items:[101000001,101000002,101000003,101000004,101000005,101000006], checkIn: today as NSDate, checkOut: today as NSDate, lastUsers: [], available: true)else {
     fatalError("kit1 didn't load")
     }
     guard let kit2 = Kit(kitName: "Kit 102", items:[102000001,102000002,102000003,102000004,102000005,102000006], checkIn: today as NSDate, checkOut:today as NSDate, lastUsers: [], available: true)else {
     fatalError("kit2 didn't load")
     }
     guard let kit3 = Kit(kitName: "Kit 103", items:[103000001,103000002,103000003,103000004,103000005,103000006], checkIn: today as NSDate, checkOut: today as NSDate, lastUsers: [], available: true)else {
     fatalError("kit3 didn't load")
     }
     kits += [kit1,kit2,kit3]
     }*/
    
    /*   Replacing all of functionality with addKit function
     @IBAction func unwindToInventoryTableViewController(_ sender: UIStoryboardSegue){
     if let sourceViewController = sender.source as? AddItemViewController, let
     newKit = sourceViewController.newKit {
     if checkForValidKitNumber(testKit: ""){
     os_log("Recieved Proper ViewController.", log: OSLog.default, type: .debug)
     let newIndexPath = IndexPath(row: kits.count, section:0)
     kits.append(newKit)
     tableView.insertRows(at: [newIndexPath],with: .automatic)
     //saveKits()
     }
     else {
     os_log("Kit is invalid", log: OSLog.default, type: .debug)
     }
     }
     }*/
    
    
    
}
