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
        TitleKitNameLabel.text = name
        
        let ID_1 = kitOfInterest?.items[0]
        Item1ID.text = String(ID_1!)
        let ID_2 = kitOfInterest?.items[1]
        Item1ID.text = String(ID_2!)
        let ID_3 = kitOfInterest?.items[2]
        Item1ID.text = String(ID_3!)
        let ID_4 = kitOfInterest?.items[3]
        Item1ID.text = String(ID_4!)
        let ID_5 = kitOfInterest?.items[4]
        Item5ID.text = String(ID_5!)
        let ID_6 = kitOfInterest?.items[5]
        Item6ID.text = String(ID_6!)
        
            
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
            return "available"
        }
        else {
            return "unavailable"
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
