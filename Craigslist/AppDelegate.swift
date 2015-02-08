//
//  AppDelegate.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/13/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let notificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        let settings = UIUserNotificationSettings(forTypes: notificationType, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as UILocalNotification!
        if (notification != nil) {
            startConversation()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication!, didReceiveLocalNotification notification: UILocalNotification!) {
        
        var state: UIApplicationState  = application.applicationState
        if (state == UIApplicationState.Active) {
            startConversation()
        }
    }
    
    func startConversation() {
        let ref = Firebase(url:"https://craigslist-vthacks.firebaseio.com/")
        let helpRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/" + String(ref.authData.uid) + "/help-wanted")
        let conversationsRef = Firebase(url:"https://craigslist-vthacks.firebaseio.com/conversations")
        helpRef.queryLimitedToFirst(1)
        
        helpRef.observeEventType(.Value, withBlock: { snapshot in
            let alertController = UIAlertController(title: "", message: "Help Wanted in your Area!", preferredStyle: .Alert)
            
            let acceptAction = UIAlertAction(title: "Accept", style: .Default) { (action) in
                helpRef.removeValue()
                var conversation = ["id": (String(ref.authData.uid) + "_" + String(snapshot.value as NSString)), "expert_id": ref.authData.uid, "user_id": snapshot.value, "last_sent": ""]
                conversationsRef.childByAutoId().setValue(conversation)
            }
            
            let declineAction = UIAlertAction(title: "Decline", style: .Default) { (action) in
                
                
                
            }
            
            alertController.addAction(acceptAction)
            alertController.addAction(declineAction)
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            self.window?.rootViewController = UIViewController()
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }


}

