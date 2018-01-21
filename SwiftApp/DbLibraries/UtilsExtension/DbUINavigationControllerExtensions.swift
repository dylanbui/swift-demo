//
//  DbUINavigationControllerExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/15/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
    
// MARK: - Methods
public extension UINavigationController {
    
    public func db_getCurrentViewController() -> UIViewController? {
        return viewControllers.last
    }
    
    public func db_replaceCurrentViewController(_ viewController: UIViewController, animated: Bool) {
        var editableViewControllers = viewControllers
        editableViewControllers.removeLast()
        editableViewControllers.append(viewController)
        setViewControllers(editableViewControllers, animated: animated)
    }
    
    public func db_pushOrReplaceToFirstViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 1 {
            db_replaceCurrentViewController(viewController, animated: animated)
        } else {
            pushViewController(viewController, animated: animated)
        }
    }
    
    public func db_popToFirstViewControllerWithAnimated(_ animated: Bool) {
        if viewControllers.count > 1 {
            popToViewController(viewControllers[1], animated: animated)
        }
    }
    
    public func db_pushArrayViewControllerToFirstViewController(_ arrViewController: [UIViewController], animated: Bool) {
        var editableViewControllers = [UIViewController]()
        editableViewControllers.append(viewControllers[0])
        editableViewControllers.append(contentsOf: arrViewController)
        setViewControllers(editableViewControllers, animated: animated)
    }
    
    /// SwifterSwift: Pop ViewController with completion handler.
    ///
    /// - Parameter completion: optional completion handler (default is nil).
    public func db_popViewController(_ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    public func db_pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func db_makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
    
}

