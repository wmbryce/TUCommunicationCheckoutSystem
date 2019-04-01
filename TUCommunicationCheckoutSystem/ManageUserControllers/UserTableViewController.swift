//
//  UserTableViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 3/24/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import os.log
import Firebase

protocol UserSelectionDelegate:class {
    func UserSelected(_ newUser: User)
}

class UserTableViewController: UITableViewController {

    
    //Properties
    let ref = Database.database().reference(withPath: "users")
    weak var selectionDelegate: UserSelectionDelegate?
    var users = [User]()
    @IBOutlet var UserTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TableView.allowsMultipleSelectionDuringEditing = false
        
        ref.observe(.value, with: { snapshot in
            var newUsers: [User] = []
            for child in snapshot.children {
            print(child)
                if let snapshot2 = child as? DataSnapshot{
                    print("here")
                    if let newUser = User(snapshot: snapshot2){
                        print("appends User")
                        newUsers.append(newUser)
                    }
            }
            }
            
            self.users = newUsers
            os_log("Observer works", log: OSLog.default, type: .debug);
            print(self.users.count)
            self.selectionDelegate?.UserSelected(self.users[0])
            self.tableView.reloadData()
        })
        
        UserTableView.delegate = self
        UserTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

   // override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
   //     return 0
   // }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteUser = users[indexPath.row]
            deleteUser.ref?.removeValue()
        }
    }
    
    @IBAction func BackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddUser(_ sender: Any) {
        let alert = UIAlertController(title: "Add New User",
                                      message: "Please enter the user indentification number",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // 1
            guard let textField = alert.textFields?.first,
                let newIDNumber = textField.text else { return }
            if self.checkForValidUserNumber(testUser:newIDNumber){
                //Create new user
                let newName = textField.text
                let newEmail = textField.text
                let newClassID = textField.text
                
                let newUser = User(Id_num: newIDNumber, name: newName!, entry_email: newEmail!, classId: newClassID!, isAdmin: false, authorized: false, password: "")
                //Add new user to database
                let userRef = self.ref.child(newIDNumber.lowercased())
                userRef.setValue(newUser.toAnyObject())
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
    
    //override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
    //    return 1
    //}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as? UserTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
            
        }
        os_log(" successfully dequeued cell now trying to set them.", log: OSLog.default, type: .debug)
        let currentUser = users[indexPath.row]
        cell.setLabels(ID: currentUser.ID_number, Name: currentUser.name)
        //os_log("setting the labels works", log: OSLog.default, type: .debug)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        os_log("New User selected", log: OSLog.default, type: .debug);
        
        selectionDelegate?.UserSelected(selectedUser)
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
    
    // Make sure new users are valid
    func checkForValidUserNumber(testUser:String) -> Bool{
        if Int(testUser) == nil || (999 < Int(testUser) ?? 0 ) || ( 100 > (Int(testUser) ?? 0)){
            ThrowError(reason: "User number must be and integer between 100 and 999")
            return false
        }
        for i in users{
            if testUser == i.ID_number{
                ThrowError(reason: "That number is already in use")
                return false
            }
            
        }
        return true
    }
    func ThrowError(reason:String) {
        let alert = UIAlertController(title: "Invaild User",
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

}
