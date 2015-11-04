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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "doneSegue" {
            name = grocName.text!
        }
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    

}
