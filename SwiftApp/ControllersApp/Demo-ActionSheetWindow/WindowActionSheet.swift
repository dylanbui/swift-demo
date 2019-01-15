//
//  File.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

class WindowActionSheetVC: UIViewController
{
    var actionSheet: WindowActionSheet?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return UIApplication.shared.statusBarStyle
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    func setActionSheet(actionSheet: WindowActionSheet)
    {
        // Prevent processing one action sheet twice
        if self.actionSheet == actionSheet {
            return
        }
        // Dissmiss previous action sheet if it presented
        if self.actionSheet!.presented {
            self.actionSheet!.dismissWithClickedButtonIndex()
        }
        // Remember new action sheet
        self.actionSheet = actionSheet
        // Present new action sheet
        self.presentActionSheetAnimated(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.presentActionSheetAnimated(animated: true)
    }
    
    private func presentActionSheetAnimated(animated: Bool)
    {
        // New action sheet will be presented only when view controller will be loaded
        if self.actionSheet != nil && self.isViewLoaded && self.actionSheet!.presented {
            self.actionSheet?.configureFrameForBounds(bounds: self.view.bounds)
            self.actionSheet?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(self.actionSheet!)
            self.actionSheet?.showInContainerViewAnimated(animated: animated)
        }
    }
}


class WindowActionSheet: UIView
{
    public var bgView: UIView?
    public var presented: Bool = false
    
    
    private var SWActionSheetWindow: UIWindow?
    private var windowLevel: UIWindowLevel!
    
    private var view: UIView?
    private var _bgView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    convenience init(WithView aView: UIView, windowLevel winLevel: UIWindowLevel)
    {
        self.init()
        
        self.view = aView
        self.windowLevel = winLevel
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0) //[UIColor colorWithWhite:0.f alpha:0.0f];
        _bgView = UIView()
        _bgView!.backgroundColor = UIColor.init(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.addSubview(_bgView!)
        self.addSubview(view!)
    }
    
    func showInContainerView()
    {
        // Make sheet window visible and active
        let sheetWindow = self.window()
        if !sheetWindow.isKeyWindow {
            sheetWindow.makeKeyAndVisible()
        }
        sheetWindow.isHidden = false
        // Put our ActionSheet in Container (it will be presented as soon as possible)
        self.actionSheetContainer()?.actionSheet = self
    }
    
    func dismissWithClickedButtonIndex()
    {
        let fadeOutToPoint: CGPoint = CGPoint(self.view!.center.x, self.center.y + self.view!.frame.size.height)
        
        // Present sheet
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
            self.center = fadeOutToPoint
            self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
        }, completion: { (success) in
            self.destroyWindow()
            self.removeFromSuperview()
        })
        
        self.presented = false
    }
    
    func showInContainerViewAnimated(animated: Bool)
    {
        let y = self.center.y - self.view!.frame.size.height
        let toPoint: CGPoint = CGPoint(self.center.x, y)
        
        // Present sheet
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn], animations: {
            self.center = toPoint
            self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        }, completion: nil)
        
        self.presented = true
    }
    
    private func destroyWindow()
    {
        if self.SWActionSheetWindow != nil {
            self.actionSheetContainer()?.actionSheet = nil
            self.SWActionSheetWindow!.isHidden = true
            if self.SWActionSheetWindow!.isKeyWindow {
                self.SWActionSheetWindow!.resignFirstResponder()
            }
            self.SWActionSheetWindow!.rootViewController = nil
            self.SWActionSheetWindow = nil
        }

    }
    
    private func window() -> UIWindow
    {
        if let win = self.SWActionSheetWindow {
            return win
        }
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.windowLevel = self.windowLevel
        window.backgroundColor = UIColor.clear
        window.rootViewController = WindowActionSheetVC()
        self.SWActionSheetWindow = window
        
        return window
    }
    
    private func actionSheetContainer() -> WindowActionSheetVC?
    {
        return self.window().rootViewController as? WindowActionSheetVC
        
    }
    
    func configureFrameForBounds(bounds: CGRect)
    {
        self.frame = CGRect(bounds.origin.x, bounds.origin.y, bounds.size.width,
                            bounds.size.height + self.view!.bounds.size.height)
        self.view!.frame = CGRect(view!.bounds.origin.x, bounds.size.height, view!.bounds.size.width, view!.bounds.size.height)
        self.view!.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self._bgView!.frame = self.view!.frame
        self._bgView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
