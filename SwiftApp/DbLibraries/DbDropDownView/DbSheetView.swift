//
//  DbSheetView.swift
//  DbDropDownView
//
//  Created by Dylan Bui on 11/2/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import Foundation
import UIKit

// -- KHONG SU DUNG --

class DbSheetView: UIControl
{
    fileprivate var contentView: UIView!
    fileprivate var dropDownView: DbDropDownView!

    // Init
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
//    public convenience init(withContentView: UIView)
//    {
//        self.init(frame: .zero)
//        self.contentView = withContentView
//        setupDropDown()
//        setup()
//    }
    
    public convenience init(withContentView: UIView, andHeight: CGFloat)
    {
        self.init(frame: .zero)
        self.contentView = withContentView
        var frame = self.contentView.frame
        frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: andHeight)
        self.contentView.frame = frame
//        self.contentView.frame.size.height
//        UIScreen.main.bounds.size.width
        setupDropDown()
        setup()
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setupDropDown()
        setup()
    }
    
    fileprivate func setupDropDown()
    {
        var theme = DbDropDownViewTheme(cellHeight: 0,
                                   bgColor: UIColor.clear,
                                   borderColor: UIColor.clear,
                                   separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.black)
        theme.dismissableViewColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        self.dropDownView = DbDropDownView(withAnchorView: self)
        self.dropDownView.hideOptionsWhenTouchOut = true
        self.dropDownView.theme = theme //.selectBoxTheme()
        self.dropDownView.tableYOffset = 5.0 + self.safeAreaBottomPadding()
        self.dropDownView.tableHeaderView = self.contentView
        self.dropDownView.tableCornerRadius = 0.0
        self.dropDownView.isScrollEnabled = false
        
        self.dropDownView.displayDirection = .BottomToTop
        
        self.dropDownView.tableDoingAppear {

        }
        
        self.dropDownView.tableDoingDisappear {

        }
        
        self.dropDownView.tableDidDisappear {

        }
    }
    
    fileprivate func setup()
    {
        // -- Width full screen --
        var frame = self.contentView.frame
        frame.size.width = UIScreen.main.bounds.size.width
//        print("1 self.contentView.frame = \(String(describing: self.contentView.frame))")
        self.contentView.frame = frame
        
        //        return Int(UIScreen.main.bounds.size.width)
        //        return Int(UIScreen.main.bounds.size.height)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 0)
        self.backgroundColor = UIColor.clear
        
        // -- Add to root view --
        guard let vclRoot = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("RootViewController not found")
        }
        vclRoot.view.addSubview(self)
    }
    
    func show()
    {
//        print("2 self.contentView.frame = \(String(describing: self.contentView.frame))")
        self.dropDownView.tableListHeight = self.contentView.frame.size.height
        self.dropDownView.showDropDown()
    }

    func hide()
    {
        self.dropDownView.hideDropDown()
    }
    
    private func safeAreaBottomPadding() -> CGFloat!
    {
        var bottomPadding: CGFloat! = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding
        }
        return 0
    }

}

