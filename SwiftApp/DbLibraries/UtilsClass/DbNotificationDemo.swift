//
//  DbNotificationDemo.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/20/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation


class DbNotificationDemo: DbEventProtocol {
        
    var eventID: DbEventRegisterID = 0
    
    func startEvent(_ notification: Notification) -> Void {
        
        if notification.name == NSNotification.Name.UIApplicationDidEnterBackground {
            print("DbNotificationDemo : ==> UIApplicationDidEnterBackground")
        } else if notification.name == NSNotification.Name.UIApplicationDidBecomeActive {
            print("DbNotificationDemo : ==> UIApplicationDidBecomeActive")
        }
        
    }
    
    func cancelEvent() -> Void {
        print("DbNotificationDemo : ==> cancelEvent")
    }
    
    func eventRunBackgroundMode() -> [String] {
        return [Notification.Name.UIApplicationDidEnterBackground.rawValue,
                Notification.Name.UIApplicationDidBecomeActive.rawValue]
    }
    
//    func eventPriority() -> Int {
//        return 1
//    }
//
//    func eventGroup() -> String {
//        return "USER"
//    }
    

}

