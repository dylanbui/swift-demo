//
//  DbAbstractSheet.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/17/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

public protocol DbAbstractSheetDelegate:class{
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet)
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    func sheetPicker(didShowPicker sheetPicker: DbAbstractSheet)
    func sheetPicker(didHidePicker sheetPicker: DbAbstractSheet)
}

public extension DbAbstractSheetDelegate{
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet){}
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet){}
    func sheetPicker(didShowPicker sheetPicker: DbAbstractSheet){}
    func sheetPicker(didHidePicker sheetPicker: DbAbstractSheet){}
}

public class DbAbstractSheet: NSObject
{
    private(set) internal var containerView:UIView?
    private(set) internal var contentView:UIView?
    private(set) internal var bottomView:UIView?
    
    private(set) public var okButton:UIButton?
    private(set) public var cancelButton:UIButton?
    
    private(set)  public var isShown = false
    
    private(set)  public var titleLabel:UILabel?{
        didSet{
            guard let label = titleLabel else{
                return
            }
            
            label.addObserver(self, forKeyPath: "text", options: [.new], context: nil)
        }
    }
    
    public weak var anchorControl: UIView?
    public weak var pickerFieldDelegate: DbAbstractSheetDelegate?
    
    public var fieldHeight: CGFloat=250 {
        didSet{
            heightConstraint?.constant = fieldHeight
        }
    }
    public var hideButtons: Bool = false {
        didSet{
            bottomSectionHeightConstraint?.constant = hideButtons ? 0 : DEFAULT_BOTTOM_SECTION_HEIGHT
        }
    }
    public var cancelWhenTouchUpOutside: Bool = false {
        didSet{
            
        }
    }
    
    private let DEFAULT_BOTTOM_SECTION_HEIGHT:CGFloat=50
    private let DEFAULT_TITLE_LABLE_HEIGHT:CGFloat=20
    private var alreadySet=false
    private var alert:UIAlertController?
    private weak var viewController:UIViewController?
    private var heightConstraint:NSLayoutConstraint?
    private var titleHeightConstraint:NSLayoutConstraint?
    private var titleTopConstraint:NSLayoutConstraint?
    private var bottomSectionHeightConstraint:NSLayoutConstraint?
    
    override init()
    {
        super.init()
        commonInit()
    }
    
    convenience init(WithAnchor anchor: UIView)
    {
        self.init()
        self.anchorControl = anchor
    }
    
    private func commonInit()
    {
        setupView()
    }
    
    public func setupContentView() -> UIView
    {
        fatalError("This is an abstract class, you must use a subclass of DbAbstractSheet (like DbSheetPicker)")
    }
    
    private func setupView()
    {
        //alertview
        guard alert == nil else{
            return
        }
        
        alert = UIAlertController(title: nil, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert?.isModalInPopover = true
        
        heightConstraint = NSLayoutConstraint(item: alert!.view,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: nil,
                                              attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                              multiplier: 1, constant: self.fieldHeight)
        
        alert?.view.addConstraint(heightConstraint!)
        
        //containerView
        containerView = UIView()
        alert?.view.addSubview(containerView!)
        addConstraint(containerView!, toView: alert!.view, top: 0, leading: 0, bottom: 0, trailing: 0)
        guard let containerView = containerView else{
            return
        }
        
        //titleLabel
        titleLabel = UILabel()
        containerView.addSubview(titleLabel!)
        addConstraint(titleLabel!, toView: containerView, top: nil, leading: nil, bottom: nil, trailing: nil)
        titleLabel?.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive=true
        titleTopConstraint = titleLabel?.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
        titleTopConstraint?.isActive=true
        titleHeightConstraint = titleLabel?.heightAnchor.constraint(equalToConstant: 0)
        titleHeightConstraint?.isActive=true
        titleLabel?.font=UIFont.systemFont(ofSize: 13)
        titleLabel?.textColor = .lightGray
        
        // BottomView buttons
        self.bottomView = UIView()
        containerView.addSubview(self.bottomView!)
        guard let bottomView = self.bottomView else{
            return
        }
        
        bottomView.clipsToBounds=true
        addConstraint(bottomView, toView: containerView, top: nil, leading: 0, bottom: 0, trailing: 0)
        bottomSectionHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: DEFAULT_BOTTOM_SECTION_HEIGHT)
        bottomSectionHeightConstraint?.isActive=true
        // -- Add OK button --
        okButton = UIButton(type: .system)
        bottomView.addSubview(okButton!)
        // -- DucBui 17/01/2019 : Khong hieu ly do vi sao, ko the addTarget --
        // Neu addTarget thi build duoc, nhung chay bi loi toan bo phan ben duoi
        // Neu khong dung addTarget thi cai addTarget for cancelButton chay binh thuong
        // Phai dung addGestureRecognizer thay the
        // okButton!.addTarget(self, action: #selector(didOKTap), for: .touchUpInside)
        okButton?.addGestureRecognizer(UITapGestureRecognizer(taps: 1, handler: { (gesture) in
            self.didOKTap()
        }))
        okButton?.setTitle("OK", for: .normal)
        addConstraint(okButton!, toView: bottomView, top: 0, leading: 0, bottom: 0, trailing: nil)
        okButton?.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.5).isActive=true
        
        // -- Add Cancel button --
        cancelButton = UIButton(type: .system)
        bottomView.addSubview(cancelButton!)
        // cancelButton?.addTarget(self, action: #selector(didCancelTap), for: .touchUpInside)
        cancelButton?.addGestureRecognizer(UITapGestureRecognizer(taps: 1, handler: { (gesture) in
            self.didCancelTap()
        }))
        cancelButton?.setTitle("Cancel", for: .normal)
        addConstraint(cancelButton!, toView: bottomView, top: 0, leading: nil, bottom: 0, trailing: 0)
        cancelButton?.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.5).isActive=true
        
        // Seperator line
        let seperater = UIView()
        bottomView.addSubview(seperater)
        addConstraint(seperater, toView: bottomView, top: 0, leading: 0, bottom: nil, trailing: 0)
        seperater.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive=true
        seperater.heightAnchor.constraint(equalToConstant: 1).isActive=true
        seperater.backgroundColor = UIColor.groupTableViewBackground
        
        // ContentView
        contentView = UIView()
        containerView.addSubview(contentView!)
        addConstraint(contentView!, toView: containerView, top: nil, leading: 4, bottom: nil, trailing: -4)
        contentView?.bottomAnchor.constraint(equalTo: bottomView.topAnchor,constant: -4).isActive=true
        contentView?.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor,constant: 4).isActive=true
    }
        
    @objc fileprivate func didOKTap()
    {
        dismiss()
        self.pickerFieldDelegate?.sheetPicker(didOKClick: self)
    }
    
    @objc fileprivate func didCancelTap()
    {
        dismiss()
        self.pickerFieldDelegate?.sheetPicker(didCancelClick: self)
    }
    
    private func getViewController() -> UIViewController?
    {
        if let vc = self.viewController {
            return vc
        }
        
        // -- Neu khong co anchor thi lay rootViewController --
        if self.anchorControl == nil {
            self.viewController = UIApplication.shared.keyWindow?.rootViewController
            return self.viewController
        }
        
        var responder: UIResponder? = self.anchorControl
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        
        self.viewController=(responder as? UIViewController)
        return self.viewController
    }
    
    internal func addConstraint(_ view:UIView,toView:UIView,top:CGFloat?,leading:CGFloat?,bottom:CGFloat?,trailing:CGFloat?)
    {
        view.translatesAutoresizingMaskIntoConstraints=false
        if let top=top{
            view.topAnchor.constraint(equalTo: toView.topAnchor, constant: top).isActive=true
        }
        if let leading=leading{
            view.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: leading).isActive=true
        }
        if let trailing=trailing{
            view.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: trailing).isActive=true
        }
        if let bottom=bottom{
            view.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottom).isActive=true
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            
            if let newVal=change?[.newKey] as? String,!newVal.isEmpty{
                self.titleHeightConstraint?.constant=DEFAULT_TITLE_LABLE_HEIGHT
                self.titleTopConstraint?.constant=8
            }
            else{
                self.titleHeightConstraint?.constant=0
                self.titleTopConstraint?.constant=0
            }
        }
    }
    
    deinit {
        titleLabel?.removeObserver(self, forKeyPath: "text")
    }
    
    //MARK:- public methods
    public func show()
    {
        guard let alert=self.alert, !isShown else{
            return
        }
        
        // -- Setup content view --
        let cotent = setupContentView()
        self.contentView?.addSubview(cotent)
        self.addConstraint(cotent, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
        
        isShown = true
        
        if let popoverController = alert.popoverPresentationController, let anchor = self.anchorControl {
            popoverController.sourceView = anchor
            popoverController.sourceRect = anchor.bounds
        }
        
        getViewController()?.present(alert, animated: true, completion: { [weak self] in
            
            guard let unSelf = self, unSelf.cancelWhenTouchUpOutside else {
                return
            }
            
            unSelf.pickerFieldDelegate?.sheetPicker(didShowPicker: unSelf)
            
            if let ousideView=unSelf.alert!.view.superview?.subviews.first {
                ousideView.isUserInteractionEnabled = true
                ousideView.addGestureRecognizer( UITapGestureRecognizer(target: unSelf, action: #selector(unSelf.dismiss)))
            }
            
        })
    }
    
    @objc public func dismiss(){
        guard let alert=self.alert, isShown else{
            return
        }
        
        isShown=false
        
        alert.dismiss(animated: true) { [weak self] in
            guard let unSelf = self  else{
                return
            }
            unSelf.pickerFieldDelegate?.sheetPicker(didHidePicker: unSelf)
        }
    }
}