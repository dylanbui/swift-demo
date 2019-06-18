//
//  UIGestureRecognizer+Closures.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/29/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import UIKit

private var HandlerKey: UInt8 = 0

internal extension UIGestureRecognizer {
    
    func setHandler<T: UIGestureRecognizer>(_ instance: T, handler: DbClosureHandler<T>) {
        objc_setAssociatedObject(self, &HandlerKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        handler.control = instance
    }
    
    func handler<T>() -> DbClosureHandler<T> {
        return objc_getAssociatedObject(self, &HandlerKey) as! DbClosureHandler
    }
}

public extension UITapGestureRecognizer {
    
    /**
     Initializes a touch gesture-recognizer with the specificed number of taps, touches and handler
     */
    convenience init(taps: Int = 1, touches: Int = 1, handler: @escaping (UITapGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UITapGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
        numberOfTapsRequired = taps
        numberOfTouchesRequired = touches
    }
}

public extension UILongPressGestureRecognizer {
    
    /**
     Initializes a long press gesture recognizer with the specificed handler
     */
    convenience init(handler: @escaping (UILongPressGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UILongPressGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
    }
}

public extension UISwipeGestureRecognizer {
    
    /**
     Initializes a swipe gesture recognizer with the specificed direction and handler
     */
    convenience init(direction: UISwipeGestureRecognizerDirection, handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UISwipeGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
        self.direction = direction
    }
}

public extension UIPanGestureRecognizer {
    
    /**
     Initializes a pan gesture recognizer with the specificed handler
     */
    @objc convenience init(handler: @escaping (UIPanGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UIPanGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
    }
}

public extension UIPinchGestureRecognizer {
    
    /**
     Initializes a pinch gesture-recognizer with the specificed handler
     */
    convenience init(handler: @escaping (UIPinchGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UIPinchGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
    }
}

public extension UIRotationGestureRecognizer {
    
    /**
     Initializes a rotation gesture-recognizer with the specificed handler
     */
    convenience init(handler: @escaping (UIRotationGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UIRotationGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
    }
}

public extension UIScreenEdgePanGestureRecognizer {
    
    /**
     Initializes a screen edge pan gesture-recognizer with the specificed handler
     */
    convenience init(handler: @escaping (UIScreenEdgePanGestureRecognizer) -> Void) {
        let handler = DbClosureHandler<UIScreenEdgePanGestureRecognizer>(handler: handler)
        self.init(target: handler, action: DbClosureHandlerSelector)
        setHandler(self, handler: handler)
    }
}
