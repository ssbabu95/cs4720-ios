//
//  ViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet Babu on 10/17/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation
import CoreLocation

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var lat: Double?
    var lon: Double?
    var valueToPass: String!
    var grocs: Dictionary<String, [String]> = [String:[String]]()
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var promptTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.contentSize.height = 600
        
        let manager = NSFileManager.defaultManager()
        let path = NSTemporaryDirectory() + "MyFile.txt"
        if (manager.fileExistsAtPath(path)) {
        
        if CLLocationManager.locationServicesEnabled(){
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                createLocationManager(startImmediately: true)
            case .Denied:
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                createLocationManager(startImmediately: true)
                if let manager = self.locationManager {
                    manager.requestAlwaysAuthorization()
                }
            case .Restricted:
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            print("Location services are not enabled")
        }
        createButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        shareButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        }
        else {
            try (NSDictionary(dictionary: grocs)).writeToFile(path, atomically: true)
            
            if CLLocationManager.locationServicesEnabled(){
                
                switch CLLocationManager.authorizationStatus(){
                case .AuthorizedAlways:
                    createLocationManager(startImmediately: true)
                case .AuthorizedWhenInUse:
                    createLocationManager(startImmediately: true)
                case .Denied:
                    displayAlertWithTitle("Not Determined",
                        message: "Location services are not allowed for this app")
                case .NotDetermined:
                    createLocationManager(startImmediately: true)
                    if let manager = self.locationManager {
                        manager.requestAlwaysAuthorization()
                    }
                case .Restricted:
                    displayAlertWithTitle("Restricted",
                        message: "Location services are not allowed for this app")
                }
                
                
            } else {
                print("Location services are not enabled")
            }
            createButton.titleLabel?.adjustsFontSizeToFitWidth = true;
            shareButton.titleLabel?.adjustsFontSizeToFitWidth = true;
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        

    }
    
    override func viewWillAppear(animated: Bool) {
        let path = NSTemporaryDirectory() + "MyFile.txt"
        grocs = NSDictionary(contentsOfFile: path) as! Dictionary
        table.reloadData()
    }
    
    @IBAction func createEntry(sender: AnyObject) {
        if(nameText.text != "") {
            grocs[nameText.text!] = []
            valueToPass = nameText.text!
            save()
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            print("?")
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        lat = newLocation.coordinate.latitude
        lon = newLocation.coordinate.longitude
        
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    
    @IBAction func shareAction(sender: AnyObject) {
        
        let path = NSTemporaryDirectory() + "MyFile.txt"
        let readArray:Dictionary = NSDictionary(contentsOfFile: path) as Dictionary!
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        if (nameText.text! == "" || !Array(readArray.keys).contains(nameText.text!)) {
            let refreshAlert = UIAlertController(title: "Invalid List", message: "Please enter a valid list into the text box", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
        else{
            mailComposerVC.setSubject(nameText.text!)
            mailComposerVC.setMessageBody(String(readArray[nameText.text!]), isHTML: false)
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposerVC, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "mapSeg") {
            if let svc = segue.destinationViewController as? MapViewController {
                svc.lat = lat
                svc.lon = lon
                
            }
        }
        if (segue.identifier == "addSeg") {
            if let svc = segue.destinationViewController as? GrocListViewController {
                svc.storeName = valueToPass
            }

        }
    }
    
    func save() {
        let path = NSTemporaryDirectory() + "MyFile.txt"
        if (NSDictionary(dictionary: grocs)).writeToFile(path, atomically: true) {
            let readArray:NSDictionary? = NSDictionary(contentsOfFile: path)
            if let array = readArray {
                print("Could read the array back = \(array)")
            }
            else {
                print("Failed to read the array back")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return (Array(grocs.keys)).count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCellWithIdentifier("groCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = (Array(grocs.keys))[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow;
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        valueToPass = currentCell.textLabel!.text
        
        performSegueWithIdentifier("addSeg", sender: self)
        
    }
}

