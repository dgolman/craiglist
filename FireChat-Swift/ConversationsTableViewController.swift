//
//  ConversationsTableViewController.swift
//  FireChat-Swift
//
//  Created by Daniel Golman on 2/6/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit
import CoreLocation

class ConversationsTableViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var user: FAuthData!
    var buyer: String!
    let conversationsRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/conversations")
    var helpRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        helpRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/" + String(user.uid) + "/help-wanted")
        
        println(helpRef)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        conversationsRef.queryOrderedByKey().queryStartingAtValue(self.user.uid).queryEndingAtValue(self.user.uid)
        
        conversationsRef.observeEventType(.Value, withBlock: { snapshot in
//            let sender = snapshot.value["sender"] as? String
            println(snapshot.value)
            }, withCancelBlock: { error in
                println(error.description)
        })
        
        helpRef.observeEventType(.Value, withBlock: { snapshot in
            //            let sender = snapshot.value["sender"] as? String
            self.buyer = snapshot.value as? String
            self.sendLocalNotificationWithMessage("Someone needs help with buying a bicycle")
            }, withCancelBlock: { error in
                println(error.description)
        })
        
        helpRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            println("hey")
            self.buyer = snapshot.value as? String
            self.sendLocalNotificationWithMessage("Someone needs help with buying a bicycle")
            }, withCancelBlock: { error in
                println(error.description)
        })
    }

    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
       
        let geofireRef = Firebase(url: "https://craigslist-vthacks.firebaseio.com/experts")
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude) 
        geoFire.setLocation(location!, forKey: self.user.uid)
    
    }
    
    func application(application: UIApplication!, didReceiveLocalNotification notification: UILocalNotification!) {
        let alertController = UIAlertController(title: "", message: "Help Wanted in your Area!", preferredStyle: .Alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .Default) { (action) in
            self.helpRef.childByAppendingPath(self.buyer).removeValue()
            var conversation = ["expert_id": self.user.uid, "user_id": self.buyer]
            self.conversationsRef.setValue(conversation)
        }
        let declineAction = UIAlertAction(title: "Decline", style: .Cancel) { (action) in
            // ...
        }
        
        alertController.addAction(acceptAction)
        alertController.addAction(declineAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }


}
