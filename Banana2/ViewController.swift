//
//  ViewController.swift
//  Banana2
//
//  Created by Ray Lin on 1/18/15.
//  Copyright (c) 2015 Ray Lin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var button: UIButton!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    //openbanana is to set the current state to either banana is complete or in process
    //open banana is false when there is no banana open (ok to add new banana)
    var openBanana = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch all bananas and check if any bananas are open to set initial banana state
        
        var fetchRequest = NSFetchRequest(entityName: "Banana")
        var error: NSError? = nil
        
        var results: NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
        
        for result in results {
            var temp = result as Banana
            if temp.numberBrown == nil {
                self.changeToBrownState()
            }
        }
        
        //add logo to nav bar
        //adding banana logo to UIimage and then putting it in uiimageview
        let navBarImage: UIImage = UIImage(named: "banana-logo.png")!
        var navImageView: UIImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 164, height: 20))
        navImageView.image = UIImage(named: "banana-logo.png")
        
        //workaround to resize image on navbar http://stackoverflow.com/questions/17719947/size-of-image-on-uinavigationbar
        var workaroundImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 164, height: 20))
        workaroundImageView.addSubview(navImageView)
        self.navigationItem.titleView = workaroundImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        numberField.resignFirstResponder()
    }
    
    //this is to put the state of the app to in process banana mode
    func changeToBrownState(){
        numberField.placeholder = "Number of bananas brown"
        button.setTitle("Finish", forState: UIControlState.Normal)
        self.openBanana = true
        numberField.text = ""
        numberField.resignFirstResponder()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }
    
    //this is to set the state of app to initial mode
    func changeToAddState(){
        numberField.placeholder = "Number of bananas bought"
        button.setTitle("Add", forState: UIControlState.Normal)
        self.openBanana = false
        numberField.text = ""
        numberField.resignFirstResponder()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func addNewBanana(sender: AnyObject) {
        
        if openBanana == false && numberField.text != "" {
            //add banana
            let entityDescription = NSEntityDescription.entityForName("Banana", inManagedObjectContext: managedObjectContext!)
            var newBanana = Banana(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
            newBanana.numberBought = (numberField.text as NSString).doubleValue
            newBanana.dateBought = datepicker.date
            newBanana.numberBrown = nil
            newBanana.dateBrown = nil
            appDelegate.saveContext()
            self.changeToBrownState()
            
            //present message that banana was saved and is open to be finished later
            var alert = UIAlertController(title: "Congratulations!", message: "Your Banana Tracker™ has been started! Come back to the app when your bananas inevitably turn brown and are thus inedible. After returning, log the number of brown bananas to be thrown out. Press the ℹ button in the bottom right corner to get your banana analysis.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if openBanana == true && numberField.text != "" {
            var fetchRequest = NSFetchRequest(entityName: "Banana")
            var error: NSError? = nil
            var results: NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
            
            // check all bananas for open banana
            for result in results {
                var temp = result as Banana
                var tempNumberBought: Int = Int(temp.numberBought)
                var tempNumberField: Int = (numberField.text as NSString).integerValue
                
                //condition if banana is open and ready to be closed
                if temp.numberBrown == nil &&  tempNumberBought >= tempNumberField && datepicker.date.compare(temp.dateBought) != NSComparisonResult.OrderedAscending {
                    temp.numberBrown = (numberField.text as NSString).doubleValue
                    temp.dateBrown = datepicker.date
                    appDelegate.saveContext()
                    self.changeToAddState()
                    //change to analysis view
                    
                    self.performSegueWithIdentifier("showAnalysis", sender: self)
                }
                //present error if number bought less than number brown
                else if temp.numberBrown == nil && tempNumberBought < tempNumberField && datepicker.date.compare(temp.dateBought) != NSComparisonResult.OrderedAscending {
                    var numberAlert = UIAlertController(title: "", message: "You cannot have more bananas than you started with. Check your history.", preferredStyle: UIAlertControllerStyle.Alert)
                    numberAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(numberAlert, animated: true, completion: nil)
                }
                //present error if browndate is less than bought date
                else if temp.dateBrown == nil && datepicker.date.compare(temp.dateBought) == NSComparisonResult.OrderedAscending {
                    var dateAlert = UIAlertController(title: "", message: "Your current finish date is before your start date. That is not possible.", preferredStyle: UIAlertControllerStyle.Alert)
                    dateAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(dateAlert, animated: true, completion: nil)
                }
            }
            
        }
        else {
            
            //present alert if not a number or blank
            var alert = UIAlertController(title: "", message: "The banana field cannot be blank, knucklehead.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func infoButtonTapped(sender: AnyObject) {
        var fetchRequest = NSFetchRequest(entityName: "Banana")
        var error: NSError? = nil
        var results: NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error)!
        
        if results.count == 0 {
            var emptyAlert = UIAlertController(title: nil, message: "You have no bananas so there is no analysis to show", preferredStyle: UIAlertControllerStyle.Alert)
            emptyAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(emptyAlert, animated: true, completion: nil)
        }
        else {
            self.performSegueWithIdentifier("showAnalysis", sender: self)
        }
        

    }
    
}

