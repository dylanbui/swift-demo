//
//  CustomFullLoadView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/26/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

/**
 Delegate for KRPullLoadView.
 */
public protocol CustomPullLoadViewDelegate: class {
    /**
     Handler when KRPullLoaderState value changed.
     
     - parameter pullLoadView: KRPullLoadView.
     - parameter state:        New state.
     - parameter type:         KRPullLoaderType.
     */
    func pullLoadView(_ pullLoadView: CustomPullLoadView, didChangeState state: DbPullLoaderState, viewType type: DbPullLoaderType)
}


public enum CustomPullLoadViewScreen: String {
    case none
    case listing
    case notification
    case house
    
}

public class CustomPullLoadView: UIView {
    
    public var state = DbPullLoaderState.none
    public var forScreen = CustomPullLoadViewScreen.none
    
    private var startLoading: (() -> Void)?
    //public var stopLoading: (() -> Void)?
    
    private lazy var oneTimeSetUp: Void = { self.setUp() }()
    
    public let activityIndicator = UIActivityIndicatorView()
    public let messageLabel = UILabel()
    
    open weak var delegate: CustomPullLoadViewDelegate?
    
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
    
    // MARK: - KRPullLoadable --------------
    
    func startLoading(_ start: @escaping () -> Void)
    {
        self.startLoading = start
    }
    
    func stopLoading(_ stop: (() -> Void)? = nil)
    {
        switch self.state {
        case .none: break
        case .pulling: break
        case let .loading(completionHandler):
            // -- Set last update --
            UserDefaults.setObject(key: forScreen.rawValue, value: Date())
            
            completionHandler()
            stop?()
        }
    }
}

// MARK: - KRPullLoadable actions -------------------

extension CustomPullLoadView: DbPullLoadable
{
    public func didChangeState(_ state: DbPullLoaderState, viewType type: DbPullLoaderType)
    {
        self.state = state
        
        if delegate != nil {
            delegate?.pullLoadView(self, didChangeState: state, viewType: type)
            return
        }
        
        if type == .loadMore {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
                self.startLoading?()
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            self.messageLabel.text = ""
            
        case .pulling:
            var lastUpdate: Date = Date()
            if let date = UserDefaults.getObject(key: forScreen.rawValue) as? Date {
                lastUpdate = date
            }
            self.messageLabel.text = "Last Update: " + lastUpdate.db_string(withFormat: "yyyy-MM-dd HH:mm:ss")
            
//        case let .pulling(offset, threshould):
//            if offset.y > threshould {
//                self.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
//            } else {
//                self.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
//            }
            
        case .loading:
            activityIndicator.startAnimating()
            self.startLoading?()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
//                completionHandler()
//                if let tableView = self.superview?.superview as? UITableView {
//                    tableView.reloadData()
//                }
//            }
        }
    }
}
