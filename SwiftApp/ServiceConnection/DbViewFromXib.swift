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
typealias HandleViewAction = (AnyObject, Int, [String:AnyObject]?, Error?) -> ()

class DbViewFromXib: UIView
{

    var handleViewAction: HandleViewAction?
    
    var contentView: UIView!
    
    var nibName: String
    {
        return String(describing: type(of: self))
    }
    
    //MARK:
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
    }
    
    //MARK:
    func loadViewFromNib()
    {
        contentView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?[0] as! UIView
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }
}
