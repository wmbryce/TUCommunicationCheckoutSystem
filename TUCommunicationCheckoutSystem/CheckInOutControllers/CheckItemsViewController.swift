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
    
    @IBAction func Cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    var itemsFound = [Bool]()
    
    let ref = Database.database().reference(withPath: "kits")
    var kits = [Kit]()
    
    var kitToCheck: Kit? {
        didSet{
            refreshItemCheck()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOfItems.delegate = self
        tableOfItems.dataSource = self
        tableOfItems.allowsSelection = false;
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
            self.kitToCheck = self.kits.popLast()
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
        CheckOutAgreementViewController.actionKit = kitToCheck
        CheckOutAgreementViewController.itemsFound = itemsFound
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = kitToCheck?.items.count ?? 0
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? CheckItemsTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
        }
        print("error isn't in the first part of dequeue cell")
        let currentItem = kitToCheck?.items[indexPath.row] ?? "error"
        let present = false
        cell.setLabels(found: present, Name: currentItem)
        
        //os_log("setting the labels works", log: OSLog.default, type: .debug)
        return cell
    }
    
    
    func refreshItemCheck(){
        KitTitle.text = "Kit " + (kitToCheck?.kitNumber ?? "error")
        let Description = (kitToCheck?.checkIn)! + (kitToCheck?.checkOut)!
        
        DescriptionLabel.text = generateDescription()
        tableOfItems.reloadData()
    }
    
    func generateDescription() -> String {
        var descriptionText = ""
        var currentUser = "error"
        if kitToCheck?.available == true {
            let checkOutdate = kitToCheck?.checkOut as! String
            descriptionText = "The kit is available for check out\nIt was last checked out on " + checkOutdate
        }
        else{
            
            let users = kitToCheck?.lastUsers
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
        guard let CheckoutDate = kitToCheck?.checkOut,
                  let CheckinDate  = kitToCheck?.checkIn,
                  let available = kitToCheck?.available
            else {
                fatalError()
        }
        if available {
            
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
        kitToCheck = checkKit
    }
}
