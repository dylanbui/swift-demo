//
//  DbEmptyDataSet.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit


public extension UIScrollView {
    // MARK: - Properties
    public var db_emptyDataSetDataSource: DbEmptyDataSetDataSource? {
        get {
            let container = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource) as? WeakObjectContainer
            return container?.object as? DbEmptyDataSetDataSource
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDataSource, WeakObjectContainer(object: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                switch self {
                case is UITableView:
                    UITableView.tb_swizzleTableViewReloadData
                    UITableView.tb_swizzleTableViewEndUpdates
                    if #available(iOS 11.0, *) {
                        UITableView.tb_swizzleTableViewPerformBatchUpdates
                    }
                case is UICollectionView:
                    UICollectionView.tb_swizzleCollectionViewReloadData
                    UICollectionView.tb_swizzleCollectionViewPerformBatchUpdates
                default:
                    break
                }
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }
    
    public var db_emptyDataSetDelegate: DbEmptyDataSetDelegate? {
        get {
            let container = objc_getAssociatedObject(self, &AssociatedKeys.emptyDataSetDelegate) as? WeakObjectContainer
            return container?.object as? DbEmptyDataSetDelegate
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyDataSetDelegate, WeakObjectContainer(object: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                handlingInvalidEmptyDataSet()
            }
        }
    }
    
    internal var db_emptyDataView: DbEmptyDataView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyDataView) as? DbEmptyDataView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyDataView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Public
    public var db_emptyDataViewVisible: Bool {
        if let emptyDataView = db_emptyDataView {
            return !emptyDataView.isHidden
        }
        return false
    }
    
    public func updateEmptyDataSetIfNeeded() {
        reloadEmptyDataSet()
    }
    
    // MARK: - Data source and delegate getters
    fileprivate func emptyDataSetImage() -> UIImage? {
        return db_emptyDataSetDataSource?.db_imageForEmptyDataSet(in: self)
    }
    
    fileprivate func emptyDataSetTitle() -> NSAttributedString? {
        return db_emptyDataSetDataSource?.db_titleForEmptyDataSet(in: self)
    }
    
    fileprivate func emptyDataSetDescription() -> NSAttributedString? {
        return db_emptyDataSetDataSource?.db_descriptionForEmptyDataSet(in: self)
    }
    
    fileprivate func emptyDataSetImageTintColor() -> UIColor? {
        return db_emptyDataSetDataSource?.db_imageTintColorForEmptyDataSet(in: self)
    }
    
    fileprivate func emptyDataSetBackgroundColor() -> UIColor? {
        return db_emptyDataSetDataSource?.db_backgroundColorForEmptyDataSet(in: self)
    }
    
    fileprivate func emptyDataSetVerticalOffset() -> CGFloat {
        return db_emptyDataSetDataSource?.db_verticalOffsetForEmptyDataSet(in: self) ?? DefaultValues.verticalOffset
    }
    
    fileprivate func emptyDataSetVerticalSpaces() -> [CGFloat] {
        return db_emptyDataSetDataSource?.db_verticalSpacesForEmptyDataSet(in: self) ?? DefaultValues.verticalSpaces
    }
    
    fileprivate func emptyDataSetTitleMargin() -> CGFloat {
        return db_emptyDataSetDataSource?.db_titleMarginForEmptyDataSet(in: self) ?? DefaultValues.titleMargin
    }
    
    fileprivate func emptyDataSetDescriptionMargin() -> CGFloat {
        return db_emptyDataSetDataSource?.db_descriptionMarginForEmptyDataSet(in: self) ?? DefaultValues.descriptionMargin
    }
    
    fileprivate func emptyDataSetCustomView() -> UIView? {
        return db_emptyDataSetDataSource?.db_customViewForEmptyDataSet(in: self)
    }
    
    fileprivate func emptyDataSetShouldDisplay() -> Bool {
        return db_emptyDataSetDelegate?.db_emptyDataSetShouldDisplay(in: self) ?? true
    }
    
    fileprivate func emptyDataSetTapEnabled() -> Bool {
        return db_emptyDataSetDelegate?.db_emptyDataSetTapEnabled(in: self) ?? true
    }
    
    fileprivate func emptyDataSetScrollEnabled() -> Bool {
        return db_emptyDataSetDelegate?.db_emptyDataSetScrollEnabled(in: self) ?? false
    }
    
    // MARK: - Helper
    @objc func didTapEmptyDataView(_ sender: Any) {
        db_emptyDataSetDelegate?.db_emptyDataSetDidTapEmptyView(in: self)
    }
    
    fileprivate func makeEmptyDataView() -> DbEmptyDataView {
        let emptyDataView = DbEmptyDataView(frame: frame)
        emptyDataView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        emptyDataView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEmptyDataView(_:)))
        emptyDataView.addGestureRecognizer(tapGesture)
        emptyDataView.tapGesture = tapGesture
        return emptyDataView
    }
    
    fileprivate func emptyDataSetAvailable() -> Bool {
        if db_emptyDataSetDataSource != nil {
            return (self is UITableView) || (self is UICollectionView)
        }
        return false
    }
    
    fileprivate func cellsCount() -> Int {
        var count = 0
        if let tableView = self as? UITableView {
            if let dataSource = tableView.dataSource {
                if dataSource.responds(to: TableViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSections?(in: tableView) ?? 0
                    for section in 0..<sections {
                        count += dataSource.tableView(tableView, numberOfRowsInSection: section)
                    }
                }
            }
        } else if let collectionView = self as? UICollectionView {
            if let dataSource = collectionView.dataSource {
                if dataSource.responds(to: CollectionViewSelectors.numberOfSections) {
                    let sections = dataSource.numberOfSections?(in: collectionView) ?? 0
                    for section in 0..<sections {
                        count += dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                    }
                }
            }
        }
        
        return count
    }
    
    fileprivate func handlingInvalidEmptyDataSet() {
        db_emptyDataSetDelegate?.db_emptyDataSetWillDisappear(in: self)
        
        db_emptyDataView?.reset()
        db_emptyDataView?.removeFromSuperview()
        db_emptyDataView = nil
        isScrollEnabled = true
        
        db_emptyDataSetDelegate?.db_emptyDataSetDidDisappear(in: self)
    }
    
    // MARK: - Display
    fileprivate func reloadEmptyDataSet() {
        guard emptyDataSetAvailable() else {
            return
        }
        
        guard emptyDataSetShouldDisplay() && cellsCount() == 0 else {
            if db_emptyDataViewVisible {
                handlingInvalidEmptyDataSet()
            }
            return
        }
        
        let emptyDataView: DbEmptyDataView = {
            if let emptyDataView = self.db_emptyDataView {
                return emptyDataView
            } else {
                let emptyDataView = makeEmptyDataView()
                self.db_emptyDataView = emptyDataView
                return emptyDataView
            }
        }()
        db_emptyDataSetDelegate?.db_emptyDataSetWillAppear(in: self)
        
        if emptyDataView.superview == nil {
            if (self is UITableView || self is UICollectionView) && subviews.count > 1 {
                insertSubview(emptyDataView, at: 0)
            } else {
                addSubview(emptyDataView)
            }
        }
        
        emptyDataView.prepareForDisplay()
        
        emptyDataView.verticalOffset = emptyDataSetVerticalOffset()
        emptyDataView.verticalSpaces = emptyDataSetVerticalSpaces()
        emptyDataView.titleMargin = emptyDataSetTitleMargin()
        emptyDataView.descriptionMargin = emptyDataSetDescriptionMargin()
        
        if let customView = emptyDataSetCustomView() {
            emptyDataView.customView = customView
        } else {
            if let imageTintColor = emptyDataSetImageTintColor() {
                emptyDataView.imageView.image = emptyDataSetImage()?.withRenderingMode(.alwaysTemplate)
                emptyDataView.imageView.tintColor = imageTintColor
            } else {
                emptyDataView.imageView.image = emptyDataSetImage()?.withRenderingMode(.alwaysOriginal)
            }
            
            emptyDataView.titleLabel.attributedText = emptyDataSetTitle()
            emptyDataView.descriptionLabel.attributedText = emptyDataSetDescription()
        }
        
        emptyDataView.backgroundColor = emptyDataSetBackgroundColor()
        emptyDataView.isHidden = false
        emptyDataView.clipsToBounds = true
        emptyDataView.tapGesture?.isEnabled = emptyDataSetTapEnabled()
        isScrollEnabled = emptyDataSetScrollEnabled()
        
        emptyDataView.setConstraints()
        emptyDataView.layoutIfNeeded()
        
        db_emptyDataSetDelegate?.db_emptyDataSetDidAppear(in: self)
    }
    
    // MARK: - Method swizzling
    fileprivate class func tb_swizzleMethod(for aClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(aClass, originalSelector), let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector) else {
            return
        }
        
        let didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleTableViewReloadData: () = {
        let originalSelector = TableViewSelectors.reloadData
        let swizzledSelector = Selectors.tableViewSwizzledReloadData
        
        tb_swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleTableViewEndUpdates: () = {
        let originalSelector = TableViewSelectors.endUpdates
        let swizzledSelector = Selectors.tableViewSwizzledEndUpdates
        
        tb_swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    // swiftlint:disable variable_name
    @available(iOS 11.0, *)
    fileprivate static let tb_swizzleTableViewPerformBatchUpdates: () = {
        let originalSelector = TableViewSelectors.performBatchUpdates
        let swizzledSelector = Selectors.tableViewSwizzledPerformBatchUpdates
        
        tb_swizzleMethod(for: UITableView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleCollectionViewReloadData: () = {
        let originalSelector = CollectionViewSelectors.reloadData
        let swizzledSelector = Selectors.collectionViewSwizzledReloadData
        
        tb_swizzleMethod(for: UICollectionView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    // swiftlint:disable variable_name
    fileprivate static let tb_swizzleCollectionViewPerformBatchUpdates: () = {
        let originalSelector = CollectionViewSelectors.performBatchUpdates
        let swizzledSelector = Selectors.collectionViewSwizzledPerformBatchUpdates
        
        tb_swizzleMethod(for: UICollectionView.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()
    
    @objc
    func tb_tableViewSwizzledReloadData() {
        tb_tableViewSwizzledReloadData()
        reloadEmptyDataSet()
    }
    
    @objc
    func tb_tableViewSwizzledEndUpdates() {
        tb_tableViewSwizzledEndUpdates()
        reloadEmptyDataSet()
    }
    
    @available(iOS 11.0, *)
    @objc
    func tb_tableViewSwizzledPerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        tb_tableViewSwizzledPerformBatchUpdates(updates) { [weak self](completed) in
            completion?(completed)
            self?.reloadEmptyDataSet()
        }
    }
    
    @objc
    func tb_collectionViewSwizzledReloadData() {
        tb_collectionViewSwizzledReloadData()
        reloadEmptyDataSet()
    }
    
    @objc
    func tb_collectionViewSwizzledPerformBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?) {
        tb_collectionViewSwizzledPerformBatchUpdates(updates) { [weak self](completed) in
            completion?(completed)
            self?.reloadEmptyDataSet()
        }
    }
}
