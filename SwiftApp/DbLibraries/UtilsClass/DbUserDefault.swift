
//
//  UserDefault.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/18/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
// Khong con su dung , su dung extension cua UserDefault
public enum DbUserDefault {
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get value
    //-------------------------------------------------------------------------------------------
    
    static func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func getInt(key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func getBool(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func getFloat(key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
    
    static func getString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func getData(key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }
    
    static func getArray(key: String) -> [Any]? {
        return UserDefaults.standard.array(forKey: key)
    }
    
    static func getDictionary(key: String) -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: key)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Get value with default value
    //-------------------------------------------------------------------------------------------
    
    static func getObject(key: String, defaultValue: Any) -> Any? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getObject(key: key)
    }
    
    static func getInt(key: String, defaultValue: Int) -> Int {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getInt(key: key)
    }
    
    static func getBool(key: String, defaultValue: Bool) -> Bool {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getBool(key: key)
    }
    
    static func getFloat(key: String, defaultValue: Float) -> Float {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getFloat(key: key)
    }
    
    static func getString(key: String, defaultValue: String) -> String? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getString(key: key)
    }
    
    static func getData(key: String, defaultValue: Data) -> Data? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getData(key: key)
    }
    
    static func getArray(key: String, defaultValue: [Any]) -> [Any]? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getArray(key: key)
    }
    
    static func getDictionary(key: String, defaultValue: [String: Any]) -> [String: Any]? {
        if getObject(key: key) == nil {
            return defaultValue
        }
        return getDictionary(key: key)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
    static func setObject(key: String, value: Any?) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        synchronize()
    }
    
    static func setInt(key: String, value: Int) {
        UserDefaults.standard.set(value, forKey: key)
        synchronize()
    }
    
    static func setBool(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
        synchronize()
    }
    
    static func setFloat(key: String, value: Float) {
        UserDefaults.standard.set(value, forKey: key)
        synchronize()
    }
    
    static func setString(key: String, value: String?) {
        if (value == nil) {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.set(value, forKey: key)
        }
        synchronize()
    }
    
    static func setData(key: String, value: Data) {
        setObject(key: key, value: value)
    }
    
    static func setArray(key: String, value: NSArray) {
        setObject(key: key, value: value)
    }
    
    
    static func setDictionary(key: String, value: NSDictionary) {
        setObject(key: key, value: value)
    }
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Remove value
    //-------------------------------------------------------------------------------------------
    
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        synchronize()
    }
    
    static func clear(keys: [String]) {
        let dict = allValue()
        for key: String in dict!.keys {
            if (keys.contains(key)) {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        synchronize()
    }
    
    static func clearAllExcept(keys: [String]) {
        let dict = allValue()
        for key: String in dict!.keys {
            if (keys.contains(key)) {
                continue
            }
            UserDefaults.standard.removeObject(forKey: key)
        }
        synchronize()
    }
    
    static func allValue() -> [String: Any]? {
        return UserDefaults.standard.dictionaryRepresentation()
    }
    
    static func register(_ defaultDictionary: [String: Any]) {
        return UserDefaults.standard.register(defaults: defaultDictionary)
    }

}


