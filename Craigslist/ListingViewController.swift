//
//  ListingViewController.swift
//  FireChat-Swift
//
//  Created by Daniel Golman on 2/7/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import CoreLocation

class ListingViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var link: String!
    var listing: JSON!
    var phone: String!
    var email: String!
    
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    
    @IBOutlet var make: UILabel!
    @IBOutlet var model: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var condition: UILabel!
    @IBOutlet var descript: UITextView!
    @IBOutlet var listingTitle: UILabel!
    @IBOutlet var listingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = HTTPTask()
        let params: Dictionary<String,AnyObject> = ["link": self.link]
        request.GET("http://bikescraper.herokuapp.com/scrape2", parameters: params, success: {(response: HTTPResponse) in
            dispatch_async(dispatch_get_main_queue()) {
                if let data = response.responseObject as? NSData {
                    let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    var listing = JSON(json)
                   self.listingImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: listing["image"].string!)!)!)
                    self.listingTitle.text = listing["title"].string
                    self.make.text = listing["make"].string
                    self.model.text = listing["model"].string
                    self.size.text = listing["size"].string
                    self.condition.text = listing["condition"].string
                    self.descript.text = listing["desc"].string
                    self.phone = listing["phone"].string
                    self.email = listing["email"].string
                    
                    if self.phone == "" {
                        self.callButton.enabled = false
                        self.callButton.title = ""
                    }
                    
                    if self.email == "" {
                        self.emailButton.enabled = false
                        self.emailButton.title = ""
                    }

                    
                }
                return
            }
            },failure: {(error: NSError, response: HTTPResponse?) in
                
        })
    }
    @IBAction func callButtonPressed(sender: UIButton) {
        
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func emailButtonPressed(sender: UIButton) {
        if let url = NSURL(string: "mailto:\(email)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func findExpert(sender: UIBarButtonItem) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        println("hey")
    }
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        manager.stopUpdatingLocation()
        println("hey")
        let geofireRef = Firebase(url: "https://craigslist-vthacks.firebaseio.com/experts")
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let center = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        
        var circleQuery = geoFire.queryAtLocation(center, withRadius: 0.6)
        
        let helpRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/simplelogin:3/help-wanted")
        let ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
        helpRef.setValue(ref.authData.uid)
        
//        var queryHandle = circleQuery.observeEventType(GFEventTypeKeyEntered, withBlock: { (key: String!, location: CLLocation!) in
//            let helpRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/" + key + "/help-wanted")
//            let ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
//            helpRef.setValue(ref.authData.uid)
//        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
