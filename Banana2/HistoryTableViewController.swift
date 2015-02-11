//
//  HistoryTableViewController.swift
//  Banana2
//
//  Created by Ray Lin on 1/18/15.
//  Copyright (c) 2015 Ray Lin. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.navigationItem.title = "Banana History"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var fetchRequest = NSFetchRequest(entityName: "Banana")
        var error: NSError? = nil
        
        var results: NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
        
        return results.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        var fetchRequest = NSFetchRequest(entityName: "Banana")
        var error: NSError? = nil
        
        var results: NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
        
        var result = results[indexPath.row] as Banana
        
        var dateformatter: NSDateFormatter  = NSDateFormatter()
        
        dateformatter.dateFormat = "MM-dd-yyyy"
        
        var dateBought = dateformatter.stringFromDate(result.dateBought)
        
        var browndate = "Tracking in progress"
        if let tempdate = result.dateBrown {
            
            browndate = dateformatter.stringFromDate(tempdate)
        }
        
        
        cell.textLabel!.text = "Bought \(result.numberBought) bananas on \(dateBought)"
        if result.numberBrown == nil {
            cell.detailTextLabel!.text = "Banana tracking currently in progress"
        }
        else
        {
            cell.detailTextLabel!.text = "Finished \(Int(result.numberBought) - Int(result.numberBrown!)) bananas on \(browndate)"
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            var fetchRequest = NSFetchRequest(entityName: "Banana")
            var error: NSError? = nil
            
            var results: NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
            
            var result = results[indexPath.row] as Banana
            
            managedObjectContext?.deleteObject(result)
            appDelegate.saveContext()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //currently not used
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
