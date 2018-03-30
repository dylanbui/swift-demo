//
//  UIFont+SwiftIconFont.swift
//  SwiftIconFont
//
//  Created by Sedat Ciftci on 18/03/16.
//  Copyright © 2016 Sedat Gokbek Ciftci. All rights reserved.
//

import UIKit

public enum IconFonts: String {
    case FontAwesome = "FontAwesome"
    case Iconic = "open-iconic"
    case Ionicon = "Ionicons"
    case Octicon = "octicons"
    case Themify = "themify"
    case MapIcon = "map-icons"
    case MaterialIcon = "MaterialIcons-Regular"
    
    var fontName: String {
        switch self {
        case .FontAwesome:
            return "FontAwesome"
        case .Iconic:
            return "Icons"
        case .Ionicon:
            return "Ionicons"
        case .Octicon:
            return "octicons"
        case .Themify:
            return "Themify"
        case .MapIcon:
            return "map-icons"
        case .MaterialIcon:
            return "Material Icons"
        }
    }
    
}
public extension UIFont{
    
    static func icon(from font: IconFonts, ofSize size: CGFloat) -> UIFont {
        let fontName = font.rawValue
        if (UIFont.fontNames(forFamilyName: font.fontName).count == 0)
        {
            /*
            dispatch_once(&token) {
                FontLoader.loadFont(fontName)
            }
            */
            FontLoader.loadFont(fontName)
        }
        return UIFont(name: font.rawValue, size: size)!
    }
    
}

public extension UIImage
{
    public static func icon(from font: IconFonts, code: String, iconColor: UIColor, imageSize: CGSize, ofSize size: CGFloat) -> UIImage
    {
        let drawText = String.getIcon(from: font, code: code)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
		drawText!.draw(in: CGRect(x:0, y:0, width:imageSize.width, height:imageSize.height), withAttributes: [NSAttributedStringKey.font : UIFont.icon(from: font, ofSize: size), NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.foregroundColor: iconColor])
        
		let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public static func fontAwesomeIcon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.FontAwesome, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }
    
    public static func fontOcticon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.Octicon, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }

    public static func fontIonIcon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.Ionicon, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }

    public static func fontIconicIcon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.Iconic, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }

    public static func fontThemifyIcon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.Themify, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }

    public static func fontMapIcon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.MapIcon, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }
    
    public static func fontMaterialIcon(_ code: String, iconColor: UIColor = UIColor.black, ofSize size: CGFloat = 20.0) -> UIImage {
        return icon(from: IconFonts.MaterialIcon, code: code, iconColor: iconColor, imageSize: CGSize(width: size, height: size), ofSize: size)
    }
    
}

public extension UIImageView
{
    public func imageFontIcon(from font: IconFonts, code: String, iconColor: UIColor) {
        contentMode = .center
        image = UIImage.icon(from: font, code: code, iconColor: iconColor, imageSize: size, ofSize: size.width)
    }
    
    public func imageFontAwesomeIcon(_ code: String, iconColor: UIColor = UIColor.black) {
        imageFontIcon(from: IconFonts.FontAwesome, code: code, iconColor: iconColor)
    }

    public func imageFontOcticon(from font: IconFonts, code: String, iconColor: UIColor) {
        imageFontIcon(from: IconFonts.Octicon, code: code, iconColor: iconColor)
    }

    public func imageFontIonIcon(from font: IconFonts, code: String, iconColor: UIColor) {
        imageFontIcon(from: IconFonts.Ionicon, code: code, iconColor: iconColor)
    }

    public func imageFontIconicIcon(from font: IconFonts, code: String, iconColor: UIColor) {
        imageFontIcon(from: IconFonts.Iconic, code: code, iconColor: iconColor)
    }

    public func imageFontThemifyIcon(from font: IconFonts, code: String, iconColor: UIColor) {
        imageFontIcon(from: IconFonts.Themify, code: code, iconColor: iconColor)
    }
    
    public func imageFontMapIcon(from font: IconFonts, code: String, iconColor: UIColor) {
        imageFontIcon(from: IconFonts.MapIcon, code: code, iconColor: iconColor)
    }
    
    public func imageFontMaterialIcon(from font: IconFonts, code: String, iconColor: UIColor) {
        imageFontIcon(from: IconFonts.MaterialIcon, code: code, iconColor: iconColor)
    }
}

public extension String {
    
    public static func getIcon(from font: IconFonts, code: String) -> String? {
        switch font {
        case .FontAwesome:
            return fontAwesomeIcon(code)
        case .Iconic:
            return fontIconicIcon(code)
        case .Ionicon:
            return fontIonIcon(code)
        case .MapIcon:
            return fontMapIcon(code)
        case .MaterialIcon:
            return fontMaterialIcon(code)
        case .Octicon:
            return fontOcticon(code)
        case .Themify:
            return fontThemifyIcon(code)
        }
    }
    
    public static func fontAwesomeIcon(_ code: String) -> String? {
        if let icon = fontAwesomeIconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontOcticon(_ code: String) -> String? {
        if let icon = octiconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontIonIcon(_ code: String) -> String? {
        if let icon = ioniconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontIconicIcon(_ code: String) -> String? {
        if let icon = iconicIconArr[code] {
            return icon
        }
        return nil
    }
    
    
    public static func fontThemifyIcon(_ code: String) -> String? {
        if let icon = temifyIconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontMapIcon(_ code: String) -> String? {
        if let icon = mapIconArr[code] {
            return icon
        }
        return nil
    }
    
    public static func fontMaterialIcon(_ code: String) -> String? {
        if let icon = materialIconArr[code] {
            return icon
        }
        return nil
    }
}

func replace(withText string: NSString) -> NSString {
    if string.lowercased.range(of: "-") != nil {
        return string.replacingOccurrences(of: "-", with: "_") as NSString
    }
    return string
}



func getAttributedString(_ text: NSString, ofSize size: CGFloat) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: text as String)
    
    for substring in ((text as String).split{$0 == " "}.map(String.init)) {
        var splitArr = ["", ""]
        splitArr = substring.split{$0 == ":"}.map(String.init)
        if splitArr.count < 2 {
            continue
        }
        
        
        let substringRange = text.range(of: substring)
        
        let fontPrefix: String  = splitArr[0].lowercased()
        var fontCode: String = splitArr[1]
        
        if fontCode.lowercased().range(of: "_") != nil {
            fontCode = (fontCode as NSString).replacingOccurrences(of: "_", with: "-")
        }
        
        var fontType: IconFonts = IconFonts.FontAwesome
        var fontArr: [String: String] = ["": ""]
        
        if fontPrefix == "fa" {
            fontType = IconFonts.FontAwesome
            fontArr = fontAwesomeIconArr
        } else if fontPrefix == "ic" {
            fontType = IconFonts.Iconic
            fontArr = iconicIconArr
        } else if fontPrefix == "io" {
            fontType = IconFonts.Ionicon
            fontArr = ioniconArr
        } else if fontPrefix == "oc" {
            fontType = IconFonts.Octicon
            fontArr = octiconArr
        } else if fontPrefix == "ti" {
            fontType = IconFonts.Themify
            fontArr = temifyIconArr
        } else if fontPrefix == "mi" {
            fontType = IconFonts.MapIcon
            fontArr = mapIconArr
        } else if fontPrefix == "ma" {
            fontType = IconFonts.MaterialIcon
            fontArr = materialIconArr
        }
        
        if let _ = fontArr[fontCode] {
            attributedString.replaceCharacters(in: substringRange, with: String.getIcon(from: fontType, code: fontCode)!)
            let newRange = NSRange(location: substringRange.location, length: 1)
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.icon(from: fontType, ofSize: size), range: newRange)
        }
    }
    
    return attributedString
}

func GetIconIndexWithSelectedIcon(_ icon: String) -> String {
    let text = icon as NSString
    var iconIndex: String = ""
    
    for substring in ((text as String).split{$0 == " "}.map(String.init)) {
        var splitArr = ["", ""]
        splitArr = substring.split{$0 == ":"}.map(String.init)
        if splitArr.count == 1{
            continue
        }
        
        var fontCode: String = splitArr[1]
        
        if fontCode.lowercased().range(of: "_") != nil {
            fontCode = (fontCode as NSString!).replacingOccurrences(of: "_", with: "-")
        }
        iconIndex = fontCode
    }
    
    return iconIndex
}

func GetFontTypeWithSelectedIcon(_ icon: String) -> IconFonts {
    let text = icon as NSString
    var fontType: IconFonts = IconFonts.FontAwesome
    
    for substring in ((text as String).split{$0 == " "}.map(String.init)) {
        var splitArr = ["", ""]
        splitArr = substring.split{$0 == ":"}.map(String.init)
        
        if splitArr.count == 1{
            continue
        }
        
        let fontPrefix: String  = splitArr[0].lowercased()
        var fontCode: String = splitArr[1]
        
        if fontCode.lowercased().range(of: "_") != nil {
            fontCode = (fontCode as NSString).replacingOccurrences(of: "_", with: "-")
        }
        
        
        if fontPrefix == "fa" {
            fontType = IconFonts.FontAwesome
        } else if fontPrefix == "ic" {
            fontType = IconFonts.Iconic
        } else if fontPrefix == "io" {
            fontType = IconFonts.Ionicon
        } else if fontPrefix == "oc" {
            fontType = IconFonts.Octicon
        } else if fontPrefix == "ti" {
            fontType = IconFonts.Themify
        } else if fontPrefix == "mi" {
            fontType = IconFonts.MapIcon
        } else if fontPrefix == "ma" {
            fontType = IconFonts.MaterialIcon
        }
    }
    
    
    return fontType
}

// Extensions


public extension UILabel {
    func parseIcon() {
        let text = replace(withText: (self.text! as NSString))
        self.attributedText = getAttributedString(text, ofSize: self.font!.pointSize)
    }
}
