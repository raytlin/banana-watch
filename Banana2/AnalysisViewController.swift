//
//  AnalysisViewController.swift
//  Banana2
//
//  Created by Ray Lin on 1/18/15.
//  Copyright (c) 2015 Ray Lin. All rights reserved.
//

import UIKit
import CoreData

class AnalysisViewController: UIViewController {

    @IBOutlet weak var averageBananas: UILabel!
    @IBOutlet weak var averageDays: UILabel!
    @IBOutlet weak var totalBanana: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get all bananas to do banana analysis
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetch all bananas and get some initial values
        var fetchrequest = NSFetchRequest(entityName: "Banana")
        var error : NSError? = nil
        
        var results : NSArray = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!.executeFetchRequest(fetchrequest, error: &error)!
        
        var totalBananasEaten: Double = 0
        var totalBananaDays: Double = 0
        
        //initially set the eligible days to total count, change if see an open banana
        var eligibleBananaDays: Double = Double(results.count)
        
        
        
        
        for result in results {
            var banana = result as Banana
            if banana.numberBrown != nil {
                totalBananasEaten = totalBananasEaten + (Double(banana.numberBought) - Double(banana.numberBrown!))
                let cal = NSCalendar.currentCalendar()
                var components = cal.components(NSCalendarUnit.DayCalendarUnit, fromDate: banana.dateBought, toDate: banana.dateBrown!, options: nil)
                totalBananaDays = totalBananaDays + Double(components.day)
            }
            else {
                //only do this if the banana brown is nil so there is an open banana 
                //set the eligible bananas less one to account for the open banana
                eligibleBananaDays = eligibleBananaDays - 1
            }
        }
        
        self.averageBananas.text =  "\(totalBananasEaten / totalBananaDays)"
        self.averageDays.text = "\(totalBananaDays / eligibleBananaDays)"
        
        self.totalBanana.text = "You should buy \((totalBananaDays / eligibleBananaDays) * (totalBananasEaten / totalBananaDays)) banana(s) every \((totalBananaDays / eligibleBananaDays)) day(s)!"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
