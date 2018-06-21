//
//  AppDelegate.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: DbAppDelegate {



    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        // https://github.com/rebeloper/SwiftyPlistManager
        // https://rebeloper.com/read-write-plist-file-swift/
        SwiftyPlistManager.shared.start(plistNames: ["DemoData"], logging: true)
        
        //self.performSelector(inBackground: #selector(initGolbalParams), with: nil)
        self.initGolbalParams()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func initGolbalParams() -> Void
    {
        SwiftyPlistManager.shared.removeValueKeyPair(for: "DemoJob", fromPlistWithName: "DemoData") { (err) in
            if err == nil {
                print("Clear all data.")
            }
        }
        
        let item_1:[String:String] = ["title": "Cong viec thu 1", "name": "Hoang Thai Thanh", "datetime": "1234567898"]
        let item_2:[String:String] = ["title": "Cong viec thu 2", "name": "Hoang Thai Thanh", "datetime": "1234567898"]
        let item_3:[String:String] = ["title": "Cong viec thu 3", "name": "Hoang Thai Thanh", "datetime": "1234567898"]
        let item_4:[String:String] = ["title": "Cong viec thu 4", "name": "Hoang Thai Thanh", "datetime": "1234567898"]
        let item_5:[String:String] = ["title": "Cong viec thu 5", "name": "Hoang Thai Thanh", "datetime": "1234567898"]
        
        let arr:[Any] = [item_1, item_2, item_3, item_4, item_5]
        
        SwiftyPlistManager.shared.addNew(arr, key: "DemoJob", toPlistWithName: "DemoData") { (err) in
            if err == nil {
                print("Value successfully added into plist.")
            }
        }
    }

//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }


}

