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
