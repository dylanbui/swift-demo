//
//  DbUINavigationControllerExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/15/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

public extension UIWindow {
    
    /// SwifterSwift: Switch current root view controller with a new view controller.
    ///
    /// - Parameters:
    ///   - viewController: new view controller.
    ///   - animated: set to true to animate view controller change (default is true).
    ///   - duration: animation duration in seconds (default is 0.5).
    ///   - options: animataion options (default is .transitionFlipFromRight).
    ///   - completion: optional completion handler called after view controller is changed.
    public func db_switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIViewAnimationOptions = .transitionFlipFromRight,
        _ completion: (() -> Void)? = nil) {
        
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
    
}


    
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
            // db_replaceCurrentViewController(viewController, animated: animated)
            db_pushArrayViewControllerToFirstViewController([viewController], animated: animated)
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
    
    // MARK: - Fade Animation
    // MARK: -
    
    public func db_pushFadeViewController(_ viewController: UIViewController, duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Push --
        self.pushViewController(viewController, animated: false)
    }
    
    public func db_popFadeViewController(_ duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Pop --
        self.popViewController(animated: false)
    }
    
    public func db_popFadeToRootViewController(_ duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Pop --
        self.popToRootViewController(animated: false)
    }
    
    public func db_popFadeToFirstViewController(_ duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Pop --
        self.db_popToFirstViewControllerWithAnimated(false)
    }
    
    public func db_replaceFadeCurrentViewController(withViewController controller: UIViewController, duration seconds: Double = 0.3) {
        self.db_replaceFadeCountViewControllers(1, withViewController: controller, duration: seconds)
    }
    
    public func db_replaceFadeCountViewControllers(_ nums: Int, withViewController controller: UIViewController, duration seconds: Double) {
        var controllers = self.viewControllers;
        
        var controllerIndex = controllers.count - nums
        if controllerIndex < 0 {
            controllerIndex = 0
        }
        
        controllers.insert(controller, at: controllerIndex)
        self.setViewControllers(controllers, animated: false)
        
        let transition = CATransition();
        transition.duration = seconds;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade;
        self.view.layer.add(transition, forKey: nil)
        
        self.popToViewController(controller, animated: false)
        
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

