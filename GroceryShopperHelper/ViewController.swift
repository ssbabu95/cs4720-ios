//
//  ViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet Babu on 10/17/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var showName: UILabel!

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var promptTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.showName.text = "";
        createButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        promptTitle.adjustsFontSizeToFitWidth = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeName(sender : AnyObject) {
        showName.text = "Grocery list for " + nameText.text! + " will be created.";
        showName.adjustsFontSizeToFitWidth = true;
        
    }
    
    @IBAction func pinchAction(sender: UIPinchGestureRecognizer) {
        nameText.text = "Bob";
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        
        let store = showName.text!;
        let activityViewController = UIActivityViewController(activityItems: [store as NSString], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion :{})
        
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    

    


}

