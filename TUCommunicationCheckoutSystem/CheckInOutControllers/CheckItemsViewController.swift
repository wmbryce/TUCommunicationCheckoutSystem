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
    
    @IBAction func Cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
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
        ref.observe(.value, with: { snapshot in
            var newKits: [Kit] = []
            for child in snapshot.children {
                print(child)
                if let snapshot2 = child as? DataSnapshot{
                    if let newKit = Kit(snapshot: snapshot2){
                        newKits.append(newKit)
                    }
                }
            }
            
            self.kits = newKits
            self.kitToCheck = self.kits.popLast()
            print("kits successfully initalized")
        })
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kitToCheck?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? CheckItemsTableViewCell else { fatalError("The dequeued cell is not an instance of InventoryTableViewCell")
        }
        
        let currentItem = String(kitToCheck?.items[indexPath.row] as! Int)
        let present = false
        cell.setLabels(found: present, Name: currentItem)
        //os_log("setting the labels works", log: OSLog.default, type: .debug)
        return cell
    }
    
    
    func refreshItemCheck(){
        KitTitle.text = "Kit " + (kitToCheck?.kitNumber ?? "error")
        
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
