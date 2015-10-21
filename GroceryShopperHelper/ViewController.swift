//
//  ViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet Babu on 10/17/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
        //let email = MFMailComposeViewController()
        //email.setSubject(showName.text!)
        //email.mailComposeDelegate = self
        //self.presentViewController(email, animated: true, completion: {})
        //let store = showName.text!
        //let activityViewController = UIActivityViewController(activityItems: [store as NSString], applicationActivities: nil)
        //presentViewController(activityViewController, animated: true, completion :{})
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setSubject(showName.text!)
        mailComposerVC.setMessageBody("List will be here!", isHTML: false)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func DismissKeyboard(){
        view.endEditing(true)
    }

}

