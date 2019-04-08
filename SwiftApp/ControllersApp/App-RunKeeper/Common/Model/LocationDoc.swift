//
//  LocationDoc.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/5/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

class LocationDoc: DbrmObjectMappable // , CustomStringConvertible
{
    @objc dynamic var autoId: String = ""
    @objc dynamic var anchorId: Int = 0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var name: String?
    @objc dynamic var timestamp: Date?
    @objc dynamic var background: Bool = false
    
    var location: CLLocation!
    
    override class func primaryKey() -> String?
    {
        return "autoId"
    }
    
    convenience init(location: CLLocation, timestamp: Date, background: Bool = false)
    {
        self.init()
        
        self.autoId = UUID().uuidString
        self.location = location
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = timestamp
        self.background = background
        
//        self.geometry = Geometry.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        self.properties = Dictionary<String,String>()
//        self.properties["timestamp"] = (NSDate().timeIntervalSince1970 * 1000)
//        self.properties["background"] = background
        //
    }
    
    convenience init(anchorId: Int, location: CLLocation, timestamp: Date, background: Bool = false)
    {
        self.init(location: location, timestamp: timestamp, background: background)
        self.anchorId = anchorId
    }
    
    required convenience init?(map: Map)
    {
        self.init()
        self.mapping(map: map)
    }
    
    func toDictionary() -> DictionaryType
    {
        var dict: DictionaryType = [: ]
        dict["type"] = "Feature"
//        dict["created_at"] = self.properties["timestamp"]
//        dict["geometry"] = self.geometry!.toDictionary()
//        dict["properties"] = self.properties
        return dict
    }
    
    func mapping(map: Map)
    {
        autoId                    <- map["autoId"]
        anchorId                    <- map["anchorId"]
        latitude                   <- map["latitude"]
        longitude                   <- map["longitude"]
        name                   <- map["name"]
        timestamp             <- (map["timestamp"], DateTransform())
        background                   <- map["background"]
        
        self.location = CLLocation.init(latitude: self.latitude, longitude: self.longitude)
    }
    
    override public var description: String
    {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }
}


//class LocationDoc: NSObject {
//
//    var docId: String!
//    var geometry: Geometry!
//    var location: CLLocation!
//    var properties: DictionaryType = [:]
//
//    init(docId: String?, location: CLLocation, timestamp: NSDate, background: Bool = false)
//    {
//        self.docId = docId
//        self.location = location
//        self.geometry = Geometry.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        self.properties = Dictionary<String,String>()
//        self.properties["timestamp"] = (NSDate().timeIntervalSince1970 * 1000)
//        self.properties["background"] = background
//        //
//        super.init()
//    }
//
//    func toDictionary() -> DictionaryType
//    {
//        var dict: DictionaryType = [: ]
//        dict["type"] = "Feature"
//        dict["created_at"] = self.properties["timestamp"]
//        dict["geometry"] = self.geometry!.toDictionary()
//        dict["properties"] = self.properties
//        return dict
//    }
//}
