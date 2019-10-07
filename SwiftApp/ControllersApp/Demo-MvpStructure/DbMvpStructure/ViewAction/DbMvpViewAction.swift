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
    // -- Dat trung ten voi func in DbViewController --
    func setNavigationTitleWithAnimation(_ title: String)
    
    // -- Optional functions --
    func setNavigationTitle(_ title: String)
}

public extension DbMvpViewAction
{
    func setNavigationTitle(_ title: String) {}
}

public protocol DbMvpLoadingViewAction: DbMvpViewAction
{
    var loadingView: UIView { get }
    var containerLoadingView: UIView { get }
    
    // -- Optional functions --
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
