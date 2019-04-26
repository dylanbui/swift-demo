//
//  UIScrollViewExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/26/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

private var pullToRefreshViewKey: Void?

public typealias ActionHandler = () -> ()

fileprivate struct Constants {
    
    static let pullToRefreshViewValueKey = "DbPullToRefreshView"
    
}

extension UIScrollView {
    
    
    
    public var pullToRefreshView: Any? {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) // as? Any
        }
        set(newValue) {
            willChangeValue(forKey: Constants.pullToRefreshViewValueKey)
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: Constants.pullToRefreshViewValueKey)
        }
    }
    
    public func addPullToHandlerView<T :DbPullLoadable>(viewType: T.Type, type: DbPullLoaderType = .refresh, _ actionHandler: @escaping ActionHandler){
        if type == .refresh {
            if pullToRefreshView == nil {
                self.pullToRefreshView = viewType.init()
                // self.pullToRefreshView = T()
                self.addPullLoadableView(pullToRefreshView!, type: .refresh)
                
                // -- Load refresh --
                pullToRefreshView?.startLoading {
                    actionHandler()
                }
            }
        }
    }
    
//    func stopPullToHandlerView(type: DbPullLoaderType = .refresh)
//    {
//        if type == .refresh {
//            if pullToRefreshView != nil {
//                pullToRefreshView?.stopLoading()
//            }
//        } else if type == .loadMore {
//            if pullToLoadMoreView != nil {
//                pullToLoadMoreView?.stopLoading()
//            }
//        }
//    }
//
//    func removePullToHandlerView(type: KRPullLoaderType = .refresh)
//    {
//        if type == .refresh {
//            if pullToRefreshView != nil {
//                self.removePullLoadableView(pullToRefreshView!)
//            }
//        } else if type == .loadMore {
//            if pullToLoadMoreView != nil {
//                self.removePullLoadableView(pullToLoadMoreView!)
//            }
//        }
//    }
}
