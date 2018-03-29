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
            // invalidateIntrinsicContentSize()
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
    
    // MARK: Private Constants
    
    private struct PropertyKey {
        static let contentInsets = "contentInsets"
    }
}

