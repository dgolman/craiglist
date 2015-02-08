//
//  LoginViewController.swift
//  FireChat-Swift
//
//  Created by David on 8/15/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import Foundation

class BuyerLoginViewController : UIViewController {
    
    @IBOutlet var btLogin: UIButton!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var ref: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com")
        if ref.authData != nil {
            self.performSegueWithIdentifier("LISTINGS", sender: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Login"
    }
    
    @IBAction func login(sender: UIButton) {
        var username: String = usernameField.text
        var password: String = passwordField.text
        self.authAccount(username, password: password);
    }
    
    
    func authAccount(email: String, password: String) {
        ref.authUser(email, password: password,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    // an error occurred while attempting login
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .UserDoesNotExist:
                            self.ref.createUser(email, password: password,
                                withCompletionBlock: { error in
                                    if error != nil {
                                        println(error)
                                    } else {
                                        self.authAccount(email, password: password)
                                    }
                            })
                            break
                        case .InvalidEmail:
                            // Handle invalid email
                            break
                        case .InvalidPassword:
                            // Hand invalid password
                            break
                        default:
                            break
                        }
                        println(error)
                    }
                } else {
                    self.performSegueWithIdentifier("LISTINGS", sender: nil)
                }
        })
    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        var listingsVc = segue.destinationViewController as ListingsTableViewController
//        if let authData = sender as? FAuthData {
//            conversationsVc.user = authData
//        }
//    }
}