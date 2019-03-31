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
        print("Does this even run?")
        super.viewDidLoad()
        self.delegate = self as? UISplitViewControllerDelegate
        self.preferredDisplayMode = .allVisible
        guard let UserleftNavController = self.viewControllers.first as? UINavigationController,
            
            let UserTableView = UserleftNavController.topViewController as? UserTableViewController,
            
            let UserdetailViewController = self.viewControllers.last as? UserDetailViewController
            else{
                fatalError()
        }
        print("In MasterManageUser")
        //UserTableView.selectionDelegate = UserdetailViewController
        
        // Do any additional setup after loading the view.*/
        
    }
}
