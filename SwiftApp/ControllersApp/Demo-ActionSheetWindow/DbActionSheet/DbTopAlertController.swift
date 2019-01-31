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
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = DbTopClearViewController()
        window.backgroundColor = UIColor.clearColor()
        window.windowLevel = UIWindowLevelAlert
        return window
    }()
    
    /**
     Present the DbTopAlertController on top of the visible UIViewController.
     
     - parameter flag:       Pass true to animate the presentation; otherwise, pass false. The presentation is animated by default.
     - parameter completion: The closure to execute after the presentation finishes.
     */
    public func show(animated flag: Bool = true, completion: (() -> Void)? = nil)
    {
        if let rootViewController = alertWindow.rootViewController {
            alertWindow.makeKeyAndVisible()
            
            rootViewController.presentViewController(self, animated: flag, completion: completion)
        }
    }
    
}

// In the case of view controller-based status bar style, make sure we use the same style for our view controller
private class DbTopClearViewController: UIViewController
{
    private override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIApplication.sharedApplication().statusBarStyle
    }
    
    private override func prefersStatusBarHidden() -> Bool
    {
        return UIApplication.sharedApplication().statusBarHidden
    }
}
