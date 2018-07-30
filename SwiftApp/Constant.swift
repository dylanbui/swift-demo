//
//  Constant.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/24/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DE_s: UIControl {
    
}


let APPLE_PUSH_NOTIFICATION_REQUEST         = true // 0 : no, 1 : yes

let CONFIGURATION_DEBUG                     = true // 0 : hide, 1 : show

let IS_SIMULATOR                            = TARGET_OS_SIMULATOR

let FORMAT_POPULATER_NAME                   = "yyyy_MM_dd_HH_mm_ss"
let FULL_FORMAT_DATE                        = "yyyy-MM-dd HH:mm:ss"
let SQLITE_FORMAT_DATE                      = "%Y-%m-%d %H:%M:%S"

let VN_FORMAT_DATE_DOUBLE                   = "dd/MM/YYYY" // 08/08/2017
let VN_FORMAT_DATE_SINGLE                   = "d/M/Y" // 8/8/17
let VN_FORMAT_DATE_FULL                     = "d/M/Y HH:mm:ss"

let FORMAT_TIME_FULL                        = "HH:mm:ss"

/***************** Simple Callback Delegate ******************/

// -- Xu ly tra ve cua cac UIView action --
typealias HandleControlAction = (AnyObject, Int, [String: AnyObject]?, Error?)

protocol ICallbackParentDelegate {
    func onCallback(from obj: AnyObject, callerId: Int, params: [String: AnyObject]?, error: Error?);
}

let ENV_DEV_APP = 1 // Develop model
//let ENV_TEST_APP = 2 // Test model
//let ENV_RES_APP = 3 // Production model

//#if ENV_DEV_APP // Develop model
//
//    let API_BASE_URL                = "http://124.158.14.28:8080/pama/api" // Develop Server
//    let UPLOAD_PHOTO_BASE_URL       = "http://124.158.14.28:8080/pama/api" // Develop Server
//
//#endif
//
//#if ENV_TEST_APP // Test model
//
//    let API_BASE_URL                = "http://124.158.14.28:8080/pama/api" // Develop Server
//    let UPLOAD_PHOTO_BASE_URL       = "http://124.158.14.28:8080/pama/api" // Develop Server
//
//#endif
//
//#if ENV_RES_APP // Test model
//
//    let API_BASE_URL                = "http://124.158.14.28:8080/pama/api" // Develop Server
//    let UPLOAD_PHOTO_BASE_URL       = "http://124.158.14.28:8080/pama/api" // Develop Server
//
//#endif

extension UIFont {

    static func fOpenSans(size: Float) -> UIFont {
        return UIFont(name: "OpenSans", size: CGFloat(size))!
        // return UIFont(name: "OpenSans", size: CGFloat(size))
    }

}

class MacroExx {

    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================
    
    class var instance : MacroExx {
        struct Static {
            static let inst : MacroExx = MacroExx()
        }
        return Static.inst
    }
    
    
    open func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    
}

class Macro_Ex
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

    static func screenWidth() -> Float {
        return Float(UIScreen.main.bounds.size.width)
    }
    
    static func screenHeight() -> Float {
        return Float(UIScreen.main.bounds.size.height)
    }

    
}

// -- Example enum --

// Mapping to Integer
enum Movement: Int {
    case Left = 0
    case Right = 1
    case Top = 2
    case Bottom = 3
}

// Mercury = 1, Venus = 2, ... Neptune = 8
enum Planet: Int {
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

// North = "North", ... West = "West"
enum CompassPoint: String {
    case North, South, East, West
}

// -- End enum --
