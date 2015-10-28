//
//  GrocListViewController.swift
//  GroceryShopperHelper
//
//  Created by Sumeet on 10/28/15.
//  Copyright © 2015 Sumeet Babu. All rights reserved.
//

import UIKit

class GrocListViewController: UITableViewController {

    var groclist = [String]()
    var newGroc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groclist = ["Pre", "Populated", "List"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return groclist.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCellWithIdentifier("grocCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = groclist[indexPath.row]
        return cell
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        let grocDetailVC = segue.sourceViewController as! GrocDetailViewController
        newGroc = grocDetailVC.name
        
        groclist.append(newGroc)
        
        self.tableView.reloadData()
    }

}
