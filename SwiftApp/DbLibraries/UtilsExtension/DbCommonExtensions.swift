//
//  DbCommonExtensions.swift
//  PropzySam
//
//  Created by Dylan Bui on 9/17/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Small extenions class

// MARK: - UIColor

extension UIColor {
    
    public convenience init(_ r: UInt,_ g: UInt,_ b: UInt,_ alpha: CGFloat = 1.0 ) {
        self.init(
            red:   CGFloat(r)/255.0,
            green: CGFloat(g)/255.0,
            blue:  CGFloat(b)/255.0,
            alpha: alpha
        )
    }
    
    public typealias RGBA = (r: UInt, g: UInt, b: UInt, a: UInt)
    public convenience init(rgba: RGBA) {
        self.init(
            rgb: (rgba.r, rgba.g, rgba.b),
            alpha: CGFloat(rgba.a)/255.0
        )
    }
    
    public typealias RGB = (r: UInt, g: UInt, b: UInt)
    public convenience init(rgb: RGB, alpha: CGFloat = 1.0) {
        self.init(
            red:   CGFloat(rgb.r)/255.0,
            green: CGFloat(rgb.g)/255.0,
            blue:  CGFloat(rgb.b)/255.0,
            alpha: alpha
        )
    }
    
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     - parameter hex6: Six-digit hexadecimal value.
     */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1)
    {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public class func randomColor() -> UIColor {
        let component = { CGFloat(drand48()) }
        return UIColor(red: component(), green: component(), blue: component(), alpha: 1.0)
    }
    
    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
     - parameter rgba: String value.
     */
    public convenience init(hexString: String, alpha: CGFloat = 1)
    {
        guard hexString.hasPrefix("#") else {
            fatalError("UIColor error => \(hexString)")
        }
        
        let hexStr: String = String(hexString[String.Index.init(encodedOffset: 1)...])
        var hexValue:  UInt32 = 0
        
        guard Scanner(string: hexStr).scanHexInt32(&hexValue) else {
            fatalError("UIColor error => unable To Scan Hex Value \(hexStr)")
        }
        
        if (hexStr.count != 6) {
            fatalError("UIColor error => unable To Scan Hex Value \(hexStr)")
        }
        
        self.init(hex6: hexValue, alpha: alpha)
    }
    
}

extension UIButton {
    
    public func db_doDisable(_ disable: Bool)
    {
        if disable {
            self.isEnabled = false
            let color = self.titleColor(for: .normal)
            self.setTitleColor(color?.withAlphaComponent(0.4), for: .normal)
        } else {
            self.isEnabled = true
            let color = self.titleColor(for: .normal)
            self.setTitleColor(color?.withAlphaComponent(1.0), for: .normal)

        }
        
    }
    
}
