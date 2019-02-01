//
//  DbTopAlertController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Su dung duoc nhung touchOut bi loi khong animation duoc

import Foundation
import UIKit

public class DbTopAlertController: UIAlertController {
    
    /// The UIWindow that will be at the top of the window hierarchy. The DbTopAlertController instance is presented on the rootViewController of this window.
    private lazy var alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = DbTopClearViewController()
        window.backgroundColor = UIColor.clear
        window.windowLevel = UIWindowLevelAlert
        return window
    }()
    
    /**
     Present the DbTopAlertController on top of the visible UIViewController.
     
     - parameter flag:       Pass true to animate the presentation; otherwise, pass false. The presentation is animated by default.
     - parameter completion: The closure to execute after the presentation finishes.
     */
    
    public func show(animated flag: Bool, completion: (() -> Void)? = nil)
    {
        if let rootViewController = alertWindow.rootViewController {
            // -- Check show call again --
//            if (rootViewController.presentedViewController as? UIAlertController) != nil {
//                // -- Current UIAlertController displayed --
//                return
//            }
            self.alertWindow.isHidden = false
            alertWindow.makeKeyAndVisible()            
            //rootViewController.present(self, animated: flag, completion: completion)
            rootViewController.present(self, animated: flag) {
                if let ousideView = self.view.superview?.subviews.first {
                    ousideView.isUserInteractionEnabled = true
                    ousideView.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(self.touchOut)))
                }
            }
        }
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil)
    {
        super.dismiss(animated: flag, completion: nil)
        
        // -- Hide window --
        if self.alertWindow.isKeyWindow {
            self.alertWindow.resignFirstResponder()
        }
        self.alertWindow.isHidden = true
        
        // -- Run completion --
        completion?()
    }
    
    @objc public func touchOut()
    {
        self.dismiss(animated: true)
    }
    
    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================
    
    @discardableResult
    open class func alert(_ title: String) -> DbTopAlertController {
        return alert(title, message: "")
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String) -> DbTopAlertController {
        return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
            // Do nothing
        })
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> DbTopAlertController {
        let alert = DbTopAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        alert.show(animated: true)
        return alert
    }
    
    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> DbTopAlertController{
        let alert = DbTopAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        alert.show(animated: true)
        return alert
    }
    
    // -- DucBui 25/01/2018 : Add new --
    @discardableResult
    open class func alert(_ title: String, message: String, buttons:[UIAlertAction], tapBlock:((UIAlertAction,Int) -> Void)?) -> DbTopAlertController{
        let alert = DbTopAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        alert.show(animated: true)
        return alert
    }
    // -- --------------------------- --
    
    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> DbTopAlertController {
        let alert = DbTopAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        alert.show(animated: true)
        return alert
    }
    
    @discardableResult
    open class func actionSheet(_ title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> DbTopAlertController {
        let alert = DbTopAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        alert.show(animated: true)
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



// In the case of view controller-based status bar style, make sure we use the same style for our view controller
private class DbTopClearViewController: UIViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}
