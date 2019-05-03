//
//  KitDetailsViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 2/27/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class KitDetailsViewController: UIViewController {

    @IBOutlet weak var TitleKitNameLabel: UILabel!
    
    @IBOutlet weak var Item1ID: UILabel!
    @IBOutlet weak var Item2ID: UILabel!
    @IBOutlet weak var Item3ID: UILabel!
    @IBOutlet weak var Item4ID: UILabel!
    @IBOutlet weak var Item5ID: UILabel!
    @IBOutlet weak var Item6ID: UILabel!
    
    @IBOutlet weak var Item1Name: UILabel!
    @IBOutlet weak var Item2Name: UILabel!
    @IBOutlet weak var Item3Name: UILabel!
    @IBOutlet weak var Item4Name: UILabel!
    @IBOutlet weak var Item5Name: UILabel!
    @IBOutlet weak var Item6Name: UILabel!
    
    @IBOutlet weak var checkOutDate: UILabel!
    @IBOutlet weak var checkInDate: UILabel!
    
    @IBOutlet weak var AvailabilityLabel: UILabel!
    
    var kitOfInterest: Kit? {
        didSet{
            refreshUI()
        }
    }
    
    func refreshUI(){
        loadViewIfNeeded()
        let name = kitOfInterest?.kitNumber
        TitleKitNameLabel.text = "Kit " + name!
        let ID_1 = kitOfInterest?.items[0][1]
        Item1ID.text = String(ID_1!)
        Item1Name.text = (kitOfInterest?.items[0][0])! + ": "
        let ID_2 = kitOfInterest?.items[1][1]
        Item2ID.text = String(ID_2!)
        Item2Name.text = ((kitOfInterest?.items[1][0])!) + ": "
        let ID_3 = kitOfInterest?.items[2][1]
        Item3ID.text = String(ID_3!)
        Item3Name.text = (kitOfInterest?.items[2][0])! + ": "
        let ID_4 = kitOfInterest?.items[3][1]
        Item4ID.text = String(ID_4!)
        Item4Name.text = (kitOfInterest?.items[3][0])! + ": "
        let ID_5 = kitOfInterest?.items[4][1]
        Item5ID.text = String(ID_5!)
        Item5Name.text = (kitOfInterest?.items[4][0])! + ": "
        let ID_6 = kitOfInterest?.items[5][1]
        Item6ID.text = String(ID_6!)
        Item6Name.text = (kitOfInterest?.items[5][0])! + ": "
        
            
        checkOutDate.text = kitOfInterest?.checkOut ?? "" 
        checkInDate.text =  kitOfInterest?.checkIn ?? ""
        
        AvailabilityLabel.text = availableString(available: kitOfInterest?.available ?? false)
    }
    
    func formatedDate(dateInfo:NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: dateInfo as Date)
    }
    
    func availableString(available:Bool) -> String {
        if available {
            return "Available"
        }
        else {
            return "Checked Out"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension KitDetailsViewController: KitSelectionDelegate{
    func kitSelected(_ newKit: Kit) {
        kitOfInterest = newKit
    }
}
