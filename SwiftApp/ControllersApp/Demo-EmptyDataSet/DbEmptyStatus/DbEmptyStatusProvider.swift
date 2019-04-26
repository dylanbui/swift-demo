//
//  DbEmptyStatusProvider.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/13/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Base on v1.2.10 : https://github.com/mariohahn/StatusProvider

import Foundation
import UIKit

public protocol DbEmptyStatusModel {
    var verticalOffset: CGFloat { get }
    var isLoading: Bool         { get }
    var spinnerColor: UIColor   { get }
    var backgroundColor: UIColor{ get }
    var title: String?          { get }
    var description: String?    { get }
    var actionTitle: String?    { get }
    var image: UIImage?         { get }
    var action: (() -> Void)?   { get }
}

extension DbEmptyStatusModel {
    
    public var verticalOffset: CGFloat {
        return 0.0
    }
    
    public var isLoading: Bool {
        return false
    }
    
    public var spinnerColor: UIColor {
        return UIColor.lightGray
    }

    public var backgroundColor: UIColor {
        return UIColor.white
    }
    
    public var title: String? {
        return nil
    }
    
    public var description: String? {
        return nil
    }
    
    public var actionTitle: String? {
        return nil
    }
    
    public var image: UIImage? {
        return nil
    }
    
    public var action: (() -> Void)? {
        return nil
    }
    
}

public struct DbEmptyStatus: DbEmptyStatusModel {
    public let verticalOffset: CGFloat
    public let isLoading: Bool
    public let spinnerColor: UIColor
    public let backgroundColor: UIColor
    public let title: String?
    public let description: String?
    public let actionTitle: String?
    public let image: UIImage?
    public let action: (() -> Void)?
    
    public init(isLoading: Bool = false,
                spinnerColor: UIColor = UIColor.lightGray,
                backgroundColor: UIColor = UIColor.white,
                title: String? = nil,
                description: String? = nil,
                actionTitle: String? = nil,
                image: UIImage? = nil,
                verticalOffset: CGFloat = 0.0,
                action: (() -> Void)? = nil) {
        self.isLoading = isLoading
        self.spinnerColor = spinnerColor
        self.backgroundColor = backgroundColor
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.image = image
        self.action = action
        self.verticalOffset = verticalOffset
    }
    
    public static var simpleLoading: DbEmptyStatus {
        return DbEmptyStatus(isLoading: true, verticalOffset: 150)
    }
}

// -- Display empty status view --
public protocol DbEmptyStatusView: class {
    var status: DbEmptyStatusModel?  { set get }
    var view: UIView { get }
}

public protocol DbEmptyStatusController {
    var onView: UIView { get }
    var statusView: DbEmptyStatusView?     { get }
    
    func show(emptyStatus: DbEmptyStatusModel)
    func hideEmptyStatus()
}

fileprivate let dbStatusViewTag = 666

extension DbEmptyStatusController {
    
    public var statusView: DbEmptyStatusView? {
        return DbEmptyDefaultStatusView()
    }
    
    public func hideEmptyStatus() {
        if let view = onView.viewWithTag(dbStatusViewTag) {
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 0.0
            }) { (finished) in
                view.removeFromSuperview()
            }
        }
    }
    
    fileprivate func _show(status: DbEmptyStatusModel) {
        guard let sv = statusView else { return }
        sv.status = status
        
        let containerView: UIView = onView
        // -- Remove DbEmptyStatus View if have --
        containerView.viewWithTag(dbStatusViewTag)?.removeFromSuperview()
        
        let view = sv.view
        
        let parentView = UIView.init(frame: containerView.frame)
        parentView.tag = dbStatusViewTag
        parentView.backgroundColor = sv.status?.backgroundColor
        containerView.addSubview(parentView)
        parentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            parentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            parentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            parentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            ])
        
        parentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if status.verticalOffset != 0.0 {
            
            // -- DucBui 26/04/2019 : Kiem tra navigationbar size --
            var offset = status.verticalOffset
            if let viewController = self as? UIViewController {
                if viewController.navigationController != nil {
                    offset += 64 // navigationBar
                }
            }
            
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: offset) // Cach top 150 chua bao gom navigation bar
                ])
            
        } else {
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: parentView.centerYAnchor), // Canh giua
                ])
        }
    }
}


extension DbEmptyStatusController where Self: UIView {
    
    public var onView: UIView {
        return self
    }
    
    public func show(emptyStatus: DbEmptyStatusModel) {
        _show(status: emptyStatus)
    }
}

extension DbEmptyStatusController where Self: UIViewController {
    
    public var onView: UIView {
        return view
    }
    
    public func show(emptyStatus: DbEmptyStatusModel) {
        _show(status: emptyStatus)
    }
}

extension DbEmptyStatusController where Self: UITableViewController {
    
    public var onView: UIView {
        if let backgroundView = tableView.backgroundView {
            return backgroundView
        }
        return view
    }
    
    public func show(emptyStatus: DbEmptyStatusModel) {
        _show(status: emptyStatus)
    }
}
