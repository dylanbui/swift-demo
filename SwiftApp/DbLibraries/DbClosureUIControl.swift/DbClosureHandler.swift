//
//  DbClosureHandler.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/29/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

public let DbClosureHandlerSelector = Selector(("handle"))

public class DbClosureHandler<T: AnyObject>: NSObject {
    
    internal var handler: ((T) -> Void)?
    internal weak var control: T?
    
    internal init(handler: @escaping (T) -> Void, control: T? = nil) {
        self.handler = handler
        self.control = control
    }
    
    @objc func handle() {
        if let control = self.control {
            handler?(control)
        }
    }
}
