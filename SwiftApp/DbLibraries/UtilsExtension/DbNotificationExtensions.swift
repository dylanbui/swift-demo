//
//  DbNotificationExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/21/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let MyApplicationServerPushMessage = Notification.Name(rawValue: "MyApplicationServerPushMessage")
    static let MyApplicationReachableNetwork = Notification.Name(rawValue: "MyApplicationReachableNetwork")
    
    static let MyViewControllerDidLoad = Notification.Name(rawValue: "MyViewControllerDidLoad")
    static let MyViewControllerWillAppear = Notification.Name(rawValue: "MyViewControllerWillAppear")
    static let MyViewControllerDidAppear = Notification.Name(rawValue: "MyViewControllerDidAppear")
    static let MyViewControllerWillDisAppear = Notification.Name(rawValue: "MyViewControllerWillDisAppear")
    static let MyViewControllerDidDisAppear = Notification.Name(rawValue: "MyViewControllerDidDisAppear")
}

extension Notification {
    static func remove(_ sender: AnyObject) {
        NotificationCenter.default.removeObserver(sender)
    }
    
    static func remove(_ sender: AnyObject, name: String) {
        NotificationCenter.default.removeObserver(sender, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    static func post(_ name: String, object: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: nil)
    }
    
    static func post(_ name: String, object: AnyObject, userInfo: [AnyHashable:Any]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
    }
    
    static func add(_ name: String, observer: AnyObject, selector: Selector, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
}
