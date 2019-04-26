//
//  DbPullLoadView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

/**
 Delegate for DbPullLoadView.
 */
public protocol DbPullLoadViewDelegate: class {
    /**
     Handler when DbPullLoaderState value changed.
     
     - parameter pullLoadView: DbPullLoadView.
     - parameter state:        New state.
     - parameter type:         DbPullLoaderType.
     */
    func pullLoadView(_ pullLoadView: DbPullLoadView, didChangeState state: DbPullLoaderState, viewType type: DbPullLoaderType)
}

/**
 Simple view which inherited DbPullLoadable protocol.
 This has only activity indicator and message label.
 */
open class DbPullLoadView: UIView, DbPullLoadable {
    
    private lazy var oneTimeSetUp: Void = { self.setUp() }()
    
    public let activityIndicator = UIActivityIndicatorView()
    public let messageLabel = UILabel()
    
    open weak var delegate: DbPullLoadViewDelegate?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        _ = oneTimeSetUp
    }
    
    // MARK: - Set up --------------
    
    open func setUp() {
        backgroundColor = .clear
        
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        messageLabel.font = .systemFont(ofSize: 10)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageLabel)
        
        addConstraints([
            NSLayoutConstraint(item: activityIndicator, attribute: .top, toItem: self, constant: 15.0),
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, toItem: self),
            NSLayoutConstraint(item: messageLabel, attribute: .top, toItem: self, constant: 40.0),
            NSLayoutConstraint(item: messageLabel, attribute: .centerX, toItem: self),
            NSLayoutConstraint(item: messageLabel, attribute: .bottom, toItem: self, constant: -15.0)
            ])
        
        messageLabel.addConstraint(
            NSLayoutConstraint(item: messageLabel, attribute: .width, relatedBy: .lessThanOrEqual, constant: 300)
        )
    }
    
    // MARK: - DbPullLoadable --------------
    
    open func didChangeState(_ state: DbPullLoaderState, viewType type: DbPullLoaderType) {
        switch state {
        case .none:
            activityIndicator.stopAnimating()
            
        case .pulling:
            break
            
        case .loading:
            activityIndicator.startAnimating()
        }
        delegate?.pullLoadView(self, didChangeState: state, viewType: type)
    }
}
