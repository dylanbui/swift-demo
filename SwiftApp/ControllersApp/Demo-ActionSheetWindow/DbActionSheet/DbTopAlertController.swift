//
//  DbTopAlertController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

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
            self.alertWindow.isHidden = false
            alertWindow.makeKeyAndVisible()            
            rootViewController.present(self, animated: flag, completion: completion)
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
    
}

// In the case of view controller-based status bar style, make sure we use the same style for our view controller
private class DbTopClearViewController: UIViewController
{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
        // return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}
