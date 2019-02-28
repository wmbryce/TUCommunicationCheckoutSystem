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
        TitleKitNameLabel.text = kitOfInterest?.kitName
        let ID_1 = kitOfInterest?.items[0] as! Int
        Item1ID.text = String(ID_1) 
        let ID_2 = kitOfInterest?.items[1] as! Int
        Item2ID.text = String(ID_2)
        let ID_3 = kitOfInterest?.items[2] as! Int
        Item3ID.text = String(ID_3)
        let ID_4 = kitOfInterest?.items[3] as! Int
        Item4ID.text = String(ID_4)
        let ID_5 = kitOfInterest?.items[4] as! Int
        Item5ID.text = String(ID_5)
        let ID_6 = kitOfInterest?.items[5] as! Int
        Item6ID.text = String(ID_6)
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
