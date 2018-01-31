//
//  DbGcd.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on :
//  https://viblo.asia/p/grand-central-dispatch-in-swift-gGJ592XaKX2



import Foundation

public typealias DbDispatchClosure = () -> (Void)
public typealias DbDispatchApplyClosure = (Int) -> (Void)

fileprivate var getTimeout: (_ time: TimeInterval) -> Int64 = { Int64($0 * Double(NSEC_PER_SEC)) }
fileprivate var dispatchTimeCalc: (TimeInterval) -> (DispatchTime) = { DispatchTime.now() + Double(getTimeout($0)) / Double(NSEC_PER_SEC) }

//MARK: - Queue
public enum DbQueue {
    public enum Atribute {
        static var concurrent: DispatchQueue.Attributes = DispatchQueue.Attributes.concurrent
        static var serial: DispatchQueue.Attributes = []
    }
    
    public enum Priority {
        static var userInteractive: DispatchQoS.QoSClass = DispatchQoS.QoSClass.userInteractive
        static var userInitiated: DispatchQoS.QoSClass = DispatchQoS.QoSClass.userInitiated
        static var utility: DispatchQoS.QoSClass = DispatchQoS.QoSClass.utility
        static var background: DispatchQoS.QoSClass = DispatchQoS.QoSClass.background
    }
    
    public static var main: DispatchQueue {
        return DispatchQueue.main
    }
    
    public static var global: (DispatchQoS.QoSClass) -> DispatchQueue = { priority in
        return DispatchQueue.global(qos: priority)
    }
    
    public static var custom: (String, DispatchQueue.Attributes) -> DispatchQueue = { identifier, attributes in
        return DispatchQueue(label: identifier, attributes: attributes)
    }
    
}

//MARK: - Group
public struct DbGroup {
    public let group: DispatchGroup = DispatchGroup()
    private var onceToken: Int32 = 0
    
    public func enter() {
        group.enter()
    }
    
    public func leave() {
        group.leave()
    }
    
    public mutating func enterOnce() {
        enter()
        onceToken = 1
    }
    
    @discardableResult
    public mutating func leaveOnce() -> Bool {
        guard OSAtomicCompareAndSwapInt(1, 0, &onceToken) else { return false }
        leave()
        return true
    }
    
    @discardableResult
    public func async(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbGroup {
        queue.async(group: group) {
            autoreleasepool(invoking: closure)
        }
        return self
    }
    
    public func notify(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) {
        group.notify(queue: queue) {
            autoreleasepool(invoking: closure)
        }
    }
    
    @discardableResult
    public func wait() -> DispatchTimeoutResult {
        return group.wait(timeout: DispatchTime.distantFuture)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval) -> DispatchTimeoutResult {
        return group.wait(timeout: dispatchTimeCalc(timeout))
    }
    
}

//MARK: - Semaphore
public struct DbSemaphore {
    private let value: Int
    let semaphore: DispatchSemaphore
    
    init(value: Int) {
        self.value = value
        semaphore = DispatchSemaphore(value: value)
    }
    
    init() {
        self.init(value: 0)
    }
    
    @discardableResult
    public func signal() -> Int {
        return semaphore.signal()
    }
    
    @discardableResult
    public func wait() -> DispatchTimeoutResult {
        return semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval) -> DispatchTimeoutResult {
        return semaphore.wait(timeout: dispatchTimeCalc(timeout))
    }
    
}

//MARK: - Dispatch
//MARK: - Main structure
public struct DbDispatch {
    fileprivate let currentItem: DispatchWorkItem
    fileprivate init(_ closure: @escaping DbDispatchClosure) {
        let item = DispatchWorkItem(flags: DispatchWorkItemFlags.inheritQoS, block: closure)
        currentItem = item
    }
}

//MARK: - Chainable methods
public extension DbDispatch {
    
    //MARK: - Static methods
    @discardableResult
    public static func asyncMain(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.async(DbQueue.main,  closure: closure)
    }

    @discardableResult
    public static func asyncBg(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.async(DbQueue.global(.background), closure: closure)
        
    }
    
    @discardableResult
    public static func async(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let dispatch = DbDispatch(closure)
        queue.async(execute: dispatch.currentItem)
        return dispatch
    }
    
    @discardableResult
    public static func syncMain(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.sync(DbQueue.main, closure: closure)
    }
    
    @discardableResult
    public static func syncBg(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.sync(DbQueue.global(.background), closure: closure)
    }
    
    @discardableResult
    public static func sync(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let dispatch = DbDispatch(closure)
        if (queue == DbQueue.main) && Thread.isMainThread {
            dispatch.currentItem.perform()
        } else {
            queue.sync(execute: dispatch.currentItem)
        }
        return dispatch
    }
    
    @discardableResult
    public static func after(_ time: TimeInterval, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return after(time, queue: DbQueue.main, closure: closure)
    }
    
    @discardableResult
    public static func after(_ time: TimeInterval, queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let dispatch = DbDispatch(closure)
        queue.asyncAfter(deadline: DispatchTime.now() + Double(getTimeout(time)) / Double(NSEC_PER_SEC), execute: dispatch.currentItem)
        return dispatch
    }
    
    //MARK: - Instance methods
    @discardableResult
    public func async(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return chainClosure(queue: queue, closure: closure)
    }
    
    @discardableResult
    public func after(_ time: TimeInterval, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return after(time, queue: DbQueue.main, closure: closure)
    }
    
    @discardableResult
    public func after(_ time: TimeInterval, queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return chainClosure(time, queue: queue, closure: closure)
    }
    
    @discardableResult
    public func sync(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let syncWrapper: DbDispatchClosure = {
            queue.sync(execute: closure)
        }
        return chainClosure(queue: queue, closure: syncWrapper)
    }
    
    //MARK: - Private chaining helper method
    private func chainClosure(_ time: TimeInterval? = nil, queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let newDispatch = DbDispatch(closure)
        let nextItem: DispatchWorkItem
        if let time = time {
            nextItem = DispatchWorkItem(flags: .inheritQoS) {
                queue.asyncAfter(deadline: DispatchTime.now() + Double(getTimeout(time)) / Double(NSEC_PER_SEC), execute: newDispatch.currentItem)
            }
        } else {
            nextItem = newDispatch.currentItem
        }
        currentItem.notify(queue: queue, execute: nextItem)
        return newDispatch
    }
    
}

//MARK: - Non-Chainable Methods

public extension DbDispatch {
    
    public static func barrierAsync(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) {
        queue.async(flags: .barrier, execute: closure)
    }
    
    public static func barrierSync(_ queue: DispatchQueue, closure: DbDispatchClosure) {
        queue.sync(flags: .barrier, execute: closure)
    }
    
    public static func apply(_ iterations: Int, queue: DispatchQueue, closure: @escaping DbDispatchApplyClosure) {
        queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: closure)
        }
    }
    
    public static func time(_ timeout: TimeInterval) -> DispatchTime {
        return dispatchTimeCalc(timeout)
    }
    
    public static var group: DbGroup {
        return DbGroup()
    }
    
    public static func semaphore(_ value: Int = 0) -> DbSemaphore {
        return DbSemaphore(value: value)
    }
    
}

//MARK: - Block methods

public extension DbDispatch {
    public func cancel() {
        currentItem.cancel()
    }
    
    @discardableResult
    public func wait() -> DispatchTimeoutResult {
        return currentItem.wait(timeout: DispatchTime.distantFuture)
    }
    
    @discardableResult
    public func wait(_ timeout: TimeInterval) -> DispatchTimeoutResult {
        return currentItem.wait(timeout: dispatchTimeCalc(timeout))
    }
}
