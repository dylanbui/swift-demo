//
//  UIScrollViewExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/26/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

private var pullToRefreshViewKey: Void?
private var pullToLoadMoreViewKey: Void?

public typealias ActionHandler = () -> ()

fileprivate struct Constants {
    
    static let pullToRefreshViewValueKey = "DbPullToRefreshView"
    static let pullToLoadMoreViewValueKey = "DbPullToLoadMoreView"
    
}

extension UIScrollView {
    
    private var pullToRefreshView: CustomPullLoadView? {
        get {
            return objc_getAssociatedObject(self, &pullToRefreshViewKey) as? CustomPullLoadView
        }
        set(newValue) {
            willChangeValue(forKey: Constants.pullToRefreshViewValueKey)
            objc_setAssociatedObject(self, &pullToRefreshViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: Constants.pullToRefreshViewValueKey)
        }
    }
    
    private var pullToLoadMoreView: CustomPullLoadView? {
        get {
            return objc_getAssociatedObject(self, &pullToLoadMoreViewKey) as? CustomPullLoadView
        }
        set(newValue) {
            willChangeValue(forKey: Constants.pullToLoadMoreViewValueKey)
            objc_setAssociatedObject(self, &pullToLoadMoreViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            didChangeValue(forKey: Constants.pullToLoadMoreViewValueKey)
        }
    }
    
    //public func db_addPullToHandlerView(type: DbPullLoaderType = .refresh, _ actionHandler: @escaping ActionHandler)
    public func db_addPullToHandlerView(type: DbPullLoaderType = .refresh,
                                        forScreen screen: CustomPullLoadViewScreen = .none,
                                        _ actionHandler: @escaping ActionHandler)
    {
        if type == .refresh {
            if pullToRefreshView == nil {
                pullToRefreshView = CustomPullLoadView()
                pullToRefreshView?.forScreen = screen
                self.addPullLoadableView(pullToRefreshView!, type: .refresh)
                
                // -- Load refresh --
                pullToRefreshView?.startLoading {
                    actionHandler()
                }
            }
        } else if type == .loadMore {
            if pullToLoadMoreView == nil {
                pullToLoadMoreView = CustomPullLoadView()
                pullToLoadMoreView?.forScreen = screen
                self.addPullLoadableView(pullToLoadMoreView!, type: .loadMore)
                
                // -- Load more --
                pullToLoadMoreView?.startLoading {
                    actionHandler()
                }
            }
        }
    }
    
    public func db_stopPullToHandlerView(type: DbPullLoaderType = .refresh)
    {
        if type == .refresh {
            if pullToRefreshView != nil {
                pullToRefreshView?.stopLoading()
            }
        } else if type == .loadMore {
            if pullToLoadMoreView != nil {
                pullToLoadMoreView?.stopLoading()
            }
        }
    }
    
    public func db_removePullToHandlerView(type: DbPullLoaderType = .refresh)
    {
        if type == .refresh {
            if pullToRefreshView != nil {
                self.removePullLoadableView(pullToRefreshView!)
            }
        } else if type == .loadMore {
            if pullToLoadMoreView != nil {
                self.removePullLoadableView(pullToLoadMoreView!)
            }
        }
    }
}
