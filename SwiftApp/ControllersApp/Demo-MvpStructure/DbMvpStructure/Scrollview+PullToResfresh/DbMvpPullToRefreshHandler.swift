//
//  DbMvpPullToRefreshHandler.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

open class DbMvpPullToRefreshHandler: NSObject
{
    let presenter: DbMvpPullToRefreshPresenter
    let refreshControl = UIRefreshControl()
    
    public init(presenter: DbMvpPullToRefreshPresenter)
    {
        self.presenter = presenter
        super.init()
    }
    
    open func addTo(scrollView: UIScrollView)
    {
        refreshControl.addTarget(self, action: .refresh, for: .valueChanged)
        scrollView.addSubview(refreshControl)
        scrollView.alwaysBounceVertical = true
    }
    
    open func remove()
    {
        refreshControl.removeTarget(self, action: .refresh, for: .valueChanged)
        refreshControl.removeFromSuperview()
    }
    
    open func endRefreshing()
    {
        self.refreshControl.endRefreshing()
    }
    
    open func beginRefreshing(_ scrollView: UIScrollView)
    {
        scrollView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        self.refreshControl.beginRefreshing()
    }
    
    @objc func refresh(refreshControl: UIRefreshControl)
    {
        presenter.didStartRefreshing()
    }
}

private extension Selector
{
    static let refresh = #selector(DbMvpPullToRefreshHandler.refresh(refreshControl:))
}
