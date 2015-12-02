//
//  GrocDetailViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet on 10/28/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit

class GrocDetailViewController: UIViewController {

    var name: String = ""
    
    @IBOutlet weak var grocName: UITextField!
    
    @IBOutlet weak var sV: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sV.contentSize.height = 600
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "doneSegue" && !grocName.text!.isEmpty){
            name = grocName.text!
            return true;
        }
        else if (identifier == "doneSegue"){
            let alert = UIAlertController(title: "Item is Blank",
                message: "Please enter an item to add.",
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
                    print("Please don't crash...")
            }))
            presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true;
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    

}
