//
//  DbCatchNotification.swift
//  PropzySam
//
//  Created by Dylan Bui on 5/30/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

class DbCatchNotification: DbEventProtocol
{
    public var eventID: DbEventRegisterID = 0
    
    public static var userInfo: DictionaryType? = nil
    
    init() { }
    
    func startEvent(_ notification: Notification) -> Void
    {
        if notification.name != .MyApplicationIsReady {
            // print("- May la thang nao? tao khong bit, ra di")
            return
        }        
    }
    
    func eventRunBackgroundMode() -> [Notification.Name]
    {
        return [.MyApplicationIsReady]
    }
    
    func cancelEvent()
    {
        
    }
    
    // MARK: - Private function
    // MARK: -
    
}

