//
//  DbDropDownView.swift
//  SearchTextField
//
//  Created by Dylan Bui on 10/29/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension UIView {
    
    var firstViewController: UIViewController? {
        let firstViewController = sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
    
}

public class DbDropDownView: UITableView
{
    ////////////////////////////////////////////////////////////////////////
    // Public interface
    public var anchorView: UIView?
    
    /// Force the results list to adapt to RTL languages
    public var forceRightToLeft = false
    
    // Move the table around to customize for your layout
    public var tableYOffset: CGFloat = 0.0
    public var tableCornerRadius: CGFloat = 5.0
    /// Maximum height of the table list
    public var tableListHeight: CGFloat = 100.0
    
    // public fileprivate(set) var selectedIndex: Int?
    public var selectedIndex: Int?
    public var isShow = false // Status show, hide
    public var hideOptionsWhenSelect = true // Hide when choose
    public var hideOptionsWhenTouchOut = false // Hide when touch out
    public var animationType: DbDropDownViewAnimationType = .Default
    public var displayDirection: DbDropDownViewDirection = .TopToBottom
    
    /// Set an array of SearchTextFieldItem's to be used for suggestions
    public func dataSourceItems(_ items: [DbDropDownViewItem]) {
        dataSourceItems = items
    }
    
    /// Set an array of strings to be used for suggestions
    public func dataSourceStrings(_ strings: [String]) {
        var items = [DbDropDownViewItem]()
        var count: Int = 1
        for value in strings {
            items.append(DbDropDownViewItem(id: count, title: value))
            count += 1
        }
        dataSourceItems(items)
    }
    
    /// Set your custom visual theme, or just choose between pre-defined DbSelectBoxTheme.lightTheme() and DbSelectBoxTheme.darkTheme() themes
    public var theme = DbDropDownViewTheme.darkTheme()
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    fileprivate var containerView: UIView? // Top View Add Self
    
    fileprivate var dismissableView: UIView!
    fileprivate var fontConversionRate: CGFloat = 0.7
    fileprivate static let cellIdentifier = "DbDropDownViewItem"
    fileprivate var reuseIdentifier: String?
    
    fileprivate var dataSourceItems = [DbDropDownViewItem]()
    
    // Closures
    fileprivate var privatedidSelect: ([DbDropDownViewItem], Int) -> () = {options, index in }
    fileprivate var cellConfiguration: ([DbDropDownViewItem], IndexPath, UITableViewCell) -> () = {options, index, cell  in }
    // -- Appear --
    fileprivate var privateTableWillAppear: () -> () = { }
    fileprivate var privateTableDoingAppear: () -> () = { }
    fileprivate var privateTableDidAppear: () -> () = { }
    // -- Disappear --
    fileprivate var privateTableWillDisappear: () -> () = { }
    fileprivate var privateTableDoingDisappear: () -> () = { }
    fileprivate var privateTableDidDisappear: () -> () = { }
    
    // Init
    public override init(frame: CGRect, style: UITableViewStyle)
    {
        super.init(frame: frame, style: .plain)
        setup()
    }
    
    public convenience init(withAnchorView: UIView, andFrame: CGRect = .zero)
    {
        self.init(frame: andFrame, style: .plain)
        self.anchorView = withAnchorView
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setup()
    }
    
    deinit {
        //        self.removeFromSuperview()
        //        // -- Remove temple anchor view --
        //        rootView?.viewWithTag(5001)?.removeFromSuperview()
    }
    
    // Create the filter table and shadow view
    fileprivate func setup()
    {
        self.dataSource = self
        self.delegate = self
        
        // -- Touch background --
        self.dismissableView = UIView(frame: UIScreen.main.bounds)
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToBackground(sender:)))
        // 2. add the gesture recognizer to a view
        self.dismissableView.addGestureRecognizer(tapGesture)
    }
    
    // Create the filter table and shadow view
    fileprivate func format()
    {
        self.layer.masksToBounds = true
        self.layer.borderWidth = theme.borderWidth > 0 ? theme.borderWidth : 0.5
        //self.separatorInset = UIEdgeInsets.zero // Padding left
        if forceRightToLeft {
            self.semanticContentAttribute = .forceRightToLeft
        }
        
        // Re-format Touch background frames and theme colors
        self.dismissableView.backgroundColor = theme.dismissableViewColor
        
        // Re-format frames and theme colors
        self.estimatedRowHeight = theme.cellHeight > 0 ? theme.cellHeight : UITableViewAutomaticDimension
        self.layer.borderColor = theme.borderColor.cgColor
        self.layer.cornerRadius = tableCornerRadius
        self.separatorColor = theme.separatorColor
        self.backgroundColor = theme.bgColor
        
        self.reloadData()
    }
    
    @objc fileprivate func touchToBackground(sender: UITapGestureRecognizer)
    {
        hideDropDown()
    }
    
    func registerCellNib(nib: UINib, forCellReuseIdentifier identifier: String)
    {
        self.register(nib, forCellReuseIdentifier: identifier)
        self.reuseIdentifier = identifier
    }
    
    func registerCellString(identifier: String)
    {
        self.registerCellNib(nib: UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    // Actions Methods
    public func didSelect(completion: @escaping (_ options: [DbDropDownViewItem], _ index: Int) -> ())
    {
        privatedidSelect = completion
    }
    
    public func cellConfiguration(configuration: @escaping (_ options: [DbDropDownViewItem], _ index: IndexPath, _ cell: UITableViewCell) -> ())
    {
        cellConfiguration = configuration
    }
    
    public func tableWillAppear(completion: @escaping () -> ())
    {
        privateTableWillAppear = completion
    }
    
    public func tableDoingAppear(completion: @escaping () -> ())
    {
        privateTableDoingAppear = completion
    }
    
    public func tableDidAppear(completion: @escaping () -> ())
    {
        privateTableDidAppear = completion
    }
    
    public func tableWillDisappear(completion: @escaping () -> ())
    {
        privateTableWillDisappear = completion
    }
    
    public func tableDoingDisappear(completion: @escaping () -> ())
    {
        privateTableDoingDisappear = completion
    }
    
    public func tableDidDisappear(completion: @escaping () -> ())
    {
        privateTableDidDisappear = completion
    }
    
    public func showDropDown(WithView view: UIView, BottomNavigationBarOf vcl: UIViewController)
    {
        guard let nav = vcl.navigationController else {
            fatalError("UINavigationController find not found")
        }
        
        // -- Remove old anhchor --
        if let view = vcl.view.viewWithTag(5005) {
            view.removeFromSuperview()
            self.anchorView = nil
        }
        // -- Create new anchor --
        let anchor = UIView(frame: CGRect(x: 0.0, y: nav.navigationBar.frame.origin.y + nav.navigationBar.frame.size.height
            , width: nav.navigationBar.frame.size.width, height: 0.0))
        anchor.backgroundColor = UIColor.clear
        anchor.tag = 5005
        vcl.view.addSubview(anchor)
        
        self.displayDirection = .TopToBottom
        self.anchorView = anchor
        
        self.showDropDown(WithView: view, yOffset: 0.0)
    }
    
    public func showDropDown(WithView view: UIView, yOffset offset: CGFloat = 5.0, cornerRadius radius: CGFloat = 0)
    {
        guard let anchorView = self.anchorView else {
            fatalError("AnchorView not found")
        }
        // -- Set theme --
        self.theme = .panelTheme()
        self.theme.bgColor = view.backgroundColor ?? UIColor.clear
        
        self.tableYOffset = offset
        self.tableCornerRadius = radius
        
        var frame = anchorView.frame
        frame.size.height = view.frame.size.height
        view.frame = frame
        self.tableListHeight = view.frame.size.height // view.frame.height
        self.tableHeaderView = view
        self.isScrollEnabled = false
        self.showDropDown(reloadData: true)
    }
    
    public func showDropDown(reloadData:Bool = true)
    {
        // -- Re-Format --
        self.format()
        
        privateTableWillAppear()
        
        guard let anchorView = self.anchorView else {
            fatalError("AnchorView not found")
        }
        
        // -- Get parent view contain anchorView --
        if let viewController = anchorView.firstViewController {
            self.containerView = viewController.view
        } else {
            print("==> ParentViewController not found. Use RootViewController")
            self.containerView = UIApplication.shared.keyWindow?.rootViewController?.view!
        }
        
        let frameMatchParent: CGRect! = anchorView.superview?.convert(anchorView.frame, to: containerView)
        // print("frameMatchParent = \(String(describing: frameMatchParent))")
        
        let parent = UIView(frame: frameMatchParent)
        parent.tag = 5001
        parent.backgroundColor = UIColor.clear // Test color
        containerView!.addSubview(parent)
        // -- Hide when tick to anchor view --
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToBackground(sender:)))
        parent.addGestureRecognizer(tapGesture)
        
        self.frame = CGRect(x: parent.frame.minX,
                            y: parent.frame.minY,
                            width: parent.frame.width,
                            height: parent.frame.height)
        self.alpha = 0
        
        self.containerView!.insertSubview(self, belowSubview: parent)
        
        // -- Add touch out background --
        if self.hideOptionsWhenTouchOut {
            self.dismissableView.alpha = 0
            self.containerView!.insertSubview(self.dismissableView, belowSubview: self)
        }
        
        // -- Default .TopToBottom --
        var valY: CGFloat = 0.0
        if self.displayDirection == .TopToBottom {
            valY = parent.frame.maxY + self.tableYOffset
            let realHeight = valY + self.tableListHeight
            if realHeight > UIScreen.main.bounds.size.height {
                // Vuot qua khung hinh, doi nguoc lai cach hien thi
                self.displayDirection = .BottomToTop
                valY = parent.frame.minY - (self.tableListHeight+self.tableYOffset)
            }
        }
        if self.displayDirection == .BottomToTop {
            valY = parent.frame.minY - (self.tableListHeight+self.tableYOffset)
            if valY <= 0 {
                // An phia tren khung man hinh, doi nguoc lai cach hien thi
                self.displayDirection = .TopToBottom
                valY = parent.frame.maxY + self.tableYOffset
            }
        }
        
        switch animationType {
        case .Default:
            UIView.animate(withDuration: 0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            
                            // -- Default .TopToBottom --
//                            var valY = parent.frame.maxY + self.tableYOffset
//                            if self.displayDirection == .BottomToTop {
//                                valY = parent.frame.minY - (self.tableListHeight+self.tableYOffset)
//                            }
                            
                            self.frame = CGRect(x: parent.frame.minX,
                                                y: valY,
                                                width: parent.frame.width,
                                                height: self.tableListHeight)
                            self.alpha = 1
                            self.dismissableView.alpha = 1
                            // -- Reload DataTable --
                            if reloadData {
                                self.setContentOffset(.zero, animated:false)
                            }
                            
                            self.privateTableDoingAppear()
                            
            }, completion: { (didFinish) -> Void in
                self.privateTableDidAppear()
                // -- Set status --
                self.isShow = true
            })
        case .Bouncing:
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            
            UIView.animate(withDuration: 0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            
                            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                            
                            // -- Default .TopToBottom --
//                            var valY = parent.frame.maxY + self.tableYOffset
//                            if self.displayDirection == .BottomToTop {
//                                valY = parent.frame.minY - (self.tableListHeight+self.tableYOffset)
//                            }
                            
                            self.frame = CGRect(x: parent.frame.minX,
                                                y: valY, ///parent.frame.maxY+self.tableYOffset,
                                width: parent.frame.width,
                                height: self.tableListHeight)
                            self.alpha = 1
                            self.dismissableView.alpha = 1
                            // -- Reload DataTable --
                            if reloadData {
                                self.setContentOffset(.zero, animated:false)
                            }
                            
                            self.privateTableDoingAppear()
                            
            }, completion: { (didFinish) -> Void in
                self.privateTableDidAppear()
                // -- Set status --
                self.isShow = true
            })
        case .Classic:
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut, animations: {
                            
                            // -- Default .TopToBottom --
//                            var valY = parent.frame.maxY + self.tableYOffset
//                            if self.displayDirection == .BottomToTop {
//                                valY = parent.frame.minY - (self.tableListHeight+self.tableYOffset)
//                            }
                            
                            self.frame = CGRect(x: parent.frame.minX,
                                                y: valY,
                                                width: parent.frame.width,
                                                height: self.tableListHeight)
                            self.alpha = 1
                            self.dismissableView.alpha = 1
                            // -- Reload DataTable --
                            if reloadData {
                                self.setContentOffset(.zero, animated:false)
                            }
                            
                            self.privateTableDoingAppear()
                            
            }, completion: { (finished) in
                self.privateTableDidAppear()
                // -- Set status --
                self.isShow = true
            })
            
        }
        
    }
    
    public func hideDropDown()
    {
        privateTableWillDisappear()
        
        switch self.animationType {
        case .Default, .Classic:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            
                            // -- Default .TopToBottom --
                            var valY = self.frame.minY
                            if self.displayDirection == .BottomToTop {
                                valY = self.frame.minY + self.tableListHeight
                            }
                            
                            self.frame = CGRect(x: self.frame.minX,
                                                y: valY,
                                                width: self.frame.width,
                                                height: 0)
                            self.alpha = 0
                            self.dismissableView.alpha = 0
                            
                            self.privateTableDoingDisappear()
                            
            }, completion: { (didFinish) -> Void in
                self.dismissableView.removeFromSuperview()
                self.removeFromSuperview()
                self.privateTableDidDisappear()
                
                // -- Remove temple anchor view --
                self.containerView?.viewWithTag(5001)?.removeFromSuperview()
                // -- Set status --
                self.isShow = false
            })
            
        case .Bouncing:
            
            UIView.animate(withDuration: 0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: { () -> Void in
                            
                            self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                            self.center = CGPoint(x: self.frame.midX, y: self.frame.minY)
                            self.alpha = 0
                            self.dismissableView.alpha = 0
                            
                            self.privateTableDoingDisappear()
                            
            }, completion: { (didFinish) -> Void in
                self.dismissableView.removeFromSuperview()
                // -- Phai tra ve size ban dau truoc khi removeFromSuperview --
                self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                self.removeFromSuperview()
                self.privateTableDidDisappear()
                
                // -- Remove temple anchor view --
                self.containerView?.viewWithTag(5001)?.removeFromSuperview()
                // -- Set status --
                self.isShow = false
            })
            
        }
        
    }
    
}

extension DbDropDownView: UITableViewDelegate, UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSourceItems.count
    }
    
    private func makeTableViewCellWithReuseIdentifier(identifier: String, indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        
        // print("title = \(dataSourceItems[(indexPath as NSIndexPath).row].title)")
        // -- Format cell --
        cell.backgroundColor = theme.bgCellColor
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.font = theme.titlefont
        cell.textLabel?.textColor = theme.titleFontColor
        
        cell.detailTextLabel?.font = UIFont(name: theme.subtitleFont.fontName, size: theme.subtitleFont.pointSize * fontConversionRate)
        cell.detailTextLabel?.textColor = theme.subtitleFontColor
        
        cell.selectionStyle = .default
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell?
        
        if let identifier = self.reuseIdentifier {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        } else {
            // -- Make default cell --
            cell = tableView.dequeueReusableCell(withIdentifier: DbDropDownView.cellIdentifier)
            if cell == nil {
                cell = self.makeTableViewCellWithReuseIdentifier(identifier: DbDropDownView.cellIdentifier, indexPath: indexPath)
            }
            
            // -- Fill data to default cell --
            cell?.textLabel?.text = dataSourceItems[(indexPath as NSIndexPath).row].title
            cell?.detailTextLabel?.text = dataSourceItems[(indexPath as NSIndexPath).row].subtitle
            
            if let attributedTitle = dataSourceItems[(indexPath as NSIndexPath).row].attributedTitle {
                cell?.textLabel?.attributedText = attributedTitle
            }
            if let attributedSubtitle = dataSourceItems[(indexPath as NSIndexPath).row].attributedSubtitle {
                cell?.detailTextLabel?.attributedText = attributedSubtitle
            }
            
            cell?.imageView?.image = dataSourceItems[(indexPath as NSIndexPath).row].image
            
            // -- Check use checkmark --
            cell?.accessoryType = .none
            if theme.checkmarkColor != nil {
                cell?.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
                cell?.tintColor = theme.checkmarkColor
            }
        }
        
        // -- Run configuration cell --
        self.cellConfiguration(dataSourceItems, indexPath, cell!)
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedIndex = (indexPath as NSIndexPath).row
        
        tableView.reloadData()
        
        if hideOptionsWhenSelect {
            hideDropDown()
        }
        
        privatedidSelect(dataSourceItems, selectedIndex!)
    }
}
