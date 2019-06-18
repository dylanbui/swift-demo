//
//  DbDataStructer.swift
//  PropzySam
//
//  Created by Dylan Bui on 5/29/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public typealias DictionaryType = [String: Any]

// -- Xu ly tra ve cua cac UIView action DbHandleAction(owner, id, params, error) --
public typealias DbHandleAction = (Any, Int, DictionaryType?, Error?) -> Void

public protocol DbIReturnDelegate {
    func onReturn(Owner object: Any?, callerId: Int?, params: DictionaryType?, error: Error?) -> Void
}

// -- Create DbIReturnDelegate is a optional --
public extension DbIReturnDelegate {
    func onReturn(Owner object: Any?, callerId: Int?, params: DictionaryType?, error: Error?) -> Void {
        
    }
}

// -- Default item for UIControl --

public protocol DbItemProtocol {
    var dbItemId: Int { get }
    var dbItemTitle: String { get }
    
    var dbItemDesc: String? { get }
    var dbRawValue: Any? { get set}
}

public extension DbItemProtocol {
    var dbItemDesc: String? {
        get {
            return nil
        }
    }
    var dbRawValue: Any? {
        get {
            return nil
        }
        set {
            
        }
    }
}

public class DbItem: DbItemProtocol, Equatable, CustomStringConvertible
{
    public var dbItemId: Int
    public var dbItemTitle: String
    public var dbItemDesc: String?
    public var dbRawValue: Any?
    
    // Extension CustomStringConvertible
    public var description: String {
        return "ItemId: \(dbItemId) - Desc: \(dbItemTitle)"
    }
    
    public init()
    {
        self.dbItemId = 0
        self.dbItemTitle = ""
    }
    
    public convenience init(id: Int, title: String, desc: String? = nil, raw: Any? = nil)
    {
        self.init()
        self.dbItemId = id
        self.dbItemTitle = title
        self.dbItemDesc = desc
        self.dbRawValue = raw
    }
}

public func ==(lhs: DbItem, rhs: DbItem) -> Bool {
    return lhs.dbItemId == rhs.dbItemId
}


/*
 Last-in first-out stack (LIFO)
 Push and pop are O(1) operations.
 */
public struct DbStackStructure<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
}

extension DbStackStructure: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            return curr.pop()
        }
    }
}

/*
 First-in first-out queue (FIFO)
 New elements are added to the end of the queue. Dequeuing pulls elements from
 the front of the queue.
 Enqueuing is an O(1) operation, dequeuing is O(n). Note: If the queue had been
 implemented with a linked list, then both would be O(1).
 */
public struct DbQueueStructure<T> {
    fileprivate var array = [T]()
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public var front: T? {
        return array.first
    }
}
