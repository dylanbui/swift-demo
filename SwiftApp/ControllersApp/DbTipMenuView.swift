//
//  DbTipMenuView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/31/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

public class DbTipMenuView: UITableView
{
    /// Force the results list to adapt to RTL languages
    public var forceRightToLeft = false

    public var selectedIndex: Int?
    
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
    
    fileprivate var fontConversionRate: CGFloat = 0.7
    fileprivate static let cellIdentifier = "DbDropDownViewItem"
    fileprivate var reuseIdentifier: String?
    
    fileprivate var dataSourceItems = [DbDropDownViewItem]()
    
    // Closures
    fileprivate var privatedidSelect: ([DbDropDownViewItem], Int) -> () = {options, index in }
    fileprivate var cellConfiguration: ([DbDropDownViewItem], IndexPath, UITableViewCell) -> () = {options, index, cell  in }
    
    // Init
    public override init(frame: CGRect, style: UITableViewStyle)
    {
        super.init(frame: frame, style: .plain)
        setup()
    }
    
    public convenience init(withAnchorView: UIView, andFrame: CGRect = .zero)
    {
        self.init(frame: andFrame, style: .plain)
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setup()
    }
    
    deinit {
    }
    
    // Create the filter table and shadow view
    fileprivate func setup()
    {
        self.dataSource = self
        self.delegate = self
    }
    
    // Create the filter table and shadow view
    fileprivate func format()
    {
//        self.layer.masksToBounds = true
//        self.layer.borderWidth = theme.borderWidth > 0 ? theme.borderWidth : 0.5
        //self.separatorInset = UIEdgeInsets.zero // Padding left
        if forceRightToLeft {
            self.semanticContentAttribute = .forceRightToLeft
        }
        
        // Re-format Touch background frames and theme colors
        
        // Re-format frames and theme colors
        self.estimatedRowHeight = theme.cellHeight > 0 ? theme.cellHeight : UITableViewAutomaticDimension
        self.layer.borderColor = theme.borderColor.cgColor
        self.separatorColor = theme.separatorColor
        self.backgroundColor = theme.bgColor
        
        self.reloadData()
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
    
    
//    public func showDropDown(WithView view: UIView, BottomNavigationBarOf vcl: UIViewController)
//    {
//        guard let nav = vcl.navigationController else {
//            fatalError("UINavigationController find not found")
//        }
//
//        // -- Remove old anhchor --
//        if let view = vcl.view.viewWithTag(5005) {
//            view.removeFromSuperview()
//            self.anchorView = nil
//        }
//        // -- Create new anchor --
//        let anchor = UIView(frame: CGRect(x: 0.0, y: nav.navigationBar.frame.origin.y + nav.navigationBar.frame.size.height
//            , width: nav.navigationBar.frame.size.width, height: 0.0))
//        anchor.backgroundColor = UIColor.clear
//        anchor.tag = 5005
//        vcl.view.addSubview(anchor)
//
//        self.displayDirection = .TopToBottom
//        self.anchorView = anchor
//
//        self.showDropDown(WithView: view, yOffset: 0.0)
//    }
    
//    public func showDropDown(WithView view: UIView, yOffset offset: CGFloat = 5.0, cornerRadius radius: CGFloat = 0)
//    {
//        //guard let parent = self.anchorView else {
//        guard let subAnchorView = self.anchorView else {
//            fatalError("AnchorView not found")
//        }
//        // -- Set theme --
//        self.theme = .panelTheme()
//        self.theme.bgColor = view.backgroundColor ?? UIColor.clear
//
//        self.tableYOffset = offset
//        self.tableCornerRadius = radius
//
//        // self.dataSourceItems.removeAll()
//        var frame = subAnchorView.frame
//        frame.size.height = view.frame.size.height
//        view.frame = frame
//        self.tableListHeight = view.frame.size.height // view.frame.height
//        self.tableHeaderView = view
//        self.isScrollEnabled = false
//        self.showDropDown(reloadData: true)
//    }
    
    
}

extension DbTipMenuView: UITableViewDelegate, UITableViewDataSource
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
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell?
        
        if let identifier = self.reuseIdentifier {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        } else {
            // -- Make default cell --
            cell = tableView.dequeueReusableCell(withIdentifier: DbTipMenuView.cellIdentifier)
            if cell == nil {
                cell = self.makeTableViewCellWithReuseIdentifier(identifier: DbTipMenuView.cellIdentifier, indexPath: indexPath)
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
        
        
        privatedidSelect(dataSourceItems, selectedIndex!)
    }
}

