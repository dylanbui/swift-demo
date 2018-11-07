//
//  DbTextField.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit.UITextField

typealias DbTextFieldTouchInside = (DbTextField) -> Void

@IBDesignable
open class DbTextField: UITextField {
    
    // MARK: Properties
    // .zero
    // UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    open var contentInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    open var contentInsetsTop: CGFloat {
        get {
            return contentInsets.top;
        }
        set {
            contentInsets.top = newValue
        }
    }
    
    @IBInspectable
    open var contentInsetsLeft: CGFloat {
        get {
            return contentInsets.left;
        }
        set {
            contentInsets.left = newValue
        }
    }
    
    @IBInspectable
    open var contentInsetsBottom: CGFloat {
        get {
            return contentInsets.bottom;
        }
        set {
            contentInsets.bottom = newValue
        }
    }
    
    @IBInspectable
    open var contentInsetsRight: CGFloat {
        get {
            return contentInsets.right;
        }
        set {
            contentInsets.right = newValue
        }
    }
    
    @IBInspectable
    public var leftImage: UIImage? = nil {
        didSet{
            setupLeftImageView()
        }
    }

    @IBInspectable
    public var leftImagePadding: CGFloat = 5.0 {
        didSet{
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable
    public var rightImage: UIImage? = nil {
        didSet{
            setupRightImageView()
        }
    }
    
    @IBInspectable
    public var rightImagePadding: CGFloat = 5.0 {
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: NSCoding
    
    override open func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(contentInsets, forKey: PropertyKey.contentInsets)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentInsets = aDecoder.decodeUIEdgeInsets(forKey: PropertyKey.contentInsets)
        // Default contentInsets content
        contentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        // http://www.iosinsight.com/uitextviewrightviewpaddingswift/
        // UITextField rightView Padding With Swift
        let y = (size.height - (leftImage?.size.height)!) / 2 // Always Center
        return CGRect.init(CGPoint.init(leftImagePadding, y), (leftImage?.size)!)
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let y = (size.height - (rightImage?.size.height)!) / 2 // Always Center
        let x = bounds.size.width - (rightImage?.size.width)! - rightImagePadding
        return CGRect.init(CGPoint.init(x, y), (rightImage?.size)!)
    }
    
    func addLeftImage(_ image: UIImage, withLeftPadding padding: CGFloat = 5.0) -> Void {
        self.leftImage = image
        self.leftImagePadding = padding
    }

    func addRightImage(_ image: UIImage, withRightPadding padding: CGFloat = 5.0) -> Void {
        self.rightImage = image
        self.rightImagePadding = padding
    }
    
    func drawBorder(withColor color: UIColor, borderWidth width: CGFloat, cornerRadius corner: CGFloat) -> Void
    {
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
    
    func touchInside(_ touchInsideHandle: @escaping DbTextFieldTouchInside) -> Void
    {
        if self.btnTemp != nil {
            self.btnTemp?.removeFromSuperview()
            self.btnTemp = nil
        }
        
        self.touchHandler = touchInsideHandle
        
        self.btnTemp = UIButton(type: .custom)
        self.btnTemp?.layer.masksToBounds = self.layer.masksToBounds
        self.btnTemp?.layer.cornerRadius = self.layer.cornerRadius
        
        self.btnTemp?.frame = CGRect(0, 0, self.frame.size.width, self.frame.size.height)
        self.btnTemp?.backgroundColor = UIColor.clear
        self.btnTemp?.titleLabel?.text = ""
        
        self.btnTemp?.setBackgroundImage(UIImage.init(color: UIColor(hexString: "#f5f5f5", alpha: 0.5), size: (self.btnTemp?.frame.size)!), for: .highlighted)
        
        // add targets and actions
        self.btnTemp?.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        
        // -- Calculator button view match superview frame --
        let frameMatchParent = self.superview?.convert(self.frame, to: self.superview)
        self.btnTemp?.frame = frameMatchParent!
        // -- Add to super view --
        self.superview?.addSubview(self.btnTemp!)
    }
    
    @IBAction func buttonClicked(_ sender: AnyObject)
    {
        self.touchHandler?(self)
    }
    
    // MARK: Private Constants
    
    private struct PropertyKey {
        static let contentInsets = "contentInsets"
    }
    
    private var btnTemp: UIButton?
    private var touchHandler: DbTextFieldTouchInside?
    
    
    // MARK: - Internal functions
    // MARK:
    
    // Setup setupLeftImageView
    fileprivate func setupLeftImageView() {
        leftViewMode = .always
        leftView = UIImageView(image: leftImage)
    }
    
    // Setup setupLeftImageView
    fileprivate func setupRightImageView() {
        rightViewMode = .always
        rightView = UIImageView(image: rightImage)
    }

}

