//
//  CheckinoutViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit
import Firebase

let SPECIAL_FUNCTION_NONE = 0
let SPECIAL_FUNCTION_READ_USER_MEMORY = 1
let SPECIAL_FUNCTION_READ_TID_MEMORY = 2
let SPECIAL_FUNCTION_READ_RF_MICRON_MAGNUS_SENSOR_CODE = 3
let SPECIAL_FUNCTION_RF_MICRON_MAGNUS_TYPE = UgiRfMicronMagnusModels.UGI_RF_MICRON_MAGNUS_MODEL_402
let SPECIAL_FUNCTION_RF_MICRON_MAGNUS_LIMIT_TYPE = UgiRfMicronMagnusRssiLimitTypes.UGI_RF_MICRON_MAGNUS_LIMIT_TYPE_LESS_THAN_OR_EQUAL
let SPECIAL_FUNCTION_RF_MICRON_MAGNUS_LIMIT_THRESHOLD: Int32 = 31
let SPECIAL_FUNCTION_READ_RF_MICRON_MAGNUS_TEMPERATURE = 4
let UGI_IVENTORY_SOUNDS_GEIGER_COUNTER = 1

protocol checkKitSelectionDelegate:class {
    func checkKitItems(_ checkKit: Kit)
}

class CheckinoutViewController: UgiViewController, UgiInventoryDelegate {
    
    let ref = Database.database().reference(withPath: "kits")
    weak var passingDelegate:checkKitSelectionDelegate?
    var kits = [Kit]()
    var kitToCheck:Kit?{
        didSet{
            self.performSegue(withIdentifier: "TransitToCheckItems", sender: self)
        }
    }
    var kitchecknum: String = ""
    var timer: Timer = Timer()
    var inventoryType: UgiInventoryTypes = UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE
    var specialFunction: Int = SPECIAL_FUNCTION_NONE
    var inventory: UgiInventory?
    var displayedTags: [UgiTag] = []
    var tagToCellMap: [UgiTag : UgiTagCell] = [:]
    var tagToDetailString: [UgiTag : NSMutableString] = [:]
    var tagToString: [String] = []
    var previousActivation = 0
    var reset = 0
    var scanning = false
    var silence = UgiGeigerCounterSound(frequency: 1046, durationMsec: 2, clickRate: 3, maxClicksPerSecond: 3, historyDepthMsec: 0)
    //var powerSetting = UgiSingleFindRampPowerModes
    //Need to change power settings
    @IBOutlet weak var connectionStatusUGrokIt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView!.batteryStatusIndicatorDisplayVersionInfoOnTouch = true
        self.displayDialogIfDisconnected = true
        ref.keepSynced(true)
        ref.observe(.value, with: { snapshot in
            var newKits: [Kit] = []
            for child in snapshot.children {
                //   print(child)
                if let snapshot2 = child as? DataSnapshot{
                    if let newKit = Kit(snapshot: snapshot2){
                        newKits.append(newKit)
                    }
                }
            }
            self.kits = newKits
        })
    }
    
    
    
    @IBAction func ScanButton(_ sender: Any) {
        Scan()
    }
    
    
    func Scan() {
        print(scanning)
        if !scanning {
            self.tagToString.removeAll()
            self.displayedTags.removeAll()
            self.tagToCellMap.removeAll()
            self.tagToDetailString.removeAll()
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
            if(reset == 0){
                Ugi.singleton().setGeigerCounterSound(&silence)
                Ugi.singleton().startInventory(self, with: config)
                reset = 1
            } else{
                Ugi.singleton().activeInventory?.resumeInventory()
            }
            scanning = !scanning
        }
        else {
            Ugi.singleton().activeInventory?.pause()
            scanning = !scanning
        }
    }

    

    
    @IBAction func unwindToCheckOutViewController(_ sender: UIStoryboardSegue){
        print("Does this unwind even go down?")
        let action = (kitToCheck?.available)! ? "checked out" : "checked in"
        print(action)
        giveConfirmation(reason: "Kit was successfully " + action)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        print("does the program prepare at all?")
        guard let NavCheckViewController = segue.destination as? NavCheckoutViewController,
            let checkItemsView = NavCheckViewController.viewControllers.first as? CheckItemsViewController
            else {
                print("Other Transit no action necessary" )
                return
        }
        print("preparing for dat seg doe")
        
        checkItemsView.kitOfAction = kitToCheck
        checkItemsView.inventory = Ugi.singleton().activeInventory
    }

   

    @IBAction func manualKitEntry(_ sender: Any) {
        let alert = UIAlertController(title: "Check Kit",
                                      message: "Please enter the kit identification number",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Check", style: .default) { _ in
        var validKitFound = false
            guard let textField = alert.textFields?.first,      
                let newkitNumber = textField.text else { return }
            //print(self.kits)
            //print("here part 2")
            //print(newkitNumber)
            for i in self.kits{
                //print(testKit, "compared with ", i.kitNumber)
                if newkitNumber == i.kitNumber{
                    //self.passingDelegate?.checkKitItems(i)
                    self.kitToCheck = i
                    validKitFound = true
                    
                    //let checkItems = CheckItemsViewController()
                    //self.present(checkItems,animated: true, completion: nil)
                }
            }
            if !validKitFound {
                self.ThrowError(reason: "That kit number does not exist")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func Back(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
 
    func inventoryTagFound(_ tag: UgiTag,
                           withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]?) {
        self.displayedTags.append(tag)
        self.tagToDetailString[tag] = NSMutableString()
        self.tagToString.append(tag.epc.toString())
     //   self.inventory?.pause()
        print("The Tag is" , tagToString)
        Ugi.singleton().activeInventory?.stop()
        reset = 0
        scanning = false
        clearerstring()
    }
    
    func clearerstring(){
        var i = self.tagToString.count - 1
        while(i>=0){
            self.tagToString[i] = String(self.tagToString[i].dropFirst(19))
            print("Cleaned Tags are" , self.tagToString[i])
            i=i-1
        }
       // self.kitToCheck = Kit(kitNumber: String(self.tagToString[0].dropLast(2)), items: [tagToString], checkIn: "help", checkOut: "help", lastUsers: ["help"], available: true)
        kitchecknum = String(self.tagToString[0].dropLast(2))
        print("Kit to Check" , kitchecknum)
        i = self.kits.count-1
        while(i>=0){
            if(kitchecknum == self.kits[i].kitNumber){
                self.kitToCheck = self.kits[i] //sets kitToCheck which triggers transition
            }
            i=i-1
        }
        //checkForValidKitNumber(testKit: kitchecknum)
        //print("kitToCheck" , self.kitToCheck?.kitNumber)
    }
    
    // Extra Functions
    func checkForValidKitNumber(testKit:String) -> Bool{
        print("here")
        for i in self.kits{
            //print(testKit, "compared with ", i.kitNumber)
            if testKit == i.kitNumber{
                
                return true
            }
        }
        ThrowError(reason: "That kit number does not exist")
        return false
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
    func giveConfirmation(reason:String) {
        let alert = UIAlertController(title: "Confirmation",
                                      message: reason,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok",
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

