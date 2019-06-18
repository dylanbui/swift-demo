//
//  DbEmptyStatusProvider.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/13/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Base on v1.2.10 : https://github.com/mariohahn/StatusProvider
//  Rename function in protocol DbEmptyStatusController

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
    public var verticalOffset: CGFloat
    public var isLoading: Bool
    public var spinnerColor: UIColor
    public var backgroundColor: UIColor
    public var title: String?
    public var description: String?
    public var actionTitle: String?
    public var image: UIImage?
    public var action: (() -> Void)?
    
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
        return DbEmptyStatus(isLoading: true, verticalOffset: 50)
    }
}

// -- Display empty status view --
public protocol DbEmptyStatusView: class {
    var status: DbEmptyStatusModel?  { set get }
    var view: UIView { get }
}

public protocol DbEmptyStatusController {
    var emptyStatusOnView: UIView { get }
    var emptyStatusView: DbEmptyStatusView?     { get }
    
    func showEmptyView(WithStatus: DbEmptyStatusModel)
    func hideEmptyViewStatus()
}

fileprivate let dbStatusViewTag = 666

extension DbEmptyStatusController {
    
    public var emptyStatusView: DbEmptyStatusView? {
        return DbEmptyDefaultStatusView()
    }
    
    public func hideEmptyViewStatus() {
        if let view = emptyStatusOnView.viewWithTag(dbStatusViewTag) {
            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 0.0
            }) { (finished) in
                view.removeFromSuperview()
            }
        }
    }
    
    fileprivate func _show(status: DbEmptyStatusModel) {
        guard let sv = emptyStatusView else { return }
        sv.status = status
        
        let containerView: UIView = emptyStatusOnView
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
                // -- Khong can navigationBar vi parentView nam duoi navigationBar --
                // Nen neu khong co navigationBar thi phai cong them 64
                // Neu edgesForExtendedLayout.rawValue != 0 thi UIViewController se cover toan bo man hinh
                if let nav = viewController.navigationController {
                    if nav.isNavigationBarHidden == true {
                        offset += 44 // navigationBar
                    } else if viewController.edgesForExtendedLayout.rawValue != 0 {
                        offset += 44 // navigationBar
                    }
                }
            }
            
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: offset) // Cach top 150 chua bao gom navigation bar
                ])
            
        } else {
            // -- DucBui 26/04/2019 : Kiem tra Tabbar size khi canh giua --
            var offset: CGFloat = 0.0
            // -- Kiem tra UIViewController co cover toan man hinh ko --
            // Kiem tra the nao cung khong thay dung lam, nen khong su dung
            if let viewController = self as? UIViewController {
                // -- Khong can navigationBar vi canh giua tu giua len --
                // Neu edgesForExtendedLayout.rawValue != 0 thi UIViewController se cover toan bo man hinh
                if let nav = viewController.navigationController {
                    if nav.isNavigationBarHidden == true {
                        offset -= 44 // navigationBar
                    } else if viewController.edgesForExtendedLayout.rawValue != 0 {
                        offset -= 44 // navigationBar
                    }
                }
            }            // -- Kiem tra tabbar --
            if let viewController = self as? UIViewController {
                if viewController.tabBarController != nil {
                    offset -= 49 // tabBarController
                }
            }
            
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: offset), // Canh giua
                ])
        }
    }
}


extension DbEmptyStatusController where Self: UIView {
    
    public var emptyStatusOnView: UIView {
        return self
    }
    
    public func showEmptyView(WithStatus emptyStatus: DbEmptyStatusModel) {
        _show(status: emptyStatus)
    }
}

extension DbEmptyStatusController where Self: UIViewController {
    
    public var emptyStatusOnView: UIView {
        return view
    }
    
    public func showEmptyView(WithStatus emptyStatus: DbEmptyStatusModel) {
        _show(status: emptyStatus)
    }
}

extension DbEmptyStatusController where Self: UITableViewController {
    
    public var emptyStatusOnView: UIView {
        if let backgroundView = tableView.backgroundView {
            return backgroundView
        }
        return view
    }
    
    public func showEmptyView(WithStatus emptyStatus: DbEmptyStatusModel) {
        _show(status: emptyStatus)
    }
}
