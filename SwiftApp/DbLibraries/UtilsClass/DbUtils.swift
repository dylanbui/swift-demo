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
    
    class func callPhoneNumber(phonenumber: String, completionHandler completion: @escaping ((_ success: Bool) -> Void)) {
        if phonenumber.db_isPhoneNumber == false {
            completion(false)
            return
        }
        var url: URL? = nil
        let phoneUrl: URL = URL(string: "telprompt://" + phonenumber)!
        let phoneFallbackUrl: URL = URL(string: "tel://" + phonenumber)!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(phoneUrl) {
            url = phoneUrl
        } else if application.canOpenURL(phoneFallbackUrl) {
            url = phoneFallbackUrl
        } else {
            completion(false)
            return
        }
        
        if #available(iOS 10.0, *) {
            application.open(url!, options: [:]) { (isSuccess) in
                completion(isSuccess)
            }
        } else {
            // Fallback on earlier versions
            completion(application.openURL(url!))
        }
    }
    
    class func openUrl(_ link: String, completionHandler completion: ((_ success: Bool) -> Void)?)
    {
        guard let url = URL.init(string: link) else {
            completion?(false)
            return
        }
        
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            application.open(url, options: [:]) { (isSuccess) in
                completion?(isSuccess)
            }
        } else {
            // Fallback on earlier versions
            completion?(application.openURL(url))
        }
    }

    
    // MARK: - Popup Notification
    // MARK: -
    
    static func showErrorNetwork() -> Void {
        let warning = MessageView.viewFromNib(layout: .cardView)
        //warning.configureTheme(.warning)
        warning.configureTheme(backgroundColor: UIColor.blue, foregroundColor: .white)
        warning.configureDropShadow()
        
        //let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        //warning.configureContent(title: "Warning", body: "Network don't connected.", iconText: iconText)
        warning.configureContent(title: "Thông báo", body: "Vui lòng kiểm tra lại kết nối mạng.", iconImage: UIImage(named: "ic_warning_white")!)
        warning.button?.isHidden = true
        let warningConfig = SwiftMessages.defaultConfig
        // warningConfig.preferredStatusBarStyle
        // warningConfig.preferredStatusBarStyle = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)

    }
    
//    static func showPropzyFloatingMessage(title: String, msg: String) -> Void {
//        let warning = MessageView.viewFromNib(layout: .cardView)
//        //warning.configureTheme(.warning)
//        warning.configureTheme(backgroundColor: .PROPZY_OGRANGE, foregroundColor: .white)
//        warning.configureDropShadow()
//
//        warning.configureContent(title: title, body: msg, iconImage: UIImage(named: "ic_warning_white")!)
//        warning.button?.isHidden = true
//        var warningConfig = SwiftMessages.defaultConfig
//        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
//        SwiftMessages.show(config: warningConfig, view: warning)
//    }
    
//    static func showFloatingMessage(title: String, msg: String) -> Void {
//        let warning = MessageView.viewFromNib(layout: .cardView)
//        //warning.configureTheme(.warning)
//        // warning.configureTheme(backgroundColor: .PROPZY_OGRANGE, foregroundColor: .white)
//        warning.configureDropShadow()
//
//        // https://emojipedia.org/apple/
//        // let iconText = ["🤔", "😳", "🙄", "😶", "👨🏽‍💻"].sm_random()!
//        warning.configureContent(title: title, body: msg, iconText: "🤔")
//        // warning.configureContent(title: "Thông báo", body: "Vui lòng kiểm tra lại kết nối mạng.", iconImage: UIImage(named: "ic_warning_white")!)
//
//        warning.button?.isHidden = true
//        var warningConfig = SwiftMessages.defaultConfig
//        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
//        SwiftMessages.show(config: warningConfig, view: warning)
//    }
    
    static func showStatusBarMessage(msg: String) -> Void {
        let warning = MessageView.viewFromNib(layout: .statusLine)
        // warning.configureTheme(.warning)
        warning.configureTheme(backgroundColor: UIColor.blue, foregroundColor: .white)
        warning.configureDropShadow()

        warning.configureContent(body: msg)
        
        // warning.button?.isHidden = true
        let warningConfig = SwiftMessages.defaultConfig
        // warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
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
    static func getDaysBetween(fromDate: Date = Date(), toDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: fromDate)
        let date2 = calendar.startOfDay(for: toDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
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

    // MARK: - NSLayoutConstraint
    // MARK: -
    
    static func getNSLayoutConstraint(_ layoutAttribute: NSLayoutAttribute, ofView view: UIView) -> NSLayoutConstraint?
    {
        var returnConstraint: NSLayoutConstraint? = nil
        for constraint: NSLayoutConstraint in view.constraints {
            if constraint.firstAttribute == layoutAttribute {
                returnConstraint = constraint
                break
            }
        }
        return returnConstraint
    }
    
    static func safeArea() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets ?? UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    static func safeAreaBottomPadding() -> CGFloat! {
        var bottomPadding: CGFloat! = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding
        }
        return 0
    }
    
    static func safeAreaTopPadding() -> CGFloat! {
        var topPadding: CGFloat! = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top
            return topPadding
        }
        return 0
    }
    
    static func safeAreaLeftPadding() -> CGFloat! {
        var leftPadding: CGFloat! = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            leftPadding = window?.safeAreaInsets.left
            return leftPadding
        }
        return 0
    }
    
    static func safeAreaRightPadding() -> CGFloat! {
        var rightPadding: CGFloat! = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            rightPadding = window?.safeAreaInsets.right
            return rightPadding
        }
        return 0
    }
    
}
