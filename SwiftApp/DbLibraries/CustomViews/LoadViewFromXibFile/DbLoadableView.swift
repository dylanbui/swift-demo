//
//  DbViewFromXib.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/10/18.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//  Update : 25/04/2019
//  Base on v3.3.0 : https://github.com/MLSDev/LoadableViews

import Foundation
import UIKit

/// Protocol to define family of loadable views
public protocol DbNibLoadableProtocol : NSObjectProtocol {
    
    /// View that serves as a container for loadable view. Loadable views are added to container view in `setupNib(_:)` method.
    var nibContainerView: UIView { get }
    
    /// Method that loads view from single view xib with `nibName`.
    ///
    /// - returns: loaded from xib view
    func loadNib() -> UIView
    
    /// Method that is used to load and configure loadableView. It is then added to `nibContainerView` as a subview. This view receives constraints of same width and height as container view.
    func setupNib()
    
    /// Name of .xib file to load view from.
    var nibName : String { get }
}

extension UIView {
    /// View usually serves itself as a default container for loadable views
    @objc dynamic open var nibContainerView : UIView { return self }
    
    /// Default nibName for all UIViews, equal to name of the class.
    @objc dynamic open var nibName : String { return String(describing: type(of: self)) }
}

extension DbNibLoadableProtocol {
    /// Method that loads view from single view xib with `nibName`.
    ///
    /// - returns: loaded from xib view
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    public func setupView(_ view: UIView, inContainer container: UIView) {
        container.backgroundColor = .clear
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:[], metrics:nil, views: bindings))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:[], metrics:nil, views: bindings))
    }
}

extension DbNibLoadableProtocol where Self: UIView {
    
    /// Sets the frame of the view to result of `systemLayoutSizeFitting` method call with `UIView.layoutFittingCompressedSize` parameter.
    ///
    /// - Returns: loadable view
    public func compressedLayout() -> Self {
        frame.size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return self
    }
    
    /// Sets the frame of the view to result of `systemLayoutSizeFitting` method call with `UIView.layoutFittingExpandedSize` parameter.
    ///
    /// - Returns: loadable view
    public func expandedLayout() -> Self {
        frame.size = systemLayoutSizeFitting(UILayoutFittingExpandedSize)
        return self
    }
    
    /// Sets the frame of the view to result of `systemLayoutSizeFitting` method call with provided parameters.
    ///
    /// - Parameters:
    ///   - fittingSize: fittingSize to be passed to `systemLayoutSizeFitting` method.
    ///   - horizontalPriority: horizontal priority to be passed to `systemLayoutSizeFitting` method.
    ///   - verticalPriority: vertical priority to be passed to `systemLayoutSizeFitting` method.
    /// - Returns: loadable view
    public func systemLayout(fittingSize: CGSize,
                             horizontalPriority: UILayoutPriority,
                             verticalPriority: UILayoutPriority) -> Self {
        frame.size = systemLayoutSizeFitting(fittingSize,
                                             withHorizontalFittingPriority: horizontalPriority,
                                             verticalFittingPriority: verticalPriority)
        return self
    }
}

/// UIView subclass, that can be loaded into different xib or storyboard by simply referencing it's class.
open class DbLoadableView: UIView, DbNibLoadableProtocol {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    open func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}

/// UITableViewCell subclass, which subview can be used as a container to loadable view. By default, xib with the same name is loaded and added as a subview to cell's contentView.
open class DbLoadableTableViewCell: UITableViewCell, DbNibLoadableProtocol {
    open override var nibContainerView: UIView {
        return contentView
    }
    
    #if swift(>=4.2)
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupNib()
    }
    #else
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNib()
    }
    #endif
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    open func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}

/// UICollectionReusableView subclass, which subview can be used as a container to loadable view. By default, xib with the same name is loaded and added as a subview.
open class DbLoadableCollectionReusableView: UICollectionReusableView, DbNibLoadableProtocol {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    open func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}

/// UICollectionViewCell subclass, which subview can be used as a container to loadable view. By default, xib with the same name is loaded and added as a subview to cell's contentView.
open class DbLoadableCollectionViewCell: UICollectionViewCell, DbNibLoadableProtocol {
    open override var nibContainerView: UIView {
        return contentView
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    open func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}

/// UITextField subclass, which subview can be used as a container to loadable view. By default, xib with the same name is loaded and added as a subview.
open class DbLoadableTextField: UITextField, DbNibLoadableProtocol {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    open func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}

open class DbLoadableControl: UIControl, DbNibLoadableProtocol {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    open func setupNib() {
        setupView(loadNib(), inContainer: nibContainerView)
    }
}



/// UIView subclass, that can be loaded into different xib or storyboard by simply referencing it's class.
// -- DucBui (22/01/2018) : Use for popup control --
open class DbLoadablePopupView: UIView, DbNibLoadableProtocol {

    private var contentView: UIView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }

    open func setupNib() {
        // -- Khong dung thang nay --
        // -- Khi su dung thang nay, khong resize subview duoc --
        // setupView(loadNib(), inContainer: nibContainerView)

        backgroundColor = UIColor.clear
        contentView = loadNib()
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
}
