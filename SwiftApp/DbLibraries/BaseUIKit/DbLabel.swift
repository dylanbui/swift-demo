//
//  DbLabel.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://github.com/GyazSquare/InsetLabel

import UIKit.UILabel

@IBDesignable
open class DbLabel: UILabel, UIGestureRecognizerDelegate {
    
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
            setupLeftImageUILable()
        }
    }
    
    @IBInspectable
    public var leftImagePadding: CGFloat = 5.0 {
        didSet{
            setupLeftImageUILable()
        }
    }
    
    @IBInspectable
    public var rightImage: UIImage? = nil {
        didSet{
            setupRightImageUILable()
        }
    }
    
    @IBInspectable
    public var rightImagePadding: CGFloat = 5.0 {
        didSet{
            setupRightImageUILable()
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
    
    // MARK: UILabel
    
    override open func drawText(in rect: CGRect) {
        let newRect = UIEdgeInsetsInsetRect(rect, contentInsets)
        super.drawText(in: newRect)
    }
    
    // MARK: UIView (UIViewHierarchy)
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        preferredMaxLayoutWidth = frame.width - (contentInsetsLeft + contentInsetsRight)
    }
    
    // MARK: UIView (UIConstraintBasedLayoutLayering)
    
    override open var intrinsicContentSize : CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    // MARK: Public Utility Functions
    
    private var doAction: (() -> Void)? = nil
    
    func setTouchesAction(_ doAction: (() -> Void)?) -> Void
    {
        let singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(self.btnView_Click))
        
        singleFingerTap.delegate = nil;
        self.removeGestureRecognizer(singleFingerTap)
        
        if self.isEnabled {
            self.isUserInteractionEnabled = true
            self.alpha = 1.0
            singleFingerTap.delegate = self;
            self.addGestureRecognizer(singleFingerTap)
            self.doAction = doAction
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.setContentAlpha(0.2)
    }
    
    // -- touchesEnded dont run because dont call in btnView_Click --
//    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        self.alpha = 1.0;
//    }
    
    @objc private func btnView_Click(sender:UIButton!)
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.setContentAlpha(1.0)
        }) { (finished) in
            
        }

        if let doAction = self.doAction {
            doAction()
        }
    }
    
    // MARK: Private Constants
    
    private struct PropertyKey {
        static let contentInsets = "contentInsets"
    }
    
    private func setupLeftImageUILable()
    {
        guard let imageIcon = leftImage else {
            // fatalError("Set Left UIImage before use") // Dung bien dich va bao loi
            return
        }
        
        if let view = viewWithTag(121212) {
            view.removeFromSuperview()
        }
        
        let y = (size.height - imageIcon.size.height) / 2 // Center
        
        let leftImgView = UIImageView.init(image: imageIcon)
        leftImgView.frame = CGRect.init(CGPoint.init(leftImagePadding, y), imageIcon.size)
        leftImgView.tag = 121212
        addSubview(leftImgView)
        
        // layoutIfNeeded()
        setNeedsDisplay()
    }
    
    private func setupRightImageUILable()
    {
        guard let imageIcon = rightImage else {
            // fatalError("Set Left UIImage before use") // Dung bien dich va bao loi
            return
        }
        
        if let view = viewWithTag(212121) {
            view.removeFromSuperview()
        }
        
        let y = (size.height - imageIcon.size.height) / 2 // Center
        let x = bounds.size.width - imageIcon.size.width - rightImagePadding
        
        let rightImgView = UIImageView.init(image: imageIcon)
        rightImgView.frame = CGRect.init(CGPoint.init(x, y), imageIcon.size)
        rightImgView.tag = 212121
        addSubview(rightImgView)
        
        // layoutIfNeeded()
        setNeedsDisplay()
    }

    private func setContentAlpha(_ alpha: CGFloat)
    {
        // -- For all content --
        // self.alpha = alpha
        
        self.textColor = textColor.withAlphaComponent(alpha)
        
        if let leftView = viewWithTag(121212) {
            leftView.alpha = alpha
        }
        
        if let rightView = viewWithTag(212121) {
            rightView.alpha = alpha
        }
    }
    
}
