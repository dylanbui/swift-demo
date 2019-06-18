//
//  DbUINavigationControllerExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/15/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

// MARK: - Actions
public extension UIApplication
{
    fileprivate static let _sharedApplication = UIApplication.shared
    
    // -- Change color background status bar --
    /*
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
        return true
     }
     // Or
     override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
     }     
     */
    var db_statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    class func db_open(url: Foundation.URL) {
        if _sharedApplication.canOpenURL(url) {
            if #available(iOS 10, *) {
                _sharedApplication.open(url, options: [:], completionHandler: { (success) in })
            } else {
                _sharedApplication.openURL(url)
            }
        } else {
            print("Can not execute the given action.")
        }
    }
    
    class func db_open(urlPath: String) {
        if let url = URL(string: urlPath) {
            UIApplication.db_open(url: url)
        }
    }
    
    class func db_makePhone(to phoneNumber: String) {
        db_open(urlPath: "telprompt:\(phoneNumber)")
    }
    
    class func db_sendMessage(to phoneNumber: String) {
        db_open(urlPath: "sms:\(phoneNumber)")
    }
    
    class func db_email(to email: String) {
        db_open(urlPath: "mailto:\(email)")
    }
    
    class func db_clearIconBadge() {
        let badgeNumber = _sharedApplication.applicationIconBadgeNumber
        _sharedApplication.applicationIconBadgeNumber = 1
        _sharedApplication.applicationIconBadgeNumber = 0
        // _sharedApplication.cancelAllLocalNotifications()
        _sharedApplication.applicationIconBadgeNumber = badgeNumber
    }
    
    class func db_sendAction(_ action: Selector, fromSender sender: AnyObject?, forEvent event: UIEvent? = nil) -> Bool {
        // Get the target in the responder chain
        var target = sender
        
        while let _target = target , !_target.canPerformAction(action, withSender: sender) {
            target = _target.next
        }
        
        if let _target  = target {
            return UIApplication.shared.sendAction(action, to: _target, from: sender, for: event)
        }
        
        return false
    }
    
    static var db_appVersion: String {
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            return "\(appVersion)"
        } else {
            return ""
        }
    }
    
    static var db_build: String {
        if let buildVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) {
            return "\(buildVersion)"
        } else {
            return ""
        }
    }
    
    static var db_versionBuild: String {
        let version = UIApplication.db_appVersion
        let build = UIApplication.db_build
        
        var versionAndBuild = "v\(version)"
        
        if version != build {
            versionAndBuild = "v\(version)(\(build))"
        }
        
        return versionAndBuild
    }

    
    /// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
//    class func db_makeStatusBarDark() {
//        UIApplication.shared.statusBarStyle = .default
//    }
    
    /// Setting the statusBarStyle does nothing if your application is using the default UIViewController-based status bar system.
//    class func db_makeStatusBarLight() {
//        UIApplication.shared.statusBarStyle = .lightContent
//    }
}

// MARK: - UIWindow
// MARK: -

public extension UIWindow {
    
    /// SwifterSwift: Switch current root view controller with a new view controller.
    ///
    /// - Parameters:
    ///   - viewController: new view controller.
    ///   - animated: set to true to animate view controller change (default is true).
    ///   - duration: animation duration in seconds (default is 0.5).
    ///   - options: animataion options (default is .transitionFlipFromRight).
    ///   - completion: optional completion handler called after view controller is changed.
    func db_switchRootViewController(
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

public extension UIViewController {
    
    func db_backOrDismiss() {
        if presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController {
            // -- La modal nhung lai co navigation --
            if let nav = navigationController {
                if nav.viewControllers.count > 1 {
                    navigationController?.popViewController(animated: true)
                    return
                }
            }
            dismiss(animated: true) { }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    func db_backToPrevious(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: animated)
        }
    }
    
    func db_backToRoot(animated: Bool = true) {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func db_dismiss(completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: completion)
    }
    
    func db_dismissToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        var presentedViewController = self
        while let presentingViewController = presentedViewController.presentingViewController {
            presentedViewController = presentingViewController
        }
        presentedViewController.dismiss(animated: animated, completion: completion)
    }
    
    func db_addChild(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}

    
// MARK: - Methods
public extension UINavigationController {
    
    func db_getCurrentViewController() -> UIViewController? {
        return viewControllers.last
    }
    
    func db_replaceCurrentViewController(_ viewController: UIViewController, animated: Bool) {
        var editableViewControllers = viewControllers
        editableViewControllers.removeLast()
        editableViewControllers.append(viewController)
        setViewControllers(editableViewControllers, animated: animated)
    }
    
    func db_pushOrReplaceToFirstViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 1 {
            // db_replaceCurrentViewController(viewController, animated: animated)
            db_pushArrayViewControllerToFirstViewController([viewController], animated: animated)
        } else {
            pushViewController(viewController, animated: animated)
        }
    }
    
    func db_popToFirstViewControllerWithAnimated(_ animated: Bool) {
        if viewControllers.count > 1 {
            popToViewController(viewControllers[1], animated: animated)
        }
    }
    
    func db_pushArrayViewControllerToFirstViewController(_ arrViewController: [UIViewController], animated: Bool) {
        var editableViewControllers = [UIViewController]()
        editableViewControllers.append(viewControllers[0])
        editableViewControllers.append(contentsOf: arrViewController)
        setViewControllers(editableViewControllers, animated: animated)
    }
    
    // MARK: - Fade Animation
    // MARK: -
    
    func db_pushFadeViewController(_ viewController: UIViewController, duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Push --
        self.pushViewController(viewController, animated: false)
    }
    
    func db_popFadeViewController(_ duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Pop --
        self.popViewController(animated: false)
    }
    
    func db_popFadeToRootViewController(_ duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Pop --
        self.popToRootViewController(animated: false)
    }
    
    func db_popFadeToFirstViewController(_ duration: Double = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        // -- Pop --
        self.db_popToFirstViewControllerWithAnimated(false)
    }
    
    func db_replaceFadeCurrentViewController(withViewController controller: UIViewController, duration seconds: Double = 0.3) {
        self.db_replaceFadeCountViewControllers(1, withViewController: controller, duration: seconds)
    }
    
    func db_replaceFadeCountViewControllers(_ nums: Int, withViewController controller: UIViewController, duration seconds: Double) {
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
    func db_popViewController(_ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
    
    func db_popFadeViewController(_ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: false)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    func db_pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func db_makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
    
}

