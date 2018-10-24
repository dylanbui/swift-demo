//
//  File.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://github.com/muukii/StackScrollView (1.2.0)

import UIKit

open class DbStackScrollView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private enum LayoutKeys {
        static let top = "me.muukii.DbStackScrollView.top"
        static let right = "me.muukii.DbStackScrollView.right"
        static let left = "me.muukii.DbStackScrollView.left"
        static let bottom = "me.muukii.DbStackScrollView.bottom"
        static let width = "me.muukii.DbStackScrollView.width"
    }
    
    private static func defaultLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return layout
    }
    
    @available(*, unavailable)
    open override var dataSource: UICollectionViewDataSource? {
        didSet {
        }
    }
    
    @available(*, unavailable)
    open override var delegate: UICollectionViewDelegate? {
        didSet {
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    public convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: DbStackScrollView.defaultLayout())
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private(set) public var views: [UIView] = []
    
    private func identifier(_ v: UIView) -> String {
        return v.hashValue.description
    }
    
    private func setup() {
        
        backgroundColor = .white
        
        alwaysBounceVertical = true
        delaysContentTouches = false
        keyboardDismissMode = .interactive
        backgroundColor = .clear
        
        super.delegate = self
        super.dataSource = self
    }
    
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
    
    open func append(view: UIView) {
        
        views.append(view)
        register(Cell.self, forCellWithReuseIdentifier: identifier(view))
        reloadData()
    }
    
    open func append(views _views: [UIView]) {
        
        views += _views
        _views.forEach { view in
            register(Cell.self, forCellWithReuseIdentifier: identifier(view))
        }
        reloadData()
    }
    
    @available(*, unavailable, message: "Unimplemented")
    func append(lazy: @escaping () -> UIView) {
        
    }
    
    open func remove(view: UIView, animated: Bool) {
        
        if let index = views.index(of: view) {
            views.remove(at: index)
            if animated {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 0,
                    options: [
                        .beginFromCurrentState,
                        .allowUserInteraction,
                        .overrideInheritedCurve,
                        .overrideInheritedOptions,
                        .overrideInheritedDuration
                    ],
                    animations: {
                        self.performBatchUpdates({
                            self.deleteItems(at: [IndexPath(item: index, section: 0)])
                        }, completion: nil)
                }) { (finish) in
                    
                }
                
            } else {
                UIView.performWithoutAnimation {
                    performBatchUpdates({
                        self.deleteItems(at: [IndexPath(item: index, section: 0)])
                    }, completion: nil)
                }
            }
        }
    }
    
    open func scroll(to view: UIView, animated: Bool) {
        
        let targetRect = view.convert(view.bounds, to: self)
        scrollRectToVisible(targetRect, animated: true)
    }
    
    open func scroll(to view: UIView, at position: UICollectionViewScrollPosition, animated: Bool) {
        if let index = views.index(of: view) {
            scrollToItem(at: IndexPath(item: index, section: 0), at: position, animated: animated)
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let view = views[indexPath.item]
        let _identifier = identifier(view)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _identifier, for: indexPath)
        
        if view.superview == cell.contentView {
            return cell
        }
        
        precondition(cell.contentView.subviews.isEmpty)
        
        if view is ManualLayoutDbStackCellType {
            
            cell.contentView.addSubview(view)
            
        } else {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            cell.contentView.addSubview(view)
            
            let top = view.topAnchor.constraint(equalTo: cell.contentView.topAnchor)
            let right = view.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor)
            let bottom = view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            let left = view.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor)
            
            top.identifier = LayoutKeys.top
            right.identifier = LayoutKeys.right
            bottom.identifier = LayoutKeys.bottom
            left.identifier = LayoutKeys.left
            
            NSLayoutConstraint.activate([
                top,
                right,
                bottom,
                left,
                ])
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let view = views[indexPath.item]
        
        if let view = view as? ManualLayoutDbStackCellType {
            
            return view.size(maxWidth: collectionView.bounds.width, maxHeight: nil)
            
        } else {
            
            let width: NSLayoutConstraint = {
                
                guard let c = view.constraints.filter({ $0.identifier == LayoutKeys.width }).first else {
                    let width = view.widthAnchor.constraint(equalToConstant: collectionView.bounds.width)
                    width.identifier = LayoutKeys.width
                    width.isActive = true
                    return width
                }
                
                return c
            }()
            
            width.constant = collectionView.bounds.width
            
            let size = view.superview?.systemLayoutSizeFitting(UILayoutFittingCompressedSize) ?? view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            
            assert(size.width == collectionView.bounds.width)
            return size
            
        }
    }
    
    public func updateLayout(animated: Bool) {
        
        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [
                    .beginFromCurrentState,
                    .allowUserInteraction,
                    .overrideInheritedCurve,
                    .overrideInheritedOptions,
                    .overrideInheritedDuration
                ],
                animations: {
                    self.performBatchUpdates(nil, completion: nil)
                    self.layoutIfNeeded()
            }) { (finish) in
                
            }
        } else {
            UIView.performWithoutAnimation {
                self.performBatchUpdates(nil, completion: nil)
                self.layoutIfNeeded()
            }
        }
    }
    
    final class Cell: UICollectionViewCell {
        
        override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            return layoutAttributes
        }
    }
}

