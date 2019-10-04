//
//  MvpLoadingView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

@IBDesignable
open class MvpLoadingView: DbLoadableView
{
    @IBOutlet open weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet open weak var loadingLabel: UILabel!

    @IBInspectable open var color: UIColor? = nil {
        didSet {
                activityIndicator.color = color
                loadingLabel.textColor = color
        }
    }
}
