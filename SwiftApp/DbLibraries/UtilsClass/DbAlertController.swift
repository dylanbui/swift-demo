//
//  DbAlertController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/25/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Copy on : https://github.com/thellimist/EZAlertController
//  Hacking UIAlertController in Swift. : https://iosdevcenters.blogspot.com/2016/05/hacking-uialertcontroller-in-swift.html

/* Example:
 
 => One Button Alert
 
 DbAlertController.alert("Title")
 DbAlertController.alert("Title", message: "Message")
 DbAlertController.alert("Title", message: "Message", acceptMessage: "OK") { () -> () in
    print("cliked OK")
 }
 
 => Multiple Button Alerts
 
 DbAlertController.alert("Title", message: "Message", buttons: ["First", "Second"]) { (alertAction, position) -> Void in
    if position == 0 {
        print("First button clicked")
    } else if position == 1 {
        print("Second button clicked")
    }
 }
 
 => Action Sheet
 
 // With individual UIAlertAction objects
 let firstButtonAction = UIAlertAction(title: "First Button", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    print("First Button pressed")
 })
 let secondButtonAction = UIAlertAction(title: "Second Button", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    print("Second Button pressed")
 })
 
 DbAlertController.actionSheet("Title", message: "message", actions: [firstButtonAction, secondButtonAction])
 
 // With all actions in single closure
 DbAlertController.actionSheet("Title", message: "Message", buttons: ["First", "Second"]) { (alertAction, position) -> Void in
    if position == 0 {
        print("First button clicked")
    } else if position == 1 {
        print("Second button clicked")
    }
 }
 
 => Customizable
 
 let alertController = DbAlertController.alert("Title") // Returns UIAlertController
 alertController.setValue(attributedTitle, forKey: "attributedTitle")
 alertController.setValue(attributedMessage, forKey: "attributedMessage")
 alertController.view.tintColor =  self.view.tintColor
 
 */

import Foundation
import UIKit

@objc open class DbAlertController : NSObject {
    
    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================
    
    class var instance : DbAlertController {
        struct Static {
            static let inst : DbAlertController = DbAlertController ()
        }
        return Static.inst
    }
    
    //==========================================================================================================
    // MARK: - Private Functions
    //==========================================================================================================
    
    fileprivate func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("DbAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    
    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================
    
    @discardableResult
    open class func alert(_ title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
            // Do nothing
        })
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    // -- DucBui 25/01/2018 : Add new --
    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[UIAlertAction], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    // -- --------------------------- --
    
    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
}


private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
    
    // -- DucBui 25/01/2018 : Add new --
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttons:[UIAlertAction], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        for buttonAction in buttons {
            self.addAction(buttonAction)
        }
    }
    // -- --------------------------- --
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertActionStyle, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}
