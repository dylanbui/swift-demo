//
//  Constant.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/24/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

let aa = 12345

//#define fOpenSans(font_size)                    [UIFont fontWithName:@"OpenSans" size:[font_size doubleValue]]
//#define fOpenSansSemibold(font_size)            [UIFont fontWithName:@"OpenSans-Semibold" size:[font_size doubleValue]]
//#define fFontAwesome(font_size)                 [UIFont fontWithName:@"FontAwesome" size:[font_size float]]


extension UIFont {

    static func fOpenSans(size: Float) -> UIFont {
        
    
        return UIFont(name: "", size: CGFloat(size))!
        // return UIFont(name: "OpenSans", size: CGFloat(size))
    }

}

class Macro
{

}
