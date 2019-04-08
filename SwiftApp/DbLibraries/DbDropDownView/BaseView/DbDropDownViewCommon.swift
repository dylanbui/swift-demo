//
//  DbDropDownCommon.swift
//  SearchTextField
//
//  Created by Dylan Bui on 10/28/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import Foundation
import UIKit

public enum DbDropDownViewAnimationType: Int {
    case Default
    case Bouncing
    case Classic // This is DropDown
}

public enum DbDropDownViewDirection: Int {
    case TopToBottom
    case BottomToTop
}

////////////////////////////////////////////////////////////////////////
// Search Text Field Theme

public struct DbDropDownViewTheme
{
    public var cellHeight: CGFloat = 0
    public var bgColor: UIColor
    public var bgCellColor: UIColor
    public var borderColor: UIColor
    public var borderWidth : CGFloat = 0
    public var separatorColor: UIColor
    public var titlefont: UIFont
    public var titleFontColor: UIColor
    public var subtitleFont: UIFont
    public var subtitleFontColor: UIColor
    
    public var checkmarkColor: UIColor? // = nil , dont use checkmark
    public var dismissableViewColor: UIColor = UIColor.clear // Touch out background color
    
    // -- Arrow --
    public var arrowPadding: CGFloat = 7.0
    
    init(cellHeight: CGFloat,
         bgColor:UIColor,
         borderColor: UIColor, separatorColor: UIColor, font: UIFont, fontColor: UIColor, subtitleFontColor: UIColor? = nil)
    {
        self.cellHeight = cellHeight
        self.borderColor = borderColor
        self.separatorColor = separatorColor
        self.bgColor = bgColor
        self.bgCellColor = bgColor
        
        self.titlefont = font
        self.titleFontColor = fontColor
        
        self.subtitleFont = font
        self.subtitleFontColor = subtitleFontColor ?? fontColor
    }
    
    public static func lightTheme() -> DbDropDownViewTheme
    {
        return DbDropDownViewTheme(cellHeight: 30,
                                bgColor: UIColor (red: 1, green: 1, blue: 1, alpha: 0.6),
                                borderColor: UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
                                separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.black)
    }
    
    public static func darkTheme() -> DbDropDownViewTheme
    {
        return DbDropDownViewTheme(cellHeight: 30,
                               bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6),
                               borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
                               separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 10), fontColor: UIColor.white)
    }
    
    public static func panelTheme() -> DbDropDownViewTheme
    {
        var theme = DbDropDownViewTheme(cellHeight: 40,
                                        bgColor: UIColor.clear,
                                        borderColor: UIColor.clear,
                                        separatorColor: UIColor.clear, font: UIFont.systemFont(ofSize: 13), fontColor: UIColor.blue)
        
        theme.subtitleFont = UIFont.italicSystemFont(ofSize: 10)
        theme.subtitleFontColor = UIColor.brown
        theme.checkmarkColor = UIColor.red // User checkmark
        theme.dismissableViewColor = UIColor.clear
        return theme
    }
    
    public static func testTheme() -> DbDropDownViewTheme
    {
        var theme = DbDropDownViewTheme(cellHeight: 40,
                               bgColor: UIColor (red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6),
                               borderColor: UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
                               separatorColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 13), fontColor: UIColor.blue)
        
        theme.subtitleFont = UIFont.italicSystemFont(ofSize: 10)
        theme.subtitleFontColor = UIColor.brown
        theme.checkmarkColor = UIColor.red // User checkmark
        theme.dismissableViewColor = UIColor.yellow.withAlphaComponent(0.4)
        return theme
    }
}


////////////////////////////////////////////////////////////////////////
// Select Item

open class DbDropDownViewItem
{
    // Attributed vars
    public var attributedTitle: NSMutableAttributedString?
    public var attributedSubtitle: NSMutableAttributedString?
    
    // Public interface
    public var itemId: Int
    public var title: String
    public var subtitle: String?
    public var image: UIImage?
    
    public var rawData: Any?
    
    public init(id: Int, title: String, subtitle: String?, image: UIImage?)
    {
        self.itemId = id
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    convenience init(id: Int, title: String, subtitle: String?)
    {
        self.init(id: id, title: title, subtitle: subtitle, image: nil)
    }
    
    convenience init(id: Int, title: String)
    {
        self.init(id: id, title: title, subtitle: nil, image: nil)
    }    
}

