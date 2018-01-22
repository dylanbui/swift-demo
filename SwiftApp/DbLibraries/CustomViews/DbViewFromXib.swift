//
//  DbViewFromXib.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/24/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

// http://justabeech.com/2014/07/27/xcode-6-live-rendering-from-nib/
// https://stackoverflow.com/questions/25513271/how-to-initialise-a-uiview-class-with-a-xib-file-in-swift-ios
// -- Xu ly tra ve cua cac UIView action --
//typealias HandleViewAction = (AnyObject, Int, [String:AnyObject]?, Error?) -> ()

class DbViewFromXib: UIView
{

    var handleViewAction: DbHandleViewAction?

    private var contentView: UIView!
    
//    var nibName: String
//    {
//        return String(describing: type(of: self))
//    }
    
    //MARK:
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    //MARK:
//    func loadViewFromNib()
//    {
//        contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentView.frame = bounds
//        addSubview(contentView)
//    }
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        contentView = loadViewFromNib()
        // use bounds not frame or it'll be offset
        contentView.frame = bounds
        // Adding custom subview on top of our view
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": contentView]))
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
}
