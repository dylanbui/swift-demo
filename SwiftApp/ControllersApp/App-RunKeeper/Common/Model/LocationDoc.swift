//
//  LocationDoc.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/5/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDoc: NSObject {
    
    var docId: String!
    var geometry: Geometry!
    var location: CLLocation!
    var properties: DictionaryType = [:]
    
    init(docId: String?, location: CLLocation, timestamp: NSDate, background: Bool = false)
    {
        self.docId = docId
        self.location = location
        self.geometry = Geometry.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.properties = Dictionary<String,String>()
        self.properties["timestamp"] = (NSDate().timeIntervalSince1970 * 1000)
        self.properties["background"] = background
        //
        super.init()
    }
    
    func toDictionary() -> DictionaryType
    {
        var dict: DictionaryType = [: ]
        dict["type"] = "Feature"
        dict["created_at"] = self.properties["timestamp"]
        dict["geometry"] = self.geometry!.toDictionary()
        dict["properties"] = self.properties
        return dict
    }
}
