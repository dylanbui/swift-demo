//
//  RealmCommonUnit.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper


import Realm
import RealmSwift
import ObjectMapper
import EasyRealm



class DbCacheRealm {
    open class var shared: DbCacheRealm
    {
        struct Singleton {
            static let instance = DbCacheRealm()
        }
        return Singleton.instance
    }
    
    private init()
    {

    }
    
    // MARK: - Write function
    // MARK: -
    
    /// Write data for key
    public func write(data: Data, forKey key: String)
    {
        let record = CacheRecord()
        record.key = key
        record.content = data
        record.er.db_saveOrUpdate()
    }
    
    public func write(object: NSCoding, forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        self.write(data: data, forKey: key)
    }
    
    /// Write a string for key
    public func write(string: String, forKey key: String) {
        write(object: string as NSCoding, forKey: key)
    }
    
    /// Write a dictionary for key
    public func write(dictionary: Dictionary<AnyHashable, Any>, forKey key: String) {
        write(object: dictionary as NSCoding, forKey: key)
    }
    
    /// Write an array for key
    public func write(array: Array<Any>, forKey key: String) {
        write(object: array as NSCoding, forKey: key)
    }
    
    // MARK: - Read function
    // MARK: -
    
    /// Read data for key
    public func readData(forKey key:String) -> Data?
    {
        if let record = CacheRecord.er.db_fromRealm(with: key) {
            return record.content
        }
        return nil
    }
    
    /// Read an object for key. This object must inherit from `NSObject` and implement NSCoding protocol. `String`, `Array`, `Dictionary` conform to this method
    public func readObject(forKey key: String) -> NSObject? {
        let data = readData(forKey: key)
        
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSObject
        }
        
        return nil
    }
    
    /// Read a string for key
    public func readString(forKey key: String) -> String? {
        return readObject(forKey: key) as? String
    }
    
    /// Read an array for key
    public func readArray(forKey key: String) -> Array<Any>? {
        return readObject(forKey: key) as? Array<Any>
    }
    
    /// Read a dictionary for key
    public func readDictionary(forKey key: String) -> Dictionary<AnyHashable, Any>? {
        return readObject(forKey: key) as? Dictionary<AnyHashable, Any>
    }

    /// Clean all mem cache and disk cache. This is an async operation.
    public func cleanAll() {
        do {
            try CacheRecord.er.deleteAll()
        } catch { }
    }
    
    /// Clean cache by key. This is an async operation.
    public func clean(byKey key: String) {
        // CacheRecord.er.db_delete(WithCondition: "key = '\(key)'")
        CacheRecord.er.db_delete(ByPrimaryKey: key)
    }
}

internal class CacheRecord: Object
{
    // @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var key: String? = nil
    @objc dynamic var content: Data? = nil
    @objc dynamic var modifiedAt = Date()
    
    override class func primaryKey() -> String?
    {
        return "key"
    }
    
}

class CityRmUnit: DbrmObjectMappable // , CustomStringConvertible
{
    @objc dynamic var regionId: Int = -1
    @objc dynamic var countryId: Int = -1
    
    @objc dynamic var cityId: Int = -1
    @objc dynamic var cityName: String = ""
    @objc dynamic var cityNameEn: String = ""
    @objc dynamic var cityShortName: String = ""
    @objc dynamic var cityCode: String = ""
    
    override class func primaryKey() -> String?
    {
        return "cityId"
    }
    
    required convenience init?(map: Map)
    {
        //fatalError("init(map:) has not been implemented")
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        
        regionId                    <- map["regionId"]
        countryId                   <- map["countryId"]
        
        cityId                      <- map["cityId"]
        cityName                    <- map["cityName"]
        cityNameEn                  <- map["cityNameEn"]
        cityShortName               <- map["cityShortName"]
        cityCode                    <- map["cityCode"]
    }
    
    override public var description: String
    {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }
}

class DistrictRmUnit: DbrmObjectMappable // , CustomStringConvertible
{
    @objc dynamic var regionId: Int = -1
    @objc dynamic var countryId: Int = -1
    @objc dynamic var cityId: Int = -1
    
    @objc dynamic var districtId: Int = -1
    @objc dynamic var districtName: String = ""
    @objc dynamic var districtNameEn: String = ""
    @objc dynamic var districtShortName: String = ""
    
    override class func primaryKey() -> String?
    {
        return "districtId"
    }
    
    required convenience init?(map: Map)
    {
        //fatalError("init(map:) has not been implemented")
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        regionId                    <- map["regionId"]
        countryId                   <- map["countryId"]
        cityId                      <- map["cityId"]
        
        districtId                  <- map["districtId"]
        districtName                <- map["districtName"]
        districtNameEn              <- map["districtNameEn"]
        districtShortName           <- map["districtShortName"]
    }
    
    override public var description: String
    {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }
}

extension DistrictRmUnit: DbItemProtocol {
    var dbItemId: Int {
        return self.districtId
    }
    
    var dbItemTitle: String {
        return self.districtName
    }
}

class WardRmUnit: DbrmObjectMappable // , CustomStringConvertible
{
    @objc dynamic var regionId: Int = -1
    @objc dynamic var countryId: Int = -1
    @objc dynamic var cityId: Int = -1
    @objc dynamic var districtId: Int = -1
    
    @objc dynamic var wardId: Int = -1
    @objc dynamic var wardName: String = ""
    @objc dynamic var wardNameEn: String = ""
    @objc dynamic var wardShortName: String = ""
    @objc dynamic var orders: Int = -1
    
    
    override class func primaryKey() -> String?
    {
        return "wardId"
    }
    
    required convenience init?(map: Map)
    {
        //fatalError("init(map:) has not been implemented")
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        regionId                    <- map["regionId"]
        countryId                   <- map["countryId"]
        cityId                      <- map["cityId"]
        districtId                  <- map["districtId"]
        
        wardId                      <- map["wardId"]
        wardName                    <- map["wardName"]
        wardNameEn                  <- map["wardNameEn"]
        wardShortName               <- map["wardShortName"]
        orders                      <- map["orders"]
    }
    
    override public var description: String
    {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }
}
