//
//  UIScrollViewExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

// MARK: - Public extensions ---------------

extension UIScrollView {
    /**
     Adds the PullLoadableView.
     
     - parameter loadView: view that contain DbPullLoadable.
     - parameter type:     DbPullLoaderType. Default type is `.refresh`.
     */
    public func addPullLoadableView<T>(_ loadView: T, type: DbPullLoaderType = .refresh) where T: UIView, T: DbPullLoadable {
        let loader = DbPullLoader(loadView: loadView, type: type)
        insertSubview(loader, at: 0)
        loader.setUp()
    }
    
    /**
     Remove the PullLoadableView.
     
     - parameter loadView: view which inherited DbPullLoadable protocol.
     */
    public func removePullLoadableView<T>(_ loadView: T) where T: UIView, T: DbPullLoadable {
        loadView.removeFromSuperview()
    }
}

// MARK: - Internal extensions ---------------

extension UIScrollView {
    var distanceOffset: CGPoint {
        get {
            return CGPoint(
                x: contentOffset.x + contentInset.left,
                y: contentOffset.y + contentInset.top
            )
        }
        set {
            contentOffset = CGPoint(
                x: newValue.x - contentInset.left,
                y: newValue.y - contentInset.top
            )
        }
    }
    
    var distanceEndOffset: CGPoint {
        get {
            return CGPoint(
                x: (contentSize.width + contentInset.right) - (contentOffset.x + bounds.width),
                y: (contentSize.height + contentInset.bottom) - (contentOffset.y + bounds.height)
            )
        }
        set {
            contentOffset = CGPoint(
                x: newValue.x - (bounds.width - (contentSize.width + contentInset.right)),
                y: newValue.y - (bounds.height - (contentSize.height + contentInset.bottom))
            )
        }
    }
}
