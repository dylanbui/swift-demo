//
//  DbGcd.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://github.com/JARMourato/Dispatch
//  https://viblo.asia/p/grand-central-dispatch-in-swift-gGJ592XaKX2
//  Review : https://github.com/duemunk/Async

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

    // -- DucBui 21/01/2019: Remove from ios > 10 --
//    public mutating func enterOnce() {
//        enter()
//        onceToken = 1
//    }
//
//    @discardableResult
//    public mutating func leaveOnce() -> Bool {
//        guard OSAtomicCompareAndSwapInt(1, 0, &onceToken) else { return false }
//        leave()
//        return true
//    }
    
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
    static func asyncMain(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.async(DbQueue.main,  closure: closure)
    }

    @discardableResult
    static func asyncBg(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.async(DbQueue.global(.background), closure: closure)
        
    }
    
    @discardableResult
    static func async(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let dispatch = DbDispatch(closure)
        queue.async(execute: dispatch.currentItem)
        return dispatch
    }
    
    @discardableResult
    static func syncMain(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.sync(DbQueue.main, closure: closure)
    }
    
    @discardableResult
    static func syncBg(_ closure: @escaping DbDispatchClosure) -> DbDispatch {
        return DbDispatch.sync(DbQueue.global(.background), closure: closure)
    }
    
    @discardableResult
    static func sync(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let dispatch = DbDispatch(closure)
        if (queue == DbQueue.main) && Thread.isMainThread {
            dispatch.currentItem.perform()
        } else {
            queue.sync(execute: dispatch.currentItem)
        }
        return dispatch
    }
    
    @discardableResult
    static func after(_ time: TimeInterval, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return after(time, queue: DbQueue.main, closure: closure)
    }
    
    @discardableResult
    static func after(_ time: TimeInterval, queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        let dispatch = DbDispatch(closure)
        queue.asyncAfter(deadline: DispatchTime.now() + Double(getTimeout(time)) / Double(NSEC_PER_SEC), execute: dispatch.currentItem)
        return dispatch
    }
    
    //MARK: - Instance methods
    @discardableResult
    func async(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return chainClosure(queue: queue, closure: closure)
    }
    
    @discardableResult
    func after(_ time: TimeInterval, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return after(time, queue: DbQueue.main, closure: closure)
    }
    
    @discardableResult
    func after(_ time: TimeInterval, queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
        return chainClosure(time, queue: queue, closure: closure)
    }
    
    @discardableResult
    func sync(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) -> DbDispatch {
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
    
    static func barrierAsync(_ queue: DispatchQueue, closure: @escaping DbDispatchClosure) {
        queue.async(flags: .barrier, execute: closure)
    }
    
    static func barrierSync(_ queue: DispatchQueue, closure: DbDispatchClosure) {
        queue.sync(flags: .barrier, execute: closure)
    }
    
    static func apply(_ iterations: Int, queue: DispatchQueue, closure: @escaping DbDispatchApplyClosure) {
        queue.async {
            DispatchQueue.concurrentPerform(iterations: iterations, execute: closure)
        }
    }
    
    static func time(_ timeout: TimeInterval) -> DispatchTime {
        return dispatchTimeCalc(timeout)
    }
    
    static var group: DbGroup {
        return DbGroup()
    }
    
    static func semaphore(_ value: Int = 0) -> DbSemaphore {
        return DbSemaphore(value: value)
    }
    
}

//MARK: - Block methods

public extension DbDispatch {
    func cancel() {
        currentItem.cancel()
    }
    
    @discardableResult
    func wait() -> DispatchTimeoutResult {
        return currentItem.wait(timeout: DispatchTime.distantFuture)
    }
    
    @discardableResult
    func wait(_ timeout: TimeInterval) -> DispatchTimeoutResult {
        return currentItem.wait(timeout: dispatchTimeCalc(timeout))
    }
}

// MARK: - DispatchQueue

public extension DispatchQueue
{
    private static var _onceTracker = [String]()
    
    class func once(token: String, block:() -> Void)
    {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

/* http://blog.flaviocaetano.com/post/the-simplest-throttle-slash-debounce-youll-ever-see/
 One of these days I needed a debounce on Swift to ensure some block of code would only be executed once in a period of time. Debounces are quite simple so I implemented a first draft of it.
 
 Not long after that, I also needed a throttle to skip repetitive calls to a different block of code. Not too different from a debouce, but not quite the same.
 
 No se cancel cac su kien lien tuc goi vao throttle obj chi cho phep chay khi tiep tuc khi deadline. Ung dung search text khi user hit text speed (Auto complete place google)
 
 // Class variable
 private let queueThrottle = DbQueue.global(.background) // Or DbQueue.main // Or DispatchQueue.main
 // Call in function
 queueThrottle.throttle(deadline: DispatchTime.now() + 1.0) {
 
     if Thread.isMainThread {
        print("MAIN Thread")
     } else {
        print("SUBBBB Thread")
     }
 
    // Run code here
 }
 
 */

private var throttleWorkItems = [AnyHashable: DispatchWorkItem]()
private var lastDebounceCallTimes = [AnyHashable: DispatchTime]()
private let nilContext: AnyHashable = arc4random()

public extension DispatchQueue
{
    /**
     - parameters:
     - deadline: The timespan to delay a closure execution
     - context: The context in which the throttle should be executed
     - action: The closure to be executed
     Delays a closure execution and ensures no other executions are made during deadline
     */
    func throttle(deadline: DispatchTime, context: AnyHashable? = nil, action: @escaping () -> Void) {
        let worker = DispatchWorkItem {
            defer { throttleWorkItems.removeValue(forKey: context ?? nilContext) }
            action()
        }
        
        asyncAfter(deadline: deadline, execute: worker)
        
        throttleWorkItems[context ?? nilContext]?.cancel()
        throttleWorkItems[context ?? nilContext] = worker
    }
    
    /**
     - parameters:
     - interval: The interval in which new calls will be ignored
     - context: The context in which the debounce should be executed
     - action: The closure to be executed
     Executes a closure and ensures no other executions will be made during the interval.
     */
    func debounce(interval: Double, context: AnyHashable? = nil, action: @escaping () -> Void) {
        if let last = lastDebounceCallTimes[context ?? nilContext], last + interval > .now() {
            return
        }
        
        lastDebounceCallTimes[context ?? nilContext] = .now()
        async(execute: action)
        
        // Cleanup & release context
        throttle(deadline: .now() + interval) {
            lastDebounceCallTimes.removeValue(forKey: context ?? nilContext)
        }
    }
}
