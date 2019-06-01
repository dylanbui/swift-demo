//
//  DbTipMenuView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/31/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit
import EasyTipView

public struct DbTipMenuViewTheme
{
    public var tipViewWidth: CGFloat = 200
    public var cellHeight: CGFloat = 0
    public var bgColor: UIColor
    public var separatorColor: UIColor
    public var titlefont: UIFont
    public var titleFontColor: UIColor
    
    public var checkmarkColor: UIColor? // = nil , dont use checkmark
    
    init(cellHeight: CGFloat,
         bgColor:UIColor,
         separatorColor: UIColor,
         font: UIFont, fontColor: UIColor)
    {
        self.cellHeight = cellHeight
        self.bgColor = bgColor
        self.separatorColor = separatorColor
        
        self.titlefont = font
        self.titleFontColor = fontColor
    }
    
    public static func darkTheme() -> DbTipMenuViewTheme
    {
        return DbTipMenuViewTheme(cellHeight: 40,
                                   bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
                                   separatorColor: UIColor.white.withAlphaComponent(0.8),
                                   font: UIFont.systemFont(ofSize: 13), fontColor: UIColor.white)
    }
    
    public static func darkWithCheckTheme() -> DbTipMenuViewTheme
    {
        var theme = DbTipMenuViewTheme(cellHeight: 40,
                                  bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0),
                                  separatorColor: UIColor.white.withAlphaComponent(0.8),
                                  font: UIFont.systemFont(ofSize: 13), fontColor: UIColor.white)
        
        theme.checkmarkColor = UIColor.white.withAlphaComponent(0.8)
        return theme
    }
}

extension DbTipMenuViewTheme
{
    // -- Note: Use color with withAlphaComponent will be border line --
    public static func blueTheme() -> DbTipMenuViewTheme
    {
        var theme = DbTipMenuViewTheme(cellHeight: 40,
                                       bgColor: UIColor.blue.withAlphaComponent(0.8),
                                       separatorColor: UIColor.clear,
                                       font: UIFont.boldSystemFont(ofSize: 13), fontColor: UIColor.white)
        
        theme.checkmarkColor = UIColor.white
        return theme
    }
}

public class DbTipMenuView: UITableView
{
    /// Force the results list to adapt to RTL languages
    public var forceRightToLeft = false
    // selected
    public var selectedIndex: Int?
    // Status show, hide
    public var isShow = false
    
    /// Set an array of SearchTextFieldItem's to be used for suggestions
    public func dataSourceItems(_ items: [DbItem]) {
        self.dataSourceItems = items
    }
    
    /// Set an array of strings to be used for suggestions
    public func dataSourceStrings(_ strings: [String]) {
        var items = [DbItem]()
        var count: Int = 1
        for value in strings {
            items.append(DbItem(id: count, title: value))
            count += 1
        }
        dataSourceItems(items)
    }
    
    /// Set your custom visual theme, or just choose between pre-defined
    public var theme = DbTipMenuViewTheme.darkTheme()
    
    ////////////////////////////////////////////////////////////////////////
    // Private implementation
    
    fileprivate var tipsView: EasyTipView!
    
    fileprivate var dismissableView: UIView!
    fileprivate var fontConversionRate: CGFloat = 0.7
    fileprivate static let cellIdentifier = "DbTipMenuViewItem"
    fileprivate var reuseIdentifier: String?
    
    fileprivate var dataSourceItems = [DbItem]()
    
    // Closures
    fileprivate var privatedidSelect: ([DbItem], Int) -> () = {options, index in }
    fileprivate var cellConfiguration: ([DbItem], IndexPath, UITableViewCell) -> () = {options, index, cell  in }
    
    // Init
    public override init(frame: CGRect, style: UITableViewStyle)
    {
        super.init(frame: frame, style: .plain)
        setup()
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
        // -- Fits content, dont allow scroll --
        self.isScrollEnabled = false
        self.alwaysBounceVertical = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        self.dataSource = self
        self.delegate = self
        
        // -- Touch background --
        self.dismissableView = UIView(frame: UIScreen.main.bounds)
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToBackground(sender:)))
        // 2. add the gesture recognizer to a view
        self.dismissableView.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func touchToBackground(sender: UITapGestureRecognizer)
    {
        self.hideMenu()
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
    public func didSelect(completion: @escaping (_ options: [DbItem], _ index: Int) -> ())
    {
        privatedidSelect = completion
    }
    
    public func cellConfiguration(configuration: @escaping (_ options: [DbItem], _ index: IndexPath, _ cell: UITableViewCell) -> ())
    {
        cellConfiguration = configuration
    }
    
    // Create the filter table and shadow view
    fileprivate func formatDefaultTipView() -> EasyTipView.Preferences
    {
        // -- Format tableview --
        if forceRightToLeft {
            self.semanticContentAttribute = .forceRightToLeft
        }
        // -- Cell height --
        if theme.cellHeight > 0 {
            self.rowHeight = theme.cellHeight
        } else {
            self.estimatedRowHeight = UITableViewAutomaticDimension
        }
        // -- background Color --
        self.backgroundColor = theme.bgColor
        // -- separator Color --
        self.separatorColor = theme.separatorColor
        
        // -- UITableView frame --
        let height = (self.rowHeight * CGFloat(self.dataSourceItems.count)) - 5 // 5 = padding
        var width = CGFloat(Db.screenWidth()*2 / 3) // Default get 2/3 screen
        if theme.tipViewWidth > 0 {
            width = theme.tipViewWidth
        }
        self.frame = CGRect.init(0, 0, width, height)
        
        // -- Reload tableview --
        self.reloadData()
        
        // -- TipView --
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.any
        preferences.drawing.backgroundColor = theme.bgColor
        preferences.drawing.foregroundColor = theme.bgColor
        preferences.drawing.textAlignment = NSTextAlignment.center
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 0.7
        preferences.animating.dismissDuration = 0.7
        
        preferences.animating.dismissOnTap = false
        
        preferences.positioning.contentHInset = 5
        preferences.positioning.contentVInset = 5
        
        return preferences
    }
    
    public func showMenu(forBarItem item: UIBarItem, withinSuperview superview: UIView? = nil)
    {
        if self.isShow == true {
            self.hideMenu {
                self.isShow = false
            }
            return
        }
        
        let preferences = self.formatDefaultTipView()
        
        // -- Get superview --
        let superview = superview ?? UIApplication.shared.windows.first!
        self.dismissableView.backgroundColor = UIColor.clear
        superview.addSubview(self.dismissableView)
        
        self.tipsView = EasyTipView(contentView: self, preferences: preferences, delegate: nil)
        self.tipsView.show(animated: true, forItem: item, withinSuperView: nil)
        self.isShow = true
    }
    
    public func showMenu(forView view: UIView, withinSuperview superview: UIView? = nil)
    {
        if self.isShow == true {
            self.hideMenu {
                self.isShow = false
            }
            return
        }

        // -- Re-Format --
        let preferences = self.formatDefaultTipView()
        
        // -- Get superview --
        let superview = superview ?? UIApplication.shared.windows.first!
        self.dismissableView.backgroundColor = UIColor.clear
        superview.addSubview(self.dismissableView)
        
        self.tipsView = EasyTipView(contentView: self, preferences: preferences, delegate: nil)
        self.tipsView.show(animated: true, forView: view, withinSuperview: superview)
        self.isShow = true
    }
    
    public func hideMenu(withCompletion completion: (() -> ())? = nil)
    {
        self.dismissableView.removeFromSuperview()
        self.tipsView.dismiss {
            completion?()
            self.isShow = false
        }
    }
    
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
        
        // -- Format cell --
        cell.backgroundColor = UIColor.clear
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.font = theme.titlefont
        cell.textLabel?.textColor = theme.titleFontColor
        
        cell.selectionStyle = .gray
        
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
            cell?.textLabel?.text = dataSourceItems[(indexPath as NSIndexPath).row].dbItemTitle
            
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex = (indexPath as NSIndexPath).row
        
        tableView.reloadData()
        
        DbUtils.performAfter(delay: 0.1) {
            self.hideMenu()
            self.privatedidSelect(self.dataSourceItems, self.selectedIndex!)
        }
    }
}

