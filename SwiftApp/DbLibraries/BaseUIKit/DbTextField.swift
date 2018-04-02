//
//  DbTextField.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit.UITextField

@IBDesignable
open class DbTextField: UITextField {
    
    // MARK: Properties
    
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
        let y = (size.height - (leftImage?.size.height)!) / 2 // Always Center
        let x = bounds.size.width - (leftImage?.size.width)! - rightImagePadding
        return CGRect.init(CGPoint.init(x, y), (leftImage?.size)!)
    }
    
    // MARK: Private Constants
    
    private struct PropertyKey {
        static let contentInsets = "contentInsets"
    }
    
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

