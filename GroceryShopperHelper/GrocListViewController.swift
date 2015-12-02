//
//  GrocListViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet on 10/28/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit
extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
class GrocListViewController: UITableViewController {
    
    var storeName: String = ""
    var oldList: Dictionary<String, [String]> = ["":[""]]
    var newGroc: String = ""
    var tF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSTemporaryDirectory() + "MyFile.txt"
        oldList = NSDictionary(contentsOfFile: path) as! Dictionary
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(animated: Bool) {
        save()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return oldList[storeName]!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCellWithIdentifier("grocCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = (oldList[storeName]!)[indexPath.row]
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let selCell = tableView.cellForRowAtIndexPath(indexPath)
            let selCellS = selCell?.textLabel?.text
            var intArr = oldList[storeName]
            intArr?.removeObject(selCellS!)
            oldList[storeName] = intArr
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    

    
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let grocDetailVC = segue.sourceViewController as! GrocDetailViewController
        newGroc = grocDetailVC.name
        if(!newGroc.isEmpty){
            (oldList[storeName]!).append(newGroc)
        }
        
        self.tableView.reloadData()
    }
    
    func configTF(textField: UITextField!){
        tF = textField
    }
    
    @IBAction func add(){
        let alert = UIAlertController(title: "Add Item",
            message: "",
            preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(configTF)
        alert.addAction(UIAlertAction(title: "Done",
            style: .Default,
            handler: { (action: UIAlertAction!) in
                if(!self.tF.text!.isEmpty){
                    self.newGroc = self.tF.text!
                    (self.oldList[self.storeName]!).append(self.newGroc)
                    self.tableView.reloadData()
                }
                else{
                    let fail = UIAlertController(title: "Blank item", message: "Please enter an item to add.", preferredStyle: .Alert)
                    fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(action: UIAlertAction!) in
                        print("pls pls no die")}))
                    self.presentViewController(fail, animated: true, completion: nil)
                }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(action: UIAlertAction!) in
            print("pls no die")}))
        presentViewController(alert, animated: true, completion: nil)    }
    
    func save() {
        let path = NSTemporaryDirectory() + "MyFile.txt"
        if (NSDictionary(dictionary: oldList)).writeToFile(path, atomically: true) {
            let readArray:NSDictionary? = NSDictionary(contentsOfFile: path)
            if let array = readArray {
                print("Could read the array back = \(array)")
            }
                else {
                print("Failed to read the array back")
            }
        }
    }

}
