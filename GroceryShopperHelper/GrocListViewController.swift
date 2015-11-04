//
//  GrocListViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet on 10/28/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit

class GrocListViewController: UITableViewController {
    
    var storeName: String = ""
    var oldList: Dictionary<String, [String]> = ["":[""]]
    var newGroc: String = ""
    
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
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let grocDetailVC = segue.sourceViewController as! GrocDetailViewController
        newGroc = grocDetailVC.name
        
        (oldList[storeName]!).append(newGroc)
        
        self.tableView.reloadData()
    }
    
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
