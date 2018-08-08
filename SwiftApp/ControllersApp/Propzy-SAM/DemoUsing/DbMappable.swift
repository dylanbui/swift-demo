//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DbMappable.swift
//
//  Created by Dalton Cherry on 9/17/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//  Base : https://github.com/daltoniam/JSONJoy-Swift
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

// Khong SU DUNG

public protocol PzParsable {
    init(_ parse: Any)
    
    
    
}





public protocol DbMapperBasicType {}
extension String:   DbMapperBasicType {}
extension Int:      DbMapperBasicType {}
extension UInt:     DbMapperBasicType {}
extension Double:   DbMapperBasicType {}
extension Float:       DbMapperBasicType {}
extension NSNumber: DbMapperBasicType {}
extension Bool:     DbMapperBasicType {}

public enum DbMapperError: Error {
    case wrongType
}

open class DbMapper {
    var value: Any?
    
    /**
     Converts any raw object like a String or Data into a DbMappable object
     */
    public init(_ raw: Any, isSub: Bool = false) {
        var rawObject: Any = raw
        if let str = rawObject as? String, !isSub {
            rawObject = str.data(using: String.Encoding.utf8)! as Any
        }
        if let data = rawObject as? Data {
            var response: Any?
            do {
                try response = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                rawObject = response!
            }
            catch let error as NSError {
                value = error
                return
            }
        }
        if let array = rawObject as? NSArray {
            var collect = [DbMapper]()
            for val: Any in array {
                collect.append(DbMapper(val, isSub: true))
            }
            value = collect as Any?
        } else if let dict = rawObject as? NSDictionary {
            var collect = Dictionary<String,DbMapper>()
            for (key,val) in dict {
                collect[key as! String] = DbMapper(val as AnyObject, isSub: true)
            }
            value = collect as Any?
        } else {
            value = rawObject
        }
    }
    
    /**
     get typed `Array` of `DbMappable` and have it throw if it doesn't work
     */
    public func get<T: DbMappable>() throws -> [T] {
        guard let a = getOptionalArray() else { throw DbMapperError.wrongType }
        return try a.reduce([T]()) { $0 + [try T($1)] }
    }
    
    /**
     get typed `Array` and have it throw if it doesn't work
     */
    open func get<T: DbMapperBasicType>() throws -> [T] {
        guard let a = getOptionalArray() else { throw DbMapperError.wrongType }
        return try a.reduce([T]()) { $0 + [try $1.get()] }
    }
    
    /**
     get any type and have it throw if it doesn't work
     */
    open func get<T>() throws -> T {
        if let val = value as? Error {
            throw val
        }
        guard let val = value as? T else {throw DbMapperError.wrongType}
        return val
    }
    
    /**
     get any type as an optional
     */
    open func getOptional<T>() -> T? {
        do { return try get() }
        catch { return nil }
    }
    
    /**
     get an array
     */
    open func getOptionalArray() -> [DbMapper]? {
        return value as? [DbMapper]
    }
    
    /**
     get typed `Array` of `DbMappable` as an optional
     */
    public func getOptional<T: DbMappable>() -> [T]? {
        guard let a = getOptionalArray() else { return nil }
        do { return try a.reduce([T]()) { $0 + [try T($1)] } }
        catch { return nil }
    }
    
    /**
     get typed `Array` of `DbMappable` as an optional
     */
    public func getOptional<T: DbMapperBasicType>() -> [T]? {
        guard let a = getOptionalArray() else { return nil }
        do { return try a.reduce([T]()) { $0 + [try $1.get()] } }
        catch { return nil }
    }
    
    /**
     Array access support
     */
    open subscript(index: Int) -> DbMapper {
        get {
            if let array = value as? NSArray {
                if array.count > index {
                    return array[index] as! DbMapper
                }
            }
            return DbMapper(createError("index: \(index) is greater than array or this is not an Array type."))
        }
    }
    
    /**
     Dictionary access support
     */
    open subscript(key: String) -> DbMapper {
        get {
            if let dict = value as? NSDictionary {
                if let value: Any = dict[key] {
                    return value as! DbMapper
                }
            }
            return DbMapper(createError("key: \(key) does not exist or this is not a Dictionary type"))
        }
    }
    
    /**
     Simple helper method to create an error
     */
    func createError(_ text: String) -> Error {
        return NSError(domain: "DbMappable", code: 1002, userInfo: [NSLocalizedDescriptionKey: text]) as Error
    }
    
}

/**
 Implement this protocol on all objects you want to use DbMappable with
 */
public protocol DbMappable {
    init(_ decoder: DbMapper) throws
}

extension DbMapper: CustomStringConvertible {
    public var description: String {
        if let value = value {
            return String(describing: value)
        } else {
            return String(describing: value)
        }
    }
}

extension DbMapper: CustomDebugStringConvertible {
    public var debugDescription: String {
        if let value = value {
            return String(reflecting: value)
        } else {
            return String(reflecting: value)
        }
    }
}
