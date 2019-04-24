//
//  DbOperator.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://github.com/arkdan/ARKExtensions
//  https://github.com/arkdan/ARKExtensions/blob/master/Extensions-macOS/Operation.swift

import Foundation

/*

 DbOperation
 Handy asynchronous Operation (NSOperation) with completion reporting.
 • No need to fiddle with will set did set executing finished... i never get it right because i'm stupid.
 • No need to subclass, you can pass blocks like so:
 
     let op = DbOperation { finished in
         // do work; call finished() when done
         delay(2) { finished() }
     }
 
 • I dont mind subclassing though; helps me stay focused and keeps logic separated. Instead of overriding traditional start and playing with executing finished - override execute, call finish() when you're done.
 
 class DelayOperation: DbOperation {
     let delay: Double
 
     init(delay: Double) {
         self.delay = delay
         super.init()
     }
 
     override func execute() {
         // do work, then call finish()
         DispatchQueue.main.delayed(self.delay) {
            self.finish()
         }
     }
 }
 
 DbOperationQueue
 whenEmpty: () -> Void called each time all operations are completed. Also, you can add blocks to the queue as a convenience - similar to addOperation(_ block: @escaping () -> Void):
 
 queue.addExecution { finished in
    delay(0.5) { finished() }
 }
 
 Example:
 
 let op = DbOperation { finished in
    delay(2) { finished() }
 }
 
 let delayOp = DelayOperation(delay: 3)
 op.addDependency(delayOp)
 
 let queue = DbOperationQueue()
 queue.addOperation(op)
 queue.addOperation(delayOp)
 
 queue.addExecution { finished in
    delay(0.5) { finished() }
 }
 
 queue.whenEmpty = {
    print("all operations finished")
 }
 
 */



/// DbOperation are asynchronous.
open class DbOperation: Operation {
    
    public typealias Execution = (_ finished: @escaping () -> Void) -> Void
    
    fileprivate var privateCompletionBlock: ((DbOperation) -> Void)?
    
    /// provide either 'execution' block, or override func execute(). The block takes priority.
    open var execution: Execution?
    
    public init(block: @escaping Execution) {
        super.init()
        execution = block
    }
    
    public override init() {
        super.init()
    }
    
    /// always true. These thigs are asynchronous.
    override public final var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override public final var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override public final var isFinished: Bool {
        return _finished
    }
    
    override public final func start() {
        if isCancelled {
            finish()
            return
        }
        
        _executing = true
        if let execution = self.execution {
            execution(finish)
        } else {
            execute()
        }
    }
    
    open func execute() {
        fatalError("Must override execute() or provide 'execution' block")
    }
    
    public final func finish() {
        // Da thay doi
        privateCompletionBlock?(self)
        _executing = false
        _finished = true
    }
    
}

open class DbOperationQueue: OperationQueue {
    
    // need a alternative operations count, because Operation.operationCount is sometimes carries
    // irrelevant values due to concurrent nature of the queue.
    private var ccount = 0
    
    
    /// called each time all operations are completed.
    public var whenEmpty: (() -> Void)?
    
    public convenience init(maxConcurrent: Int) {
        self.init()
        maxConcurrentOperationCount = maxConcurrent
    }
    
    /*
     override init() {
     super.init()
     addObserver(self, forKeyPath: #keyPath(operations), options: [.new, .old], context: nil)
     }
     
     override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     
     guard let kkeyPath = keyPath, kkeyPath == #keyPath(operations) else {
     return
     }
     let old = change![.oldKey] as! [Operation]
     let new = change![.newKey] as! [Operation]
     print("queue count \(operationCount) \(old.count)->\(new.count)")
     
     if let kkeyPath = keyPath, kkeyPath == #keyPath(operations),
     let cchange = change,
     let old = cchange[.oldKey] as? [Operation], let new = cchange[.newKey] as? [Operation],
     new.count == 0, old.count == 1 {
     self.whenEmpty?()
     print("trigger")
     }
     }
     */
    
    
    /// Supports DbOperations only
    override open func addOperation(_ operation: Operation) {
        guard let op = operation as? DbOperation else {
            fatalError("This class only works with DbOperation objects")
        }
        
        ccount += 1
        
        super.addOperation(op)
        
        op.privateCompletionBlock = { [weak self] operation in
            guard let sself = self else {
                return
            }
            // print("Before: sself.ccount = \(sself.ccount)")
            sself.ccount -= 1
            // print("After: sself.ccount = \(sself.ccount)")
            // print("-------------")
            if sself.ccount == 0 {
                sself.whenEmpty?()
            }
        }
    }
    
    public func addExecution(_ execution: @escaping DbOperation.Execution) {
        addOperation(DbOperation(block: execution))
    }
    
    /// Add an Array of chained Operations.
    ///
    /// Example:
    ///
    ///     [A, B, C] = A -> B -> C -> completionHandler.
    ///
    /// - Parameters:
    ///   - operations: Operations Array.
    ///   - completionHandler: Completion block to be exectuted when all Operations
    ///                        are finished.
    public func addChainedOperations(_ operations: [Operation], completionHandler: (() -> Void)? = nil) {
        for (index, operation) in operations.enumerated() {
            if index > 0 {
                operation.addDependency(operations[index - 1])
            }
            
            addOperation(operation)
        }
        
        guard let completionHandler = completionHandler else {
            return
        }
        
        let completionOperation = BlockOperation(block: completionHandler)
        if !operations.isEmpty {
            completionOperation.addDependency(operations[operations.count - 1])
        }
        addOperation(completionOperation)
    }
    
    /// Add an Array of chained Operations.
    ///
    /// Example:
    ///
    ///     [A, B, C] = A -> B -> C -> completionHandler.
    ///
    /// - Parameters:
    ///   - operations: Operations list.
    ///   - completionHandler: Completion block to be exectuted when all Operations
    ///                        are finished.
    public func addChainedOperations(_ operations: Operation..., completionHandler: (() -> Void)? = nil) {
        addChainedOperations(operations, completionHandler: completionHandler)
    }
    
    /// Not supported.
    ///
    /// Use addExecution instead. I can't report progress on block operation, which is the main goal of this class
    override open func addOperation(_ block: @escaping () -> Void) {
        fatalError("")
    }
    
    /// Not supported. DbOperationQueue is there to report progress on async execution
    override open func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        fatalError("Not supported. DbOperationQueue is there to report progress on async execution")
    }
}



