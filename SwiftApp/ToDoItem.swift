//
//  ToDoItem.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class ToDoItem: NSObject
{
    
    var text: String = ""
    var complete: Bool = false
    
    init(text: String) {
        super.init()
        self.text = text
        self.complete = false
    }
    
    init(frame: CGRect) {
        super.init()
    }
    

}
