//
//  DbConstant.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/14/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation


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
    
    static func screenWidth() -> Float {
        return Float(UIScreen.main.bounds.size.width)
    }
    
    static func screenHeight() -> Float {
        return Float(UIScreen.main.bounds.size.height)
    }
    
    
}
