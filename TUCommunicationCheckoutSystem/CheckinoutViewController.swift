//
//  CheckinoutViewController.swift
//  TUCommunicationCheckoutSystem
//
//  Created by Suarez IPhone on 3/24/19.
//  Copyright © 2019 CheckoutGurus. All rights reserved.
//

import UIKit

class CheckinoutViewController: UIViewController {

    var inven: Array<String> = ["a"]
    var i: Int = 0
    var pause: Int = 0
    var whatkit: Int = 0 //This tells me what kit I have. Although this wil probably need to be a global variable
    override func viewDidLoad() {
        super.viewDidLoad()
        Ugi.singleton().openConnection()
    }
    
    func getkitnum(help:UgiTag) -> String{
       // var helped = String(help)
        var helped = help.hfName
        print(helped)
        var i = helped.count
        i=i-1
        while(i>6){
            helped.removeFirst()
            i=i-1
        }
       // helped = helped.replacingOccurrences(of: "0", with: "", options: NSString.CompareOptions.literal, range: nil)
        print(helped)
        return helped
    }
    
    func testkit(tags: [String]) -> Bool{
        return true
    }
    
    func checkinven(item: String){
        
    }
    
    func matchkit(tags: [String]){
        
    }
    
    func read(){
        //  Ugi.singleton().closeConnection()
        //    Ugi.singleton().activeInventory?.tags.forEach { (tag) in
        //        inven[i] = getkitnum(help: tag)
        //        i+=1
        //    }
        if(Ugi.singleton().activeInventory?.tags.count ?? 0>0){
            inven.append(getkitnum(help: (Ugi.singleton().activeInventory?.tags[0])!))
            print(inven)
        }
        if (inven.count == 6){
            if(testkit(tags: inven)){
                //Here I will move to another screen that gives the proper kit.
            }
            else{
                //Here we will move onto an error screen about not having the right tags for a kit.
            }
        }
        else{
            //Here move to error screen about not having enough tags (have a function to match to theoretical kit with missing parts.)
        }
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
