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

var player = AVAudioPlayer()
var set = false

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var lat: Double?
    var lon: Double?
    var valueToPass: String!
    var grocs: Dictionary<String, [String]> = [String:[String]]()
    var ids = [3068, 16553, 690, 34889, 32478, 29159, 6868 , 4922, 29262, 13464, 25630, 29037, 11264, 29265, 13856, 12926, 17038, 15368, 11496, 33552, 7981, 2715, 8675, 2406, 1340, 12239, 2425, 16373, 11064, 13271, 11114, 15463, 8105, 14726, 15449, 11065, 15089, 1349, 28789, 32735, 4151, 5484, 2402, 2307, 7211, 9183, 5153, 5104, 16029, 23991, 12323, 8170, 13498, 4052, 13314]
    
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
        set = setPlay()
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
                displayAlertWithTitle("No Location Services",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                createLocationManager(startImmediately: true)
                if let manager = self.locationManager {
                    manager.requestAlwaysAuthorization()
                }
            case .Restricted:
                displayAlertWithTitle("No Location Services",
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
                    displayAlertWithTitle("No Location Services",
                        message: "Location services are not allowed for this app")
                case .NotDetermined:
                    createLocationManager(startImmediately: true)
                    if let manager = self.locationManager {
                        manager.requestAlwaysAuthorization()
                    }
                case .Restricted:
                    displayAlertWithTitle("No Location Services",
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
    
    func setPlay() -> Bool{
        let path = NSBundle.mainBundle().pathForResource("Jazzy Elevator Music", ofType: "mp3")
        if(path != nil){
            let url = NSURL.fileURLWithPath(path!)
            do{
                player = try AVAudioPlayer(contentsOfURL: url)
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
                return true
            }
            catch let error as NSError {
                print(error.description)
            }
        }
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        let path = NSTemporaryDirectory() + "MyFile.txt"
        grocs = NSDictionary(contentsOfFile: path) as! Dictionary
        table.reloadData()
        //print(grocs)
    }
    
    @IBAction func createEntry(sender: AnyObject) {
        if(!(nameText.text!.isEmpty)) {
            grocs[nameText.text!] = []
            valueToPass = nameText.text!
            save()
        }
        else{
            valueToPass = ""
            let alert = UIAlertController(title: "List Name is Blank",
                message: "Please enter a name for your list.",
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
                    print("Please don't crash...")
            }))
            
            presentViewController(alert, animated: true, completion: nil)
        
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
                locationManager = nil
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
        let readArray:Dictionary<String, [String]> = NSDictionary(contentsOfFile: path) as! Dictionary!
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
            let items:[AnyObject] = [AnyObject](arrayLiteral: readArray[nameText.text!]!)
            var body = ""
            for item in items{
                var str = String(item)
                str = str.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                str = str.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                str = str.stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                str = str.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                if(!str.isEmpty){
                    body += str+"\n"
                }
            }
            mailComposerVC.setMessageBody(body, isHTML: false)
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
        if (segue.identifier == "soundSeg"){
            if (set){
                player.stop()
            }
        }
        if (segue.identifier == "mapSeg" && locationManager != nil) {
            if let svc = segue.destinationViewController as? MapViewController {
                svc.lat = lat
                svc.lon = lon
                
            }
        }
        if (segue.identifier == "mapSeg" && locationManager == nil){
            let alert = UIAlertController(title: "Location Services not Enabled",
                message: "Location services aren't enabled for this app. Please enable them in Settings.",
                preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: { (action: UIAlertAction!) in
                    print("Please don't crash...")
            }))
            
            presentViewController(alert, animated: true, completion: nil)        }
        if (segue.identifier == "addSeg" && !valueToPass.isEmpty) {
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let selCell = tableView.cellForRowAtIndexPath(indexPath)
            let selCellS = selCell?.textLabel?.text
            grocs.removeValueForKey(selCellS!)
            save()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    @IBAction func generateRecipe(sender: AnyObject) {
        // Get first post
        let randomIndex = Int(arc4random_uniform(UInt32(ids.count)))
        let postEndpoint: String = "http://food2fork.com/api/get?key=ed4df78c74113a90f9999afb913ebe04&rId=\(ids[randomIndex])"
        guard let url = NSURL(string: postEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = NSURLRequest(URL: url)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            // parse the result as JSON, since that's what the API provides
            let post: NSDictionary
            do {
                post = try NSJSONSerialization.JSONObjectWithData(responseData,
                    options: []) as! NSDictionary
                let plc: NSDictionary = post["recipe"] as! NSDictionary
                let titl = plc["title"] as! String
                let ingr = plc["ingredients"] as! [String]
                dispatch_async(dispatch_get_main_queue(), {
                    self.grocs[titl] = ingr
                    self.save()
                    self.table.reloadData()
                    print(self.grocs)
                })
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // now we have the post, let's just print it to prove we can access it
            //print("The post is: " + post.description)
            
            // the post object is a dictionary
            // so we just access the title using the "title" key
            // so check for a title and print it if we have one
            if let postTitle = post["title"] as? String {
                print("The title is: " + postTitle)
            }
        })
        task.resume()
    }
}

