//
//  CheckItemsViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 4/7/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import Firebase

class CheckItemsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var KitTitle: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!

    @IBOutlet weak var tableOfItems: UITableView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func Cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    var itemsFound = [Bool]()
    
    let ref = Database.database().reference(withPath: "kits")
    var kits = [Kit]()
    
    var kitOfAction: Kit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOfItems.delegate = self
        tableOfItems.dataSource = self
        tableOfItems.allowsSelection = false;
        if kitOfAction != nil {
            refreshItemCheck()
            setStatus()
        }
        ref.observe(.value, with: { snapshot in
            var newKits: [Kit] = []
            for child in snapshot.children {
                //print(child)
                if let snapshot2 = child as? DataSnapshot{
                    if let newKit = Kit(snapshot: snapshot2){
                        newKits.append(newKit)
                    }
                }
            }
            
            self.kits = newKits
            //self.kitOfAction = self.kits.popLast()
            print("kits successfully initalized in Check Items Controller")
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        guard let CheckOutAgreementViewController = segue.destination as? CheckOutAgreementViewController
            else {
                print("Check Out Cancelled" )
                return
        }
        let cells = self.tableOfItems.visibleCells as! Array<CheckItemsTableViewCell>
        for cell in cells {
            itemsFound.append(cell.getFoundValue())
        }
        print("Does this run for every transition?")
        CheckOutAgreementViewController.actionKit = kitOfAction
        CheckOutAgreementViewController.itemsFound = itemsFound
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = kitOfAction?.items.count ?? 0
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? CheckItemsTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
        }
        print("error isn't in the first part of dequeue cell")
        let currentItemName = kitOfAction?.items[indexPath.row][0] ?? "error"
        let currentItemID = kitOfAction?.items[indexPath.row][1] ?? "error"
        let present = false
        cell.setLabels(found: present, Name: currentItemName, Number: currentItemID)
        //if present == false{
        //    cell.
        //}
        
        //os_log("setting the labels works", log: OSLog.default, type: .debug)
        return cell
    }
    
    
    func refreshItemCheck(){
        KitTitle.text = "Kit " + (kitOfAction?.kitNumber ?? "error")
        let Description = (kitOfAction?.checkIn)! + (kitOfAction?.checkOut)!
        
        DescriptionLabel.text = generateDescription()
        tableOfItems.reloadData()
    }
    
    func generateDescription() -> String {
        var descriptionText = ""
        var currentUser = "error"
        if kitOfAction?.available == true {
            let checkOutdate = kitOfAction?.checkOut as! String
            descriptionText = "The kit is available for check out\nIt was last checked out on " + checkOutdate
        }
        else{
            
            let users = kitOfAction?.lastUsers
            if users?.count ?? 0 > 0{
                currentUser = users?[0] ?? "error"
            } else {
                currentUser = "error"
            }
            descriptionText = "This kit is currently checked out by " + currentUser
        }
        print(descriptionText)
        return descriptionText
    }
    
    func setStatus(){
        guard let CheckoutDate = kitOfAction?.checkOut,
                  let CheckinDate  = kitOfAction?.checkIn,
                  let available = kitOfAction?.available
            else {
                fatalError()
        }
        if available {
            statusLabel.backgroundColor = UIColor(red: 0/255, green: 200/255, blue: 50/255, alpha: 1.0)
            statusLabel.text = "Available for Checkout"
        } else{
            statusLabel.backgroundColor = UIColor(red: 200/255, green: 0/255, blue: 50/255, alpha: 1.0)
            statusLabel.text = "Unavaiable of Checkout"
        }
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

extension CheckItemsViewController: checkKitSelectionDelegate{
    func checkKitItems(_ checkKit: Kit) {
        kitOfAction = checkKit
    }
}
