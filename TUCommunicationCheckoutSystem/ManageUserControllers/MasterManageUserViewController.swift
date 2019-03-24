//
//  MasterManageUserViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Michael Bryce on 3/24/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class MasterManageUserViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self as? UISplitViewControllerDelegate
        self.preferredDisplayMode = .allVisible
        guard let leftNavController = self.viewControllers.first as? UINavigationController,
            
            let UserTableView = leftNavController.topViewController as? UserTableViewController,
            
            let detailViewController = self.viewControllers.last as? UserDetailViewController
            else{
                fatalError()
        }
        //let firstKit = InventoryTableView.kits.first
        //detailViewController.kitOfInterest = firstKit ?? Kit(kitNumber: "Error", items: [0,0,0,0,0,0], checkIn: "", checkOut: "", lastUsers: [], available: false)
        UserTableView.selectionDelegate = detailViewController
        // Do any additional setup after loading the view.*/
        
    }
}
