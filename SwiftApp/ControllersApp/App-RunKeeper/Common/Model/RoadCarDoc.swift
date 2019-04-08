//
//  RoadCarDoc.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/8/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

class RoadCarDoc: DbrmObjectMappable // , CustomStringConvertible
{
    @objc dynamic var autoId: String = ""
    @objc dynamic var note: String = ""
    @objc dynamic var distance: Int = 0 // Khoang cach (m)
    @objc dynamic var timeInterval: Int = 0 // Thoi gian di chuyen (s)
    @objc dynamic var pace: Int = 0 // Toc do trung binh (m/s)
    @objc dynamic var startTime: Date?
    @objc dynamic var endTime: Date?
    
    override class func primaryKey() -> String?
    {
        return "autoId"
    }
    
    convenience init(note: String)
    {
        self.init()
        self.autoId = UUID().uuidString
        self.note = note
    }
    
    required convenience init?(map: Map)
    {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        autoId                      <- map["autoId"]
        note                        <- map["note"]
        distance                    <- map["distance"]
        timeInterval                <- map["timeInterval"]
        pace                        <- map["pace"]
        startTime                   <- (map["startTime"], DateTransform())
        endTime                     <- (map["endTime"], DateTransform())
    }
    
    override public var description: String
    {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }
}
