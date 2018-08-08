//
//  adad.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/7/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import ObjectMapper
//import SwiftyJSON

public class JsonStringTransform: TransformType {
    
    
    
//    public typealias Object = String
//    public typealias JSON = JSON
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Any? {
//        if let jsonString = value as? String {
////            return JSON(jsonString)
//
//            guard let data = jsonString.data(using: .utf8, allowLossyConversion: false) else { return nil }
//            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//
////            let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
////            if let jsonData = data {
////                // Will return an object or nil if JSON decoding fails
////                return JSONSerialization.JSONObjectWithData(jsonData, options: JSONSerialization.ReadingOptions.MutableContainers, error: nil)
////            }
//        }
        return nil
    }
    
    public func transformToJSON(_ value: Any?) -> String? {
//        if let obj = value {
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
//                return String(bytes: jsonData, encoding: String.Encoding.utf8)
//            } catch {
////                return invalidJson
//            }
//
////            let jsonData = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
////            return String(bytes: jsonData, encoding: String.Encoding.utf8)
//
////            let json = JSON(obj)
////            return json.raw
//        }
        return nil
    }
    
//    public typealias Object = Date
//    public typealias JSON = Double
//
//    public init() {}
//
//    open func transformFromJSON(_ value: Any?) -> Date? {
//        if let timeInt = value as? Double {
//            return Date(timeIntervalSince1970: TimeInterval(timeInt))
//        }
//
//        if let timeStr = value as? String {
//            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
//        }
//
//        return nil
//    }
//
//    open func transformToJSON(_ value: Date?) -> Double? {
//        if let date = value {
//            return Double(date.timeIntervalSince1970)
//        }
//        return nil
//    }
}


//public class StringTransform: TransformType {
//    public typealias Object = String
//    public typealias JSON = String
//
//    public init() {}
//
//    public func transformFromJSON(_ value: Any?) -> Object? {
//        if value == nil {
//            return nil
//        } else if let string = value as? String {
//            return string
//        } else if let int = value as? Int {
//            return String(int)
//        } else if let double = value as? Double {
//            return String(double)
//        } else if let bool = value as? Bool {
//            return (bool ? "true" : "false")
//        } else if let number = value as? NSNumber {
//            return number.stringValue
//        } else {
//            #if DEBUG
//            print("Can not cast value \(value!) of type \(type(of: value!)) to type \(Object.self)")
//            #endif
//
//            return nil
//        }
//    }
//
//    public func transformToJSON(_ value: Object?) -> JSON? {
//        return value
//    }
//}

