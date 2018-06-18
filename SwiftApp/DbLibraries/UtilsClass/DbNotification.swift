//
//  DbNotification.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/18/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbEventRegisterID = Int
typealias DbNotification = NSNotification

extension DbNotification {
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

@objc protocol DbEventProtocol {
    
    func startEvent(_ notification: DbNotification) -> Void
    func cancelEvent() -> Void;
    func eventRunBackgroundMode() -> [String]
    
    @objc optional func eventPriority() -> Int
    @objc optional func eventGroup() -> String
}

//let numberSequence: SequenceType<Int>

//typealias DbEventObject = Array<DbEventProtocol> // Dung
typealias DbEventObject = DbEventProtocol // Dung

//Since Swift 3:
//typealias CellDelegate = UIPickerViewDataSource & UIPickerViewDelegate
