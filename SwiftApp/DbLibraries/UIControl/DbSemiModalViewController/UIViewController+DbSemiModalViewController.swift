//
//  UIViewController+DbSemiModalViewController.swift
//  PropzySam
//
//  Created by Dylan Bui on 11/7/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Base : https://github.com/muyexi/SemiModalViewController

import Foundation
import UIKit

extension Notification.Name {
    static let dbSemiModalDidShow = Notification.Name("dbSemiModalDidShow")
    static let dbSemiModalDidHide = Notification.Name("dbSemiModalDidHide")
}

private var dbSemiModalViewController: Void?
private var dbSemiModalDismissBlock: Void?
private var dbSemiModalPresentingViewController: Void?

private let dbSemiModalOverlayTag = 100012
private let dbSemiModalScreenshotTag = 100022
private let dbSemiModalModalViewTag = 100032

public enum DbSemiModalOption: String {
    case traverseParentHierarchy
    case animationDurationIn
    case animationDurationOut
    case parentAlpha
    case shadowOpacity
    case contentYOffset
    case leftRightPadding
    case transitionStyle
    case disableCancel
    case backgroundView
}

public enum DbSemiModalTransitionStyle: String {
    case slideUp
    case slideDown
    case slideCenter
    case fadeInOutCenter
    case limitTopToCenter
}

fileprivate class DbClosureWrapper: NSObject, NSCopying {
    var closure: (() -> Void)?
    
    convenience init(closure: (() -> Void)?) {
        self.init()
        self.closure = closure
    }
    
    func copy(with zone: NSZone?) -> Any {
        let wrapper: DbClosureWrapper = DbClosureWrapper()
        
        wrapper.closure = self.closure
        
        return wrapper;
    }
    
}

private var DbCustomOptions: Void?

// MARK: - extension UIViewController : Options
// MARK: -

extension UIViewController {
    
    var db_defaultOptions: [DbSemiModalOption: Any] {
        return [
            .traverseParentHierarchy : true,
            .animationDurationIn     : 0.3, // No effect if transitionStyle is : slideUp, slideDown, slideCenter. Only for overlay
            .animationDurationOut    : 0.3,
            .parentAlpha             : 0.5, // Effect alpha for overlay
            .shadowOpacity           : 0.0, // Shadow for view content
            .contentYOffset          : 0.0, // Y Offect
            .leftRightPadding        : 0.0, // padding for left and right
            .transitionStyle         : DbSemiModalTransitionStyle.fadeInOutCenter,
            .disableCancel           : true
            // .backgroundView          : UIView() // Custom overlay view
        ]
    }
    
    func db_registerOptions(_ options: [DbSemiModalOption: Any]?) {
        // options always save in parent viewController
        var targetVC: UIViewController = self
        while targetVC.parent != nil {
            targetVC = targetVC.parent!
        }
        
        objc_setAssociatedObject(targetVC, &DbCustomOptions, options, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func db_options() -> [DbSemiModalOption: Any] {
        var targetVC: UIViewController = self
        while targetVC.parent != nil {
            targetVC = targetVC.parent!
        }
        
        if let options = objc_getAssociatedObject(targetVC, &DbCustomOptions) as? [DbSemiModalOption: Any] {
            var defaultOptions: [DbSemiModalOption: Any] = self.db_defaultOptions
            defaultOptions.merge(options) { (_, new) in new }
            
            return defaultOptions
        } else {
            return db_defaultOptions
        }
    }
    
    func db_optionForKey(_ optionKey: DbSemiModalOption) -> Any? {
        let options = self.db_options()
        let value = options[optionKey]
        
        let isValidType = value is Bool ||
            value is Double ||
            value is DbSemiModalTransitionStyle ||
            value is UIView
        
        if isValidType {
            return value
        } else {
            return db_defaultOptions[optionKey]
        }
    }
    
}

// MARK: - extension UIViewController : SemiView
// MARK: -

extension UIViewController
{
    public func db_presentModalSemiView(_ view: UIView, height: CGFloat? = nil)
    {
        let options: [DbSemiModalOption: Any] = [
            DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.limitTopToCenter,
            DbSemiModalOption.animationDurationIn: 0.5,
            DbSemiModalOption.animationDurationOut: 0.2,
            // .contentYOffset : -50,
        ]
        
        // -- Set height for view --
        if let h = height {
            view.height = h
        }
        
        self.db_presentSemiView(view, options: options)
    }
    
    public func db_presentBaseSemiView(_ view: UIView, height: CGFloat? = nil, transitionStyle: DbSemiModalTransitionStyle = .fadeInOutCenter)
    {
        let options: [DbSemiModalOption: Any] = [.transitionStyle: transitionStyle]
        
        // -- Set height for view --
        if let h = height {
            view.height = h
        }
        
        db_presentSemiView(view, options: options)
    }
    
    public func db_presentSemiSheetView(_ view: UIView, height: CGFloat? = nil,
                                        completion: (() -> Void)? = nil,
                                        dismiss: (() -> Void)? = nil)
    {
        let options: [DbSemiModalOption: Any] = [
            .transitionStyle: DbSemiModalTransitionStyle.slideUp,
            .contentYOffset : 10,
            .leftRightPadding : 5,
            ]
        
        // -- Set height for view --
        if let h = height {
            view.height = h
        }
        
        db_presentSemiView(view, options: options, completionBlock: {
            completion?()
        }, dismissBlock: {
            dismiss?()
        })
    }
    
    public func db_presentSemiViewController(_ vc: UIViewController,
                                             options: [DbSemiModalOption: Any]? = nil,
                                             completionBlock: (() -> Void)? = nil,
                                             dismissBlock: (() -> Void)? = nil) {
        db_registerOptions(options)
        let targetParentVC = parentTargetViewController()
        
        targetParentVC.addChildViewController(vc)
        vc.beginAppearanceTransition(true, animated: true)
        
        objc_setAssociatedObject(targetParentVC, &dbSemiModalViewController, vc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(targetParentVC, &dbSemiModalDismissBlock, DbClosureWrapper(closure: dismissBlock), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        //        db_presentSemiView(vc.view, options: options) {
        //            vc.didMove(toParentViewController: targetParentVC)
        //            vc.endAppearanceTransition()
        //
        //            completionBlock?()
        //        }
        
        db_presentSemiView(vc.view, options: options, completionBlock: {
            vc.didMove(toParentViewController: targetParentVC)
            vc.endAppearanceTransition()
            
            completionBlock?()
        }, dismissBlock: {
            dismissBlock?()
        })
        
    }
    
    public func db_presentSemiView(_ view: UIView,
                                   options: [DbSemiModalOption: Any]? = nil,
                                   completionBlock: (() -> Void)? = nil,
                                   dismissBlock: (() -> Void)? = nil)
    {
        db_registerOptions(options)
        let targetView = parentTargetView()
        let targetParentVC = parentTargetViewController()
        let transitionStyle = db_optionForKey(.transitionStyle) as! DbSemiModalTransitionStyle
        var duration = db_optionForKey(.animationDurationIn) as! TimeInterval
        
        if targetView.subviews.contains(view) {
            return
        }
        
        objc_setAssociatedObject(view, &dbSemiModalPresentingViewController, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(targetParentVC, &dbSemiModalDismissBlock, DbClosureWrapper(closure: dismissBlock), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        NotificationCenter.default.addObserver(targetParentVC,
                                               selector: #selector(interfaceOrientationDidChange(_:)),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        
        let semiViewHeight = view.height
        let contentYOffset: CGFloat = CGFloat(db_optionForKey(.contentYOffset) as! Double)
        let leftRightPadding: CGFloat = CGFloat(db_optionForKey(.leftRightPadding) as! Double)
        // -- Older --
        //        var semiViewFrame = CGRect(x: 0, y: targetView.height - semiViewHeight - contentYOffset,
        //                                   width: targetView.width, height: semiViewHeight)
        
        // -- Frame after animation --
        var semiViewFrame = CGRect.zero
        if transitionStyle == .slideUp { // Bottom to Top
            semiViewFrame = CGRect(x: leftRightPadding,
                                   y: (targetView.frame.size.height - semiViewHeight - contentYOffset - self.safeAreaBottomPadding()),
                                   width: targetView.width - (leftRightPadding*2),
                                   height: semiViewHeight)
        } else if transitionStyle == .slideDown {
            semiViewFrame = CGRect(x: leftRightPadding, y: (contentYOffset + self.safeAreaTopPadding()),
                                   width: targetView.width - (leftRightPadding*2),
                                   height: semiViewHeight)
        } else if transitionStyle == .slideCenter
            || transitionStyle == .fadeInOutCenter
            || transitionStyle == .limitTopToCenter {
            // center
            semiViewFrame = CGRect(x: leftRightPadding,
                                   y: (targetView.height - semiViewHeight)/2 + contentYOffset,
                                   width: targetView.width - (leftRightPadding*2),
                                   height: semiViewHeight)
        }
        
        // -- Debug --
        //        print("view.frame = \(String(describing: view.frame))")
        //        print("semiViewFrame = \(String(describing: semiViewFrame))")
        
        let overlay = overlayView()
        targetView.addSubview(overlay)
        
        let screenshot = addOrUpdateParentScreenshotInView(overlay)
        UIView.animate(withDuration: duration, animations: {
            screenshot.alpha = CGFloat(self.db_optionForKey(.parentAlpha) as! Double)
        })
        
        // -- Frame before animation = frame after animtion sheet offsetBy --
        if transitionStyle == .slideUp {
            view.frame = semiViewFrame.offsetBy(dx: 0, dy: +semiViewHeight)
        } else if transitionStyle == .slideDown {
            view.frame = semiViewFrame.offsetBy(dx: 0, dy: -semiViewHeight)
        } else if transitionStyle == .slideCenter {
            view.frame = semiViewFrame.offsetBy(dx: 0, dy: (targetView.height-semiViewHeight)/2 + (semiViewHeight/2))
        } else if transitionStyle == .limitTopToCenter {
            view.frame = semiViewFrame.offsetBy(dx: 0, dy: -20)
        } else {
            view.frame = semiViewFrame
        }
        
        view.alpha = 0
        view.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.tag = dbSemiModalModalViewTag
        targetView.addSubview(view)
        //        targetView.insertSubview(view, aboveSubview: overlay)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = Float(db_optionForKey(.shadowOpacity) as! Double)
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        // -- Process duration --
        if transitionStyle == .slideUp
            || transitionStyle == .slideDown
            || transitionStyle == .slideCenter {
            if duration < 0.9 {
                // Limit duration time for slide
                duration = 0.9 // Default for slide
            }
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        
                        if transitionStyle == .slideUp
                            || transitionStyle == .slideDown
                            || transitionStyle == .slideCenter
                            || transitionStyle == .limitTopToCenter {
                            view.frame = semiViewFrame
                        }
                        view.alpha = 1
                        
        }, completion: { (finished) -> Void in
            if finished {
                NotificationCenter.default.post(name: .dbSemiModalDidShow, object: self)
                completionBlock?()
            }
        })
        
    }
    
    // MARK: - Dissmiss function
    
    @objc public func db_dismissSemiModalView()
    {
        db_dismissSemiModalViewWithCompletion(nil)
    }
    
    public func db_dismissSemiModalViewWithCompletion(_ completion: (() -> Void)?)
    {
        let targetVC = parentTargetViewController()
        
        guard let targetView = targetVC.view
            , let modal = targetView.viewWithTag(dbSemiModalModalViewTag)
            , let overlay = targetView.viewWithTag(dbSemiModalOverlayTag)
            , let transitionStyle = db_optionForKey(.transitionStyle) as? DbSemiModalTransitionStyle
            , let duration = db_optionForKey(.animationDurationOut) as? TimeInterval else { return }
        
        let vc = objc_getAssociatedObject(targetVC, &dbSemiModalViewController) as? UIViewController
        let dismissBlock = (objc_getAssociatedObject(targetVC, &dbSemiModalDismissBlock) as? DbClosureWrapper)?.closure
        
        vc?.willMove(toParentViewController: nil)
        vc?.beginAppearanceTransition(false, animated: true)
        
        // -- Padding --
        let leftRightPadding:CGFloat = CGFloat(db_optionForKey(.leftRightPadding) as! Double)
        
        UIView.animate(withDuration: duration, animations: {
            if transitionStyle == .slideUp {
                let originX: CGFloat = leftRightPadding
                modal.frame = CGRect(x: originX,
                                     y: targetView.height,
                                     width: modal.width,
                                     height: modal.height)
            } else if transitionStyle == .slideDown || transitionStyle == .slideCenter {
                let originX: CGFloat = leftRightPadding
                modal.frame = CGRect(x: originX,
                                     y: -modal.height,
                                     width: modal.width,
                                     height: modal.height)
            }
            
            modal.alpha = 0.0
            overlay.alpha = 0.0
        }, completion: { finished in
            overlay.removeFromSuperview()
            modal.removeFromSuperview()
            
            vc?.removeFromParentViewController()
            vc?.endAppearanceTransition()
            
            dismissBlock?()
            
            objc_setAssociatedObject(targetVC, &dbSemiModalDismissBlock, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            objc_setAssociatedObject(targetVC, &dbSemiModalViewController, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            NotificationCenter.default.removeObserver(targetVC, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        })
        
        if let screenshot = overlay.subviews.first {
            UIView.animate(withDuration: duration, animations: {
                screenshot.alpha = 1
            }, completion: { finished in
                if finished {
                    NotificationCenter.default.post(name: .dbSemiModalDidHide, object: self)
                    completion?()
                }
            })
        }
        
    }
    
    // MARK: - Private function
    
    fileprivate func parentTargetViewController() -> UIViewController
    {
        var viewController: UIViewController = self
        
        if db_optionForKey(.traverseParentHierarchy) as! Bool {
            while viewController.parent != nil {
                viewController = viewController.parent!
            }
        }
        
        return viewController
    }
    
    fileprivate func parentTargetView() -> UIView
    {
        return parentTargetViewController().view
    }
    
    @objc fileprivate func interfaceOrientationDidChange(_ notification: Notification)
    {
        guard let overlay = parentTargetView().viewWithTag(dbSemiModalOverlayTag) else { return }
        let view = addOrUpdateParentScreenshotInView(overlay)
        view.alpha = CGFloat(self.db_optionForKey(.parentAlpha) as! Double)
    }
    
    @discardableResult
    fileprivate func addOrUpdateParentScreenshotInView(_ screenshotContainer: UIView) -> UIView
    {
        let targetView = parentTargetView()
        let semiView = targetView.viewWithTag(dbSemiModalModalViewTag)
        
        screenshotContainer.isHidden = true
        semiView?.isHidden = true
        
        var snapshotView = screenshotContainer.viewWithTag(dbSemiModalScreenshotTag) ?? UIView()
        snapshotView.removeFromSuperview()
        // -- snapshot mobile view --
        snapshotView = targetView.snapshotView(afterScreenUpdates: true) ?? UIView()
        snapshotView.tag = dbSemiModalScreenshotTag
        
        screenshotContainer.addSubview(snapshotView)
        
        screenshotContainer.isHidden = false
        semiView?.isHidden = false
        
        return snapshotView
    }
    
    fileprivate func overlayView() -> UIView
    {
        var overlay: UIView
        if let backgroundView = db_optionForKey(.backgroundView) as? UIView {
            overlay = backgroundView
        } else {
            overlay = UIView()
            overlay.backgroundColor = UIColor.black
        }
        
        overlay.frame = parentTargetView().bounds
        overlay.isUserInteractionEnabled = true
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.tag = dbSemiModalOverlayTag
        
        if db_optionForKey(.disableCancel) as! Bool {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(db_dismissSemiModalView))
            overlay.addGestureRecognizer(tapGesture)
        }
        return overlay
    }
    
    fileprivate func safeAreaBottomPadding() -> CGFloat {
        var bottomPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom ?? 0
            return bottomPadding
        }
        return 0
    }
    
    fileprivate func safeAreaTopPadding() -> CGFloat {
        var topPadding: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 20
            return topPadding
        }
        return 20
    }
    
}

