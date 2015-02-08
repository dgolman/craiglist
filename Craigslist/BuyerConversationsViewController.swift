//
//  ConversationsTableViewController.swift
//  FireChat-Swift
//
//  Created by Daniel Golman on 2/6/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class BuyerConversationsTableViewController: UITableViewController {
   
    var user: FAuthData!
    var id: String!
    var from: String!
    var conversations = [AnyObject]()
    
    let conversationsRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/conversations")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
        self.user = ref.authData
           
        conversationsRef.queryOrderedByKey().queryStartingAtValue(self.user.uid).queryEndingAtValue(self.user.uid)
        
        conversationsRef.observeEventType(.Value, withBlock: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FDataSnapshot {
                self.conversations.append(rest.value)
            }
            
            self.tableView.reloadData()
            }, withCancelBlock: { error in
                println(error.description)
        })
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
        return self.conversations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = self.conversations[indexPath.row]["expert_id"] as? String
        cell.detailTextLabel?.text = self.conversations[indexPath.row]["last_sent"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
        accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            self.id = self.conversations[indexPath.row]["id"] as? String
            self.from = self.user.uid
            self.performSegueWithIdentifier("MESSAGES", sender: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.id = self.conversations[indexPath.row]["id"] as? String
        self.from = self.user.uid
        self.performSegueWithIdentifier("MESSAGES", sender: nil)
    }
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var messagesVc = segue.destinationViewController as MessagesViewController
        messagesVc.id = self.id
        messagesVc.from = self.from
    }

}
