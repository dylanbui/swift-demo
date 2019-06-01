//
//  DbConstant.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/14/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

///***************** Define Notification ******************/
//
//#define NOTIFY_SERVER_PUSH_MESSAGE             @"NOTIFY_SERVER_PUSH_MESSAGE"
//
//#define NOTIFY_REACHABLE_NETWORK               @"NOTIFY_REACHABLE_NETWORK"
//
//#define NOTIFY_VCL_DID_LOAD                    @"NOTIFY_VCL_DID_LOAD"
//#define NOTIFY_VCL_WILL_APPEAR                 @"NOTIFY_VCL_WILL_APPEAR"
//#define NOTIFY_VCL_DID_APPEAR                  @"NOTIFY_VCL_DID_APPEAR"
//#define NOTIFY_VCL_WILL_DISAPPEAR              @"NOTIFY_VCL_WILL_DISAPPEAR"
//#define NOTIFY_VCL_DID_DISAPPEAR               @"NOTIFY_VCL_DID_DISAPPEAR"

//public enum DbNotify : String {
//    case ServerPushMessage = "ServerPushMessage"
//    case ReachableNetwork = "ReachableNetwork"
//    case VclDidLoad = "VclDidLoad"
//    case VclWillAppear = "VclWillAppear"
//    case VclDidAppear = "VclDidAppear"
//    case VclWillDisAppear = "VclWillDisAppear"
//    case VclDidDisAppear = "VclDidDisAppear"
//}

public typealias DictionaryType = [String: Any]

// -- Xu ly tra ve cua cac UIView action DbHandleAction(owner, id, params, error) --
public typealias DbHandleAction = (Any, Int, DictionaryType?, Error?) -> Void

public protocol DbIReturnDelegate {
    func onReturn(Owner object: Any?, callerId: Int?, params: DictionaryType?, error: Error?) -> Void
}

// -- Create DbIReturnDelegate is a optional --
extension DbIReturnDelegate {
    func onReturn(Owner object: Any?, callerId: Int?, params: DictionaryType?, error: Error?) -> Void {
        
    }
}

// -- Default item for UIControl --

protocol DbItemProtocol {
    var dbItemId: Int { get }
    var dbItemTitle: String { get }
    
    var dbItemDesc: String? { get }
    var dbRawValue: Any? { get }
}

extension DbItemProtocol {
    var dbItemDesc: String? {
        get {
            return nil
        }
    }
    var dbRawValue: Any? {
        get {
            return nil
        }
    }
}

public class DbItem: DbItemProtocol, Equatable, CustomStringConvertible
{
    var dbItemId: Int
    var dbItemTitle: String
    var dbItemDesc: String?
    var dbRawValue: Any?
    
    // Extension CustomStringConvertible
    public var description: String {
        return "ItemId: \(dbItemId) - Desc: \(dbItemTitle)"
    }
    
    init()
    {
        self.dbItemId = 0
        self.dbItemTitle = ""
    }
    
    convenience init(id: Int, title: String, desc: String? = nil, raw: Any? = nil)
    {
        self.init()
        self.dbItemId = id
        self.dbItemTitle = title
        self.dbItemDesc = desc
        self.dbRawValue = raw
    }
}

public func ==(lhs: DbItem, rhs: DbItem) -> Bool {
    return lhs.dbItemId == rhs.dbItemId
}


//public enum db {
//    static func aaaa(name: String) {
//        print(name)
//    }
//
//    class Employee {
//
//        var short_ID:Int = 0
//        var short_NAME:String = ""
//
//        init(id: Int, name: String) {
//            self.short_NAME = name
//            self.short_ID = id
//        }
//    }
//
//}
//
//extension db {
//    static func bbbb(name: String) {
//        print(name)
//    }
//
//    class People {
//
//        var short_ID:Int = 0
//        var short_NAME:String = ""
//
//        init(id: Int, name: String) {
//            self.short_NAME = name
//            self.short_ID = id
//        }
//    }
//}

public enum Db { }

// MARK: - Device functions
// MARK: -

extension Db // => Device functions
{
    static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func systemVersionEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    static func systemVersionGreaterThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    static func systemVersionGreateThanOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    static func systemVersionLessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    static func systemVersionLessThanOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version,
                                                      options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
    
    static func isIpad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    
    static func isIphone() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
    }
    
    static func isRetina() -> Bool {
        return UIScreen.main.scale >= 2.0
    }
    
    static func screenWidth() -> Int {
        return Int(UIScreen.main.bounds.size.width)
    }
    
    static func screenHeight() -> Int {
        return Int(UIScreen.main.bounds.size.height)
    }
    
    static func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static func SCREEN_MAX_LENGTH() -> Int {
        return max(screenWidth(), screenHeight())
    }
    
    static func SCREEN_MIN_LENGTH() -> Int {
        return max(screenWidth(), screenHeight())
    }
    
    static func IS_IPHONE_5_OR_LESS() -> Bool {
        return (isIphone() && SCREEN_MAX_LENGTH() <= 568)
    }
    
    static func IS_IPHONE_6_6S_7_8() -> Bool {
        return (isIphone() && SCREEN_MAX_LENGTH() == 667)
    }
    
    static func IS_IPHONE_6P_6SP_7P_8P() -> Bool {
        return (isIphone() && SCREEN_MAX_LENGTH() == 736)
    }
    
    static func IS_IPHONE_X() -> Bool {
        return (isIphone() && SCREEN_MAX_LENGTH() == 812)
    }
    
    static func IS_IPHONE_XS() -> Bool {
        return (isIphone() && SCREEN_MAX_LENGTH() == 812)
    }
    
    static func IS_IPHONE_XS_MAX_XR() -> Bool {
        return (isIphone() && SCREEN_MAX_LENGTH() == 896)
    }
    
    static func rootViewController() -> UIViewController {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
}

// MARK: - Macro functions
// MARK: -

struct Employee {
    static var ID:Int = 0
    static var NAME:Int = 1
    
    var fields = [Int:String]()
    
    var short_ID:Int = 0
    var short_NAME:String = ""
    
    init(name: String, id: Int) {
        self.short_NAME = name
        self.short_ID = id
    }
    
    mutating func config(id:String, name:String) {
        fields[Employee.ID] = id
        fields[Employee.NAME] = name
    }
    
    func getField(index:Int) -> String {
        return fields[index]!
    }
}

func TestAddNotification(_ name: String) {
    print("TestAddNotification \(name)")
}




