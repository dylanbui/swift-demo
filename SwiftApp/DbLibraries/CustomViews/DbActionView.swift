//
//  DbActionView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/25/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

@IBDesignable
class DbActionView: UIControl, UIGestureRecognizerDelegate
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
    
    override var isEnabled: Bool {
        didSet {
            initialize()
            self.setNeedsDisplay()
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
        if let bgColor = self.backgroundColor {
            dictOldProperty["backgroundColor"] = bgColor
        }
    }

    fileprivate func initialize()
    {
        self.defaultSetup()
        
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(self.btnView_Click))
        
        singleFingerTap.delegate = nil;
        self.removeGestureRecognizer(singleFingerTap)
        
        if self.isEnabled {
            self.alpha = 1.0;
            singleFingerTap.delegate = self;
            self.addGestureRecognizer(singleFingerTap)
        } else {
            self.alpha = self.disableAlpha;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.backgroundColor = self.touchUpInsideColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.backgroundColor = self.dictOldProperty["backgroundColor"] as? UIColor
    }

    @objc func btnView_Click(sender:UIButton!)
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.dictOldProperty["backgroundColor"] as? UIColor
        }) { (finished) in
            self.sendActions(for: UIControlEvents.touchUpInside)
        }
    }
    
    
}
