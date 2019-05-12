//
//  MyCustomNavigationBarView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

@IBDesignable
class MyCustomNavigationBarView: DbLoadableView
{
    public var vclContainer: UIViewController!
    
    @IBOutlet weak var vwBarContent:  UIView!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblCenter: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    
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
    
    convenience init(WithViewController container: UIViewController)
    {
        self.init(frame: .zero)
        self.vclContainer = container
        
        self.initView()
    }
    
    private func setup()
    {
        
    }
    
    func initView()
    {
        let viewFrame = CGRect(0, 0, CGFloat(Db.screenWidth()), 70)
        self.frame = viewFrame
        
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
    
    // MARK: - Demo action
    // MARK: -
    
    func updateNav_ShowAll(_ top: String, bottom: String)
    {
        self.lblTop.text = top
        self.lblBottom.text = bottom
        
        self.lblTop.isHidden = false
        self.lblBottom.isHidden = false
        self.lblCenter.isHidden = true
        self.btnBack.isHidden = false
    }
    
    func updateNav_NoBack(_ top: String, bottom: String)
    {
        self.lblTop.text = top
        self.lblBottom.text = bottom
        
        self.lblTop.isHidden = false
        self.lblBottom.isHidden = false
        self.lblCenter.isHidden = true
        
        // -- Hide button --
        self.hideBackButton()
        // Update position uilabel
        self.hideAllItemNavigationBar()
    }
    
    func updateNav_OnlyTitle(_ title: String)
    {
        self.lblCenter.text = title

        self.lblTop.isHidden = true
        self.lblBottom.isHidden = true
        self.lblCenter.isHidden = false
        self.btnBack.isHidden = true
    }
    
    func updateNav_BackAndTitle(_ title: String)
    {
        self.lblCenter.text = title
        
        self.lblTop.isHidden = true
        self.lblBottom.isHidden = true
        self.lblCenter.isHidden = false
        self.btnBack.isHidden = false
    }
    
    // -----
    
    
    @objc private func controllerViewDidLoad(_ notification: Notification)
    {
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            
        }
    }
    
    @objc private func controllerViewWillAppear(_ notification: Notification)
    {
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            print("Start --- showNavigation")
            self.showNavigation()
        }
    }
    
    @objc private func controllerViewWillDisappear(_ notification: Notification)
    {
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            print("Hide --- showNavigation")
            self.hideNavigation()
        }
    }
    
    @IBAction func btnBack_Click(_ sender: AnyObject)
    {
        self.vclContainer.navigationController?.popViewController(animated: true)
    }
    
    func hideBackButton()
    {
        self.btnBack.isHidden = true
        
        for viewControl: Any in self.vwBarContent.subviews {
            if let viewControl = viewControl as? UILabel {
                viewControl.x = 15
            }
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
