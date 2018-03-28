//
//  DbUIViewControllerExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/9/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

let kYMStandardOptionsTableName: String = "YMStandardOptionsTableName"
let kYMStandardDefaultsTableName: String = "YMStandardDefaultsTableName"

// MARK: - Methods
public extension UIViewController {
    
    func ym_registerOptions(_ options: [String: AnyObject], defaults: [String: AnyObject]) -> Void {
        objc_setAssociatedObject(self, kYMStandardOptionsTableName, options, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, kYMStandardDefaultsTableName, defaults, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    func ym_optionOrDefaultForKey(_ optionKey: String) -> AnyObject? {
        
        let options: [String: AnyObject] = objc_getAssociatedObject(self, kYMStandardOptionsTableName) as! [String : AnyObject];
        let defaults: [String: AnyObject] = objc_getAssociatedObject(self, kYMStandardDefaultsTableName) as! [String : AnyObject];
        // NSAssert(defaults, @"Defaults must have been set when accessing options.");
        if let obj: AnyObject = options[optionKey] {
            return obj
        }
        return defaults[optionKey]
        //return options[optionKey] ?: defaults[optionKey];
    }
    
}

// MARK: - Methods
public extension UIView {
    
    func ym_containingViewController() -> UIViewController? {
        let target: UIView
        if self.superview != nil {
            target = self.superview!
        } else {
            target = self
        }
        return target.ym_traverseResponderChainForUIViewController() as? UIViewController
    }
    
    func ym_traverseResponderChainForUIViewController() -> AnyObject? {
        let nextResponder = self.next
        let isViewController: Bool = (nextResponder?.isKind(of: UIViewController.self))!
        let isTabBarController: Bool = (nextResponder?.isKind(of: UITabBarController.self))!
        
        if isViewController && !isTabBarController {
            return nextResponder
        } else if isTabBarController {
            let tabBarController: UITabBarController? = nextResponder as? UITabBarController;
            return  tabBarController?.selectedViewController;
        } else if let view:UIView =  nextResponder as? UIView  {
            return view.ym_traverseResponderChainForUIViewController()
            // return [nextResponder traverseResponderChainForUIViewController];
        }
        return nil
    }

}

let kSemiModalDidShowNotification: String = "kSemiModalDidShowNotification"
let kSemiModalDidHideNotification: String = "kSemiModalDidHideNotification"
let kSemiModalWasResizedNotification: String = "kSemiModalWasResizedNotification"

enum KNSemiModalOption : String {
    case traverseParentHierarchy = "traverseParentHierarchy"
    case pushParentBack = "pushParentBack"
    case animationDuration = "animationDuration"
    case parentAlpha = "parentAlpha"
    case parentScale = "parentScale"
    case shadowOpacity = "shadowOpacity"
    case transitionStyle = "transitionStyle"
    case position = "position"
    case disableCancel = "disableCancel"
    case backgroundView = "backgroundView"
}

typealias KNTransitionCompletionBlock = () -> Void



// MARK: - Methods
public extension UIViewController {
    
    private func kn_parentTargetViewController() -> UIViewController {
        var target: UIViewController = self
        while target.parent != nil {
            target = target.parent!
        }
        if target.ym_optionOrDefaultForKey(KNSemiModalOption.traverseParentHierarchy.rawValue) as! Bool {
            return target
        }
        return self
    }
 
    func parentTarget () -> UIView {
        return self.kn_parentTargetViewController().view
    }
    
    func kn_targetToStoreValues() -> UIViewController {
        var target: UIViewController = self
        while target.parent != nil {
            target = target.parent!
        }
        return target
    }
    
    // MARK: Options and defaults
    func kn_registerDefaultsAndOptions(_ options: [String: AnyObject]) -> Void {
        self.kn_targetToStoreValues().ym_registerOptions(options, defaults: [
            KNSemiModalOption.traverseParentHierarchy.rawValue : true as AnyObject
            ])
    }
    
}
