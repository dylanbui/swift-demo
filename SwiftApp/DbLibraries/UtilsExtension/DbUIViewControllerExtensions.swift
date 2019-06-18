//
//  DbUIViewController.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/21/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Base on : https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/UIKit/UIViewControllerExtensions.swift

import UIKit

// MARK: - Properties
public extension UIViewController {
    
    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    var db_isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && view.window != nil
    }
    
}

// MARK: - Methods
public extension UIViewController {
    
    /// SwifterSwift: Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func db_addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChildViewController(child)
        containerView.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    /// SwifterSwift: Helper method to remove a UIViewController from its parent.
    func db_removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
    
}
