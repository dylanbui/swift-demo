//
//  CountryUnit.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/6/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

class CityUnit: DbRealmObject // , CustomStringConvertible
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
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        
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

class DistrictUnit: DbRealmObject // , CustomStringConvertible
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
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        
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

class WardUnit: DbRealmObject // , CustomStringConvertible
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
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        
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

