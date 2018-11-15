//
//  KBBottomBarView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 11/15/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

@IBDesignable
class KBBottomBarView: DbLoadableView
{
    public var handleViewAction: DbHandleAction?
    
    // Default Init
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setup()
    }
    
    // -- convenience --
    convenience init()
    {
        self.init(frame: .zero)
        setup()
    }
    
    private func setup()
    {
        
    }
    
}
