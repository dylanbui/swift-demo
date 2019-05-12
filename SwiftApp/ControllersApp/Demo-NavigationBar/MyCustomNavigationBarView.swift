//
//  MyCustomNavigationBarView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit



class MyCustomNavigationBarView: DbNavigationBarView
{
    let defaultNavHeight: CGFloat = 70
    
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblCenter: UILabel!
    @IBOutlet weak var lblBottom: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    public var navBarModel: CustomNavBarViewModel? {
        didSet {
            guard let navBarModel = navBarModel else { return }
            
            lblTop.text = navBarModel.topTitle
            lblCenter.text = navBarModel.centerTitle
            lblBottom.text = navBarModel.bottomTitle
            
            lblTop.isHidden = lblTop.text == nil
            lblCenter.isHidden = lblCenter.text == nil
            lblBottom.isHidden = lblBottom.text == nil
            
            if navBarModel.isHiddenBackButton == true {
                // -- Hide button --
                self.hideBackButton()
                // Update position uilabel
                self.hideAllItemNavigationBar()
            }
        }
        
    }
    
    override func initView()
    {
        super.initView()
        
        /*
         Doi voi ios truoc 11, co the thay doi chieu cao cua UINavigationBar, sau ios 11 khong the thay doi
         do do phai dieu chinh content hien thi ben duoi UINavigationBar
         Chua test doi voi cac loai pull to refresh
         */
        /* De chinh content hien thi duoi UINavigationBar cao hon */
        //Important!
        if #available(iOS 11.0, *) {
            // Default NavigationBar Height is 44. Custom NavigationBar Height is 66.
            // So We should set additionalSafeAreaInsets to 70-44 = 26
            self.vclContainer.additionalSafeAreaInsets.top = 26
        }
        
        // -- Update frame size --
        self.frame = CGRect(0, 0, CGFloat(Db.screenWidth()), self.defaultNavHeight)
    }
    
    @objc public override func controllerViewDidLoad(_ notification: Notification)
    {
        super.controllerViewDidLoad(notification)
        
        if let vcl = notification.object as? UIViewController, vcl === self.vclContainer {
            // -- Set default height for navigationBar --
            // -- Importan: only run on ViewDidLoad of UIViewController --
            self.vclContainer.navigationController?.navigationBar.navHeight = self.defaultNavHeight
        }
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
    
    @IBAction func btnBack_Click(_ sender: AnyObject)
    {
        if let backAction = navBarModel?.backButtonAction {
            backAction()
            return
        }
        // -- Default action --
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
    
}

public protocol CustomNavBarViewModel {
    var isHiddenBackButton: Bool { get }
    var backButtonAction: (() -> Void)?   { get }
    
    var topTitle: String?       { get }
    var centerTitle: String?    { get }
    var bottomTitle: String?    { get }
}

extension CustomNavBarViewModel {
    
    public var isHiddenBackButton: Bool {
        return false
    }
    
    public var backButtonAction: (() -> Void)? {
        return nil
    }
    
    public var topTitle: String? {
        return nil
    }
    
    public var centerTitle: String? {
        return nil
    }
    
    public var bottomTitle: String? {
        return nil
    }
}

public struct NavBarViewModel: CustomNavBarViewModel {
    public var isHiddenBackButton: Bool
    public var backButtonAction: (() -> Void)?
    
    public var topTitle: String?
    public var centerTitle: String?
    public var bottomTitle: String?
    
    public init(isHiddenBackButton: Bool = false,
                backButtonAction: (() -> Void)? = nil,
                topTitle: String? = nil,
                centerTitle: String? = nil,
                bottomTitle: String? = nil) {
        self.isHiddenBackButton = isHiddenBackButton
        self.backButtonAction = backButtonAction
        self.topTitle = topTitle
        self.centerTitle = centerTitle
        self.bottomTitle = bottomTitle
    }
}
