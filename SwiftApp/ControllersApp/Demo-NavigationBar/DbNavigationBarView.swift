//
//  DbNavigationBarView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation


class DbNavigationBarView: UIView
{
    var vclContainer: UIViewController!
    
    var vwBarContent: UIView = UIView()
    // var btnBack: UIButton?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addBehavior()
//    }
//
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("This class does not support NSCoding")
//    }
//
//    func addBehavior() {
//        print("Add all the behavior here")
//    }
    
    convenience init(WithViewController container: UIViewController)
    {
        self.init(frame: .zero)
        self.vclContainer = container
        
        self.initView()
    }
    
    func initView()
    {
        let viewFrame = CGRect(0, 0, CGFloat(Db.screenWidth()), 44)
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
    
    func showNavigation()
    {
        if let navbar = self.vclContainer.navigationController?.navigationBar {
//            var frame = navbar.frame
//            frame.size.height = self.frame.size.height
//            navbar.frame = frame
            navbar.addSubview(self)
            
            // Fill to parent
//            NSLayoutConstraint.activate([
//                self.leadingAnchor.constraint(equalTo: navbar.leadingAnchor),
//                self.trailingAnchor.constraint(equalTo: navbar.trailingAnchor),
//                self.topAnchor.constraint(equalTo: navbar.topAnchor),
//                self.bottomAnchor.constraint(equalTo: navbar.bottomAnchor)
//                ])

        }
        
        // self.vclContainer.navigationController?.navigationBar.addSubview(self)
        
        // -- Animation hien thi --
        self.alpha = 0.5
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.4, animations: {
                self.showAllItemNavigationBar()
            })
        }
    }
    
    func hideNavigation()
    {
        UIView.animate(withDuration: 0.4, animations: {
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
        for viewControl: Any in self.subviews {
            if let viewControl = viewControl as? UILabel {
                viewControl.alpha = 1.0
                viewControl.frame = CGRect.init(origin: CGPoint(CGFloat(viewControl.tag), viewControl.frame.origin.y),
                                                size: viewControl.frame.size)
            } else if let viewControl = viewControl as? UIButton {
                viewControl.alpha = 0.0
            }
        }
    }
    
    func hideAllItemNavigationBar()
    {
        for viewControl: Any in self.subviews {
            if let viewControl = viewControl as? UILabel {
                viewControl.alpha = 0.0
                viewControl.tag = Int(viewControl.frame.origin.x)
                viewControl.frame = CGRect.init(origin: CGPoint(viewControl.frame.origin.x + 100, viewControl.frame.origin.y),
                                                size: viewControl.frame.size)
            } else if let viewControl = viewControl as? UIButton {
                viewControl.alpha = 0.0
            }
        }

    }
    
    
}
