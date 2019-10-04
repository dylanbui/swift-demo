//
//  DbMvpView.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpViewAction: class
{
    
}

public protocol DbMvpLoadingViewAction: DbMvpViewAction
{
    var loadingView: UIView { get }
    var containerLoadingView: UIView { get }
    
    func showLoader()
    func hideLoader()
}

public extension DbMvpLoadingViewAction
{
    func showLoader()
    {
        guard !containerLoadingView.subviews.contains(loadingView) else
        {
            return
        }
        
        loadingView.isHidden = false
        loadingView.bounds = UIScreen.main.bounds //Db.screenHeight() containerLoadingView.bounds
        loadingView.backgroundColor = UIColor.yellow
        loadingView.autoresizingMask = [
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin
        ]
        
        containerLoadingView.addSubview(loadingView)
        containerLoadingView.bringSubview(toFront: loadingView)
    }
    
    func hideLoader()
    {
        loadingView.removeFromSuperview()
        loadingView.isHidden = true
    }
}
