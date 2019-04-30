//
//  CheckItemsViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 4/7/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import Firebase

class CheckItemsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UgiInventoryDelegate {
    
    @IBOutlet weak var KitTitle: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!

    @IBOutlet weak var tableOfItems: UITableView!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func Cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
    var itemsFound = [Bool]()
    var tagToString: [String] = []
    let ref = Database.database().reference(withPath: "kits")
    var kits = [Kit]()
    var inventoryType: UgiInventoryTypes = UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE
    var specialFunction: Int = SPECIAL_FUNCTION_NONE
    var reset = 0
    var inventory: UgiInventory?
    var complete = 0
    var scanning = false
    
    var kitOfAction: Kit?{
        didSet{
            itemsFound = []
            for i in kitOfAction?.items ?? [] {
                itemsFound.append(false)
            }
            print(itemsFound)
        }
    }
    @IBAction func NextButton(_ sender: Any) {
        
    }
    
    
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
    
    @IBAction func StartScan(_ sender: UIButton) {
        let color = scanning ? UIColor .white : .black
        let title = scanning ? "Stop Searching" : "Search for Items"
        let backgroundColor = scanning ? UIColor .black : .white
        
        print(title)
        sender.layer.borderWidth = 2.0
        sender.setTitle(title, for:.normal)
        sender.backgroundColor = backgroundColor
        sender.setTitleColor(color, for: .normal)
        
        sender.setTitle("Search for Items", for:.normal)
        
        self.tagToString.removeAll()
        var config: UgiRfidConfiguration
        if self.specialFunction == SPECIAL_FUNCTION_READ_RF_MICRON_MAGNUS_SENSOR_CODE {
            config = UgiRfMicron.config(
                toReadMagnusSensorValue: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE,
                withTagModel: SPECIAL_FUNCTION_RF_MICRON_MAGNUS_TYPE,
                withRssiLimitType: SPECIAL_FUNCTION_RF_MICRON_MAGNUS_LIMIT_TYPE,
                withLimitRssiThreshold: SPECIAL_FUNCTION_RF_MICRON_MAGNUS_LIMIT_THRESHOLD)
        }
        else if self.specialFunction == SPECIAL_FUNCTION_READ_RF_MICRON_MAGNUS_TEMPERATURE {
            config = UgiRfMicron.config(toReadMagnusTemperature: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE)
        }
        else {
            config = UgiRfidConfiguration.config(withInventoryType: self.inventoryType)
            if self.specialFunction == SPECIAL_FUNCTION_READ_USER_MEMORY {
                config.minUserBytes = 4
                config.maxUserBytes = 128
            }
            else if self.specialFunction == SPECIAL_FUNCTION_READ_TID_MEMORY {
                config.minTidBytes = 4
                config.maxTidBytes = 128
            }
        }
        if !scanning{
            if(reset == 0){
                Ugi.singleton().startInventory(self, with: config)
                reset = 1
            } else{
                Ugi.singleton().activeInventory?.resumeInventory()
            }
        } else {
            inventory?.pause()
        }
        scanning = !scanning
        //inventory?.resumeInventory()
    }
    
    @IBAction func EndScan(_ sender: Any) {
        inventory?.pause()
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
        var count = 0
        for cell in cells {
            itemsFound[count] = cell.getFoundValue()
            count += 1
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
      //  print("error isn't in the first part of dequeue cell")
        let currentItemName = kitOfAction?.items[indexPath.row][0] ?? "error"
        let currentItemID = kitOfAction?.items[indexPath.row][1] ?? "error"
        let present = itemsFound[indexPath.row]
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
            statusLabel.text = "Available for Check out"
        } else{
            statusLabel.backgroundColor = UIColor(red: 200/255, green: 0/255, blue: 50/255, alpha: 1.0)
            statusLabel.text = "Available for Check in"
        }
    }
    
    func inventoryTagFound(_ tag: UgiTag,
                           withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]?) {
      //  self.displayedTags.append(tag)
      //  self.tagToDetailString[tag] = NSMutableString()
        
        self.tagToString.append(tag.epc.toString())
        clearerstring(tag: tag.epc.toString())
        //   self.inventory?.pause()
        tableOfItems.reloadData()
        for i in itemsFound{
            if(i == true){
                complete = complete + 1
            }
        }
        if(complete == 6){
            Ugi.singleton().activeInventory?.stop()
        }else{
            complete = 0
        }
    }
    
    func clearerstring( tag: String){
        var tags = tag
        //let i = self.tagToString.count - 1
      //  while(i>=0){
            //self.tagToString[i] = String(self.tagToString[i].dropFirst(22))
        tags = String(tag.dropFirst(19))
            print("Cleaned Tag is Item" , tags)
            if kitOfAction?.kitNumber == String(tags.dropLast(2)){
                itemsFound[(Int(String(tags.dropFirst(4))) ?? 1) - 1] = true
                }
        
      //      i=i-1
      //  }
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
