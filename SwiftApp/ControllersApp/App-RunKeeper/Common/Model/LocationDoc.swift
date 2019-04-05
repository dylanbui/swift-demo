//
//  LocationDoc.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/5/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

class LocationDoc: NSObject {
    
    var docId: String!
    var geometry: Geometry!
    var properties: DictionaryType = [:]
    
    init(docId: String?, latitude: Double, longitude: Double,
         timestamp: NSDate, background: Bool?)
    {
        self.docId = docId
        self.geometry = Geometry(latitude: latitude, longitude: longitude)
        self.properties = Dictionary<String,String>()
        self.properties["timestamp"] = (NSDate().timeIntervalSince1970 * 1000)
        self.properties["background"] = (background == nil ? false : background)
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
