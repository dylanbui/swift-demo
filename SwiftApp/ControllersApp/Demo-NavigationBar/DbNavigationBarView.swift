//
//  DbNavigationBarView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

// -- Use for ios < 10 --
private var AssociatedObjectHandle: UInt8 = 0
extension UINavigationBar {
    
    var navHeight: CGFloat {
        get {
            if let h = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat {
                return h
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if self.navHeight > 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: self.navHeight)
        }
        return super.sizeThatFits(size)
    }
}

@IBDesignable
class DbNavigationBarView: DbLoadableView
{
    public var vclContainer: UIViewController!
    
    @IBOutlet weak var vwBarContent: UIView!
    // var btnBack: UIButton?
    
    public var handleViewAction: DbHandleAction?
    
    // Default Init
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setup()
    }
    
    // -- convenience --
    convenience init()
    {
        self.init(frame: .zero)
        setup()
    }

    private func setup()
    {
        
    }
    
    convenience init(WithViewController container: UIViewController)
    {
        self.init(frame: .zero)
        self.vclContainer = container
        
        self.initView()
    }
    
    func initView()
    {
        // -- Default frame size --
        self.frame = CGRect(0, 0, CGFloat(Db.screenWidth()), 44)
        
        // -- Turn off back button --
        self.vclContainer.navigationItem.hidesBackButton = true
        
        // -- Fix error 3 dots --
        // https://stackoverflow.com/questions/22425356/title-shows-3-dots-instead-of-the-string-in-a-toggle-button
        //    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}
        //                                                forState:UIControlStateNormal];
        
        // -- Fix error 3 dots way 2 : Remove Back Text --
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-400, 0), for: .default)
        
        // -- Hide all control --
        self.hideAllItemNavigationBar()
        
        Notification.add(.MyViewControllerDidLoad, observer: self,
                         selector: #selector(self.controllerViewDidLoad(_:)), object: nil)
        Notification.add(.MyViewControllerWillAppear, observer: self,
                         selector: #selector(self.controllerViewWillAppear(_:)), object: nil)
        Notification.add(.MyViewControllerWillDisappear, observer: self,
                         selector: #selector(self.controllerViewWillDisappear(_:)), object: nil)
        
    }
    
    @objc public func controllerViewDidLoad(_ notification: Notification)
    {
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            
        }
    }
    
    @objc public func controllerViewWillAppear(_ notification: Notification)
    {
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            // print("Start --- showNavigation")
            self.showNavigation()
        }
    }

    @objc public func controllerViewWillDisappear(_ notification: Notification)
    {
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            // print("Hide --- showNavigation")
            self.hideNavigation()
        }
    }

    func showNavigation()
    {
        if let navbar = self.vclContainer.navigationController?.navigationBar {
            navbar.addSubview(self)
        }
        
        // -- Animation hien thi --
        self.alpha = 0.5
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.showAllItemNavigationBar()
            })
        }
    }
    
    func hideNavigation()
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.hideAllItemNavigationBar()
        }) { (finished) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.0
            }) { (finished) in
                self.removeFromSuperview()
            }
        }
    }
    
    func showAllItemNavigationBar()
    {
        for viewControl: Any in self.vwBarContent.subviews {
            if let viewControl = viewControl as? UILabel {
                viewControl.alpha = 1.0
                viewControl.frame = CGRect.init(origin: CGPoint(CGFloat(viewControl.tag), viewControl.frame.origin.y),
                                                size: viewControl.frame.size)
            } else if let viewControl = viewControl as? UIButton {
                viewControl.alpha = 1.0
            }
        }
    }
    
    func hideAllItemNavigationBar()
    {
        for viewControl: Any in self.vwBarContent.subviews {
            if let viewControl = viewControl as? UILabel {
                viewControl.alpha = 0.0
                viewControl.tag = Int(viewControl.frame.origin.x)
                viewControl.frame = CGRect.init(origin: CGPoint(viewControl.frame.origin.x + 50, viewControl.frame.origin.y),
                                                size: viewControl.frame.size)
            } else if let viewControl = viewControl as? UIButton {
                viewControl.alpha = 0.0
            }
        }

    }
    
    
}
