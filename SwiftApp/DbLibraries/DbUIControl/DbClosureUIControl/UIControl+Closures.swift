//
//  UIControl+Closures.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/29/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import UIKit

public extension UIControl {
    
    /// Adds a handler that will be invoked for the specified control events
    func on(_ controlEvents: UIControlEvents, invokeHandler handler: @escaping (UIControl) -> Void) -> AnyObject {
        let closureHandler = DbClosureHandler(handler: handler, control: self)
        addTarget(closureHandler, action: DbClosureHandlerSelector, for: controlEvents)
        var handlers = self.handlers ?? Set<DbClosureHandler<UIControl>>()
        handlers.insert(closureHandler)
        self.handlers = handlers
        return closureHandler
    }
    
    /// Removes a handler from the control
    func removeHandler(_ handler: AnyObject) {
        guard let handler = handler as? DbClosureHandler<UIControl> else { return }
        removeTarget(handler, action: DbClosureHandlerSelector, for: .allEvents)
        if var handlers = self.handlers {
            handlers.remove(handler)
            self.handlers = handlers
        }
    }
}

private var HandlerKey: UInt8 = 0

private extension UIControl {
    
    var handlers: Set<DbClosureHandler<UIControl>>? {
        get { return objc_getAssociatedObject(self, &HandlerKey) as? Set<DbClosureHandler<UIControl>> }
        set { objc_setAssociatedObject(self, &HandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
