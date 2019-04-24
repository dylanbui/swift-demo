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
        
        if notification.name == .UIApplicationDidEnterBackground {
            print("DbNotificationDemo : ==> UIApplicationDidEnterBackground")
        } else if notification.name == .UIApplicationDidBecomeActive {
            print("DbNotificationDemo : ==> UIApplicationDidBecomeActive")
        }
        
    }
    
    func cancelEvent() -> Void {
        print("DbNotificationDemo : ==> cancelEvent")
    }
    
    func eventRunBackgroundMode() -> [Notification.Name] {
        return [.UIApplicationDidEnterBackground,
                .UIApplicationDidBecomeActive]
    }
    
//    func eventPriority() -> Int {
//        return 1
//    }
//
//    func eventGroup() -> String {
//        return "USER"
//    }
    

}

