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

enum DbNotify : String {
    case ServerPushMessage = "ServerPushMessage"
    case ReachableNetwork = "ReachableNetwork"
    case VclDidLoad = "VclDidLoad"
    case VclWillAppear = "VclWillAppear"
    case VclDidAppear = "VclDidAppear"
    case VclWillDisAppear = "VclWillDisAppear"
    case VclDidDisAppear = "VclDidDisAppear"
}


protocol DbIReturnDelegate {
    func onReturn(params: [String:AnyObject], callerId: Int);
}

class Macro
{
    // MARK: -
    // MARK: -
    
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
    
    // MARK: -
    // MARK: -
    
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
    
    
}
