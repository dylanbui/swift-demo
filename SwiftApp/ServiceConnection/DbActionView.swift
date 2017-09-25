//
//  DbActionView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/25/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

@IBDesignable
class DbActionView: UIControl
{
    @IBInspectable
    public var masksToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = self.masksToBounds
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable
    public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }

    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }

    @IBInspectable
    public var disableAlpha: CGFloat = 0.5

    @IBInspectable
    public var touchUpInsideColor: UIColor?
    
    @IBInspectable
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1.0;
            } else {
                self.alpha = self.disableAlpha;
            }
            initialize()
        }
    }
    
    
    private var dictOldProperty: [String: AnyObject] = [:]
    
    override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        initialize()
    }

    
    //MARK: Initializers
    override init(frame : CGRect)
    {
        super.init(frame : frame)
        initialize()
    }
    
    convenience init()
    {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        initialize()
    }
    
    fileprivate func defaultSetup()
    {
        
        
    }

    fileprivate func initialize()
    {
        self.defaultSetup()
        
        if let bgColor = self.backgroundColor {
            dictOldProperty["backgroundColor"] = bgColor
        }
        
    }

    
    
}
