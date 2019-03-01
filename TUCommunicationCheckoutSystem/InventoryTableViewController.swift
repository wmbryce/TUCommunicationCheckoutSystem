//
//  InventoryTableViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/25/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import os.log

class InventoryTableViewController: UITableViewController {
    
    @IBOutlet var InventoryTableView: UITableView!
    
    var kits = [Kit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedKits = loadKits(){
            kits += savedKits
        } else {
            loadSampleKits()
        }
        
        //InventoryTableView.delegate = self
        //InventoryTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToInventoryTableViewController(_ sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? AddItemViewController, let
            newKit = sourceViewController.newKit {
            if checkForValidKit(testKit: newKit){
                os_log("Recieved Proper ViewController.", log: OSLog.default, type: .debug)
                let newIndexPath = IndexPath(row: kits.count, section:0)
                kits.append(newKit)
                tableView.insertRows(at: [newIndexPath],with: .automatic)
                saveKits()
            }
            else {
                os_log("Kit is invalid", log: OSLog.default, type: .debug)
            }
        }
    }
    
    func checkForValidKit(testKit:Kit) -> Bool{
        
        for i in kits{
            if testKit.kitName == i.kitName{
                return false
            }
            //if testKit.items == i.items{
            //    return false
            //}
            
        }
        return true
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
    
    private func saveKits() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(kits, toFile:Kit.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals... ", log: OSLog.default, type: .error)
        }
    }
    
    private func loadKits() -> [Kit]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Kit.ArchiveURL.path) as? [Kit]
    }
    
     private func loadSampleKits() {
        let today = Date()
        guard let kit1 = Kit(kitName: "Kit 101", items:[101000001,101000002,101000003,101000004,101000005,101000006], checkIn: today as NSDate, checkOut: today as NSDate, lastUsers: [], available: true)else {
     fatalError("kit1 didn't load")
     }
        guard let kit2 = Kit(kitName: "Kit 102", items:[102000001,102000002,102000003,102000004,102000005,102000006], checkIn: today as NSDate, checkOut:today as NSDate, lastUsers: [], available: true)else {
            fatalError("kit2 didn't load")
        }
        guard let kit3 = Kit(kitName: "Kit 103", items:[103000001,103000002,103000003,103000004,103000005,103000006], checkIn: today as NSDate, checkOut: today as NSDate, lastUsers: [], available: true)else {
            fatalError("kit3 didn't load")
        }
        kits += [kit1,kit2,kit3]
     }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as? InventoryTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
            
        }
        os_log(" successfully dequeued cell now trying to set them.", log: OSLog.default, type: .debug)
        let currentKit = kits[indexPath.row]
        let ava = availableString(available: currentKit.available)
        cell.setLabels(name: currentKit.kitName, available: ava)
        os_log("setting the labels works", log: OSLog.default, type: .debug)
        
        return cell
    }
    
    func availableString(available:Bool) -> String {
        if available {
            return "available"
        }
        else {
            return "unavailable"
        }
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

}
