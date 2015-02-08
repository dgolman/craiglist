//
//  ListingsTableViewController.swift
//  FireChat-Swift
//
//  Created by Daniel Golman on 2/7/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class ListingsTableViewController: UITableViewController {
    
    var listings = [JSON]()
    var link: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = HTTPTask()
        request.GET("http://bikescraper.herokuapp.com/scrape", parameters: nil, success: {(response: HTTPResponse) in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if let data = response.responseObject as? NSData {
                    let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    let result = JSON(json)
                    self.listings = result.array!
                    self.tableView.reloadData()
                }
                return
            }
            
            },failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
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
        return self.listings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = self.listings[indexPath.row]["title"].string
        cell.detailTextLabel?.text = self.listings[indexPath.row]["cost"].string
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
        accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
            self.link = self.listings[indexPath.row]["link"].string
            self.performSegueWithIdentifier("LISTING", sender: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.link = self.listings[indexPath.row]["link"].string
        self.performSegueWithIdentifier("LISTING", sender: nil)
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
        var listingVc = segue.destinationViewController as ListingViewController
        listingVc.link = self.link
    }

}
