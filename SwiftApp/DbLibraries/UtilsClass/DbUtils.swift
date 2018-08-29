//
//  DbUtils.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/14/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import SwiftMessages

class DbUtils: NSObject
{
    
    static func hi()
    {
        print("Say hiiii")
    }
    
//    static func getTopViewController() -> UIViewController? {
//        return UIApplication.shared.keyWindow?.rootViewController
//    }
    
    // DbUtils.dispatchToMainQueue {}
    static func dispatchToMainQueue(_ dispatch_block: @escaping () -> Void)
    {
        //dispatch_async(dispatch_get_main_queue(), dispatch_block);
        DispatchQueue.global().async {
            DispatchQueue.main.async(execute: dispatch_block)
            //            DispatchQueue.main.async {
            //                dispatch_block()
            //            }
        }
    }
    
    // DbUtils.dispatchToBgQueue {}
    static func dispatchToBgQueue(_ dispatch_block: @escaping () -> Void)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            dispatch_block()
        }
    }
    
    // DbUtils.performAfter(delay: 2) { print("task to be done" }
    static func performAfter(delay: TimeInterval, dispatch_block: @escaping () -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            dispatch_block()
        }
    }
    
    // MARK: - Popup Notification
    // MARK: -
    
    static func showErrorNetwork() -> Void {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        
        let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        warning.configureContent(title: "Warning", body: "Network don't connected.", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
    }
    
    // MARK: - Validate
    // MARK: -
    
    static func isEmail(_ str: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: str)
    }
    
    static func isPhoneNumber(_ str: String) -> Bool
    {
        let phoneRegex = "^((\\+)|(0))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: str)
    }
    
    static func trimText(_ str: String) -> String
    {
        return str.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    // MARK: - Datetime
    // MARK: -
    
    static func getCurrentDate(_ format: String) -> String
    {
        return DbUtils.stringFromDate(Date(), format: format)
    }
    
    static func stringFromTimeInterval(_ timeInterval: Double, format: String) -> String
    {
        let date = Date(timeIntervalSince1970: (timeInterval/1000.0))
        return DbUtils.stringFromDate(date, format: format)
    }
    
    static func stringFromDate(_ date: Date, format: String) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func convertStringToDate(_ date: String, format: String) -> Date
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter.date(from: date)!
    }
    
    static func totalSecondFromNowTo(_ endDate: String, format: String) -> Double
    {
        let date = DbUtils.convertStringToDate(endDate, format: format)
        return date.timeIntervalSinceNow
    }
    
    static func formatTimeFromSeconds(_ numberOfSeconds: Double) -> String
    {
        let seconds = Int(numberOfSeconds) % 60;
        let minutes = (Int(numberOfSeconds) / 60) % 60;
        let hours = Int(numberOfSeconds) / 3600;
        
        //we have >=1 hour => example : 3h:25m
        if hours > 0 {
            return String(format: "%d giờ %02d phút", hours, minutes)
        }
        
        //we have 0 hours and >=1 minutes => example : 3m:25s
        if minutes > 0 {
            return String(format: "%d phút %02d giây", minutes, seconds)
        }
        
        return String(format: "%d giây", seconds)
    }
    
    // MARK: - Color
    // MARK: -
    
    static func colorWith(HexString: String) -> UIColor
    {
        return DbUtils.colorWith(HexString: HexString, alpha: 1.0)
    }
    
    static func colorWith(HexString: String, alpha: Float) -> UIColor
    {
        var cString:String = HexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return DbUtils.colorWith(HexValue: rgbValue, alpha: alpha)
    }
    
    static func colorWith(HexValue: UInt32, alpha: Float) -> UIColor
    {
        return UIColor(
            red: CGFloat((HexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((HexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(HexValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}
