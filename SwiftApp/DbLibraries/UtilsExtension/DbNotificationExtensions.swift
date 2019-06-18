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
    static let MyViewControllerWillDisappear = Notification.Name(rawValue: "MyViewControllerWillDisappear")
    static let MyViewControllerDidDisappear = Notification.Name(rawValue: "MyViewControllerDidDisappear")
    
    // -- The application is ready to using --
    static let MyApplicationIsReady = Notification.Name(rawValue: "MyApplicationIsReady")
}

extension Notification {
    static func remove(_ sender: AnyObject) {
        NotificationCenter.default.removeObserver(sender)
    }
    
//    name aName: NSNotification.Name
    
    static func remove(_ sender: AnyObject, name aName: Notification.Name) {
        NotificationCenter.default.removeObserver(sender, name: aName, object: nil)
    }
    
    static func post(_ name: Notification.Name, object: AnyObject) {
        NotificationCenter.default.post(name: name, object: object, userInfo: nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: nil)
    }
    
    static func post(_ name: Notification.Name, object: AnyObject, userInfo: [AnyHashable:Any]) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
    }
    
    static func add(_ name: Notification.Name, observer: AnyObject, selector: Selector, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
//        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
}
