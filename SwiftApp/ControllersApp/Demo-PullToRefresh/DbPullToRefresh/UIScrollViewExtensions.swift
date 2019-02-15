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
     
     - parameter loadView: view that contain KRPullLoadable.
     - parameter type:     KRPullLoaderType. Default type is `.refresh`.
     */
    public func addPullLoadableView<T>(_ loadView: T, type: DbPullLoaderType = .refresh) where T: UIView, T: DbPullLoadable {
        let loader = DbPullLoader(loadView: loadView, type: type)
        insertSubview(loader, at: 0)
        loader.setUp()
    }
    
    /**
     Remove the PullLoadableView.
     
     - parameter loadView: view which inherited KRPullLoadable protocol.
     */
    public func removePullLoadableView<T>(_ loadView: T) where T: UIView, T: DbPullLoadable {
        loadView.removeFromSuperview()
    }
}
