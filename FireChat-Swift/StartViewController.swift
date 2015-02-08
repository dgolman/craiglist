//
//  StartViewController.swift
//  FireChat-Swift
//
//  Created by Daniel Golman on 2/7/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginAsBuyerPressed(sender: UIButton) {
        let ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
        ref.unauth()
        self.performSegueWithIdentifier("BUYERLOGIN", sender: nil)
        
    }
    
    @IBAction func loginAsExpertPressed(sender: UIButton) {
        let ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
        ref.unauth()
        self.performSegueWithIdentifier("LOGIN", sender: nil)

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
