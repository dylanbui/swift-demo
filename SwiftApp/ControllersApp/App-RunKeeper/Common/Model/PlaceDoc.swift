//
//  PlaceDoc.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/5/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

class PlaceDoc: NSObject
{
    var docId: String?
    var geometry: Geometry?
    var name: String?
    var timestamp: Double?
    
    init?(docId: String?, latitude: Double, longitude: Double, name: String, timestamp: NSDate)
    {
        self.docId = docId
        self.geometry = Geometry(latitude: latitude, longitude: longitude)
        self.name = name
        self.timestamp = (NSDate().timeIntervalSince1970 * 1000)
        //
        super.init()
    }
    
    convenience init?(aDict dict: DictionaryType)
    {
        if let body = dict["doc"] as? DictionaryType {
            var geometry: DictionaryType? = body["geometry"] as? DictionaryType
            var coordinates: [Double]? = geometry!["coordinates"] as? [Double]
            let latitude: Double = coordinates![1]
            let longitude: Double = coordinates![0]
            let name: String? = body["name"] as? String
            let timestamp: Double? = body["created_at"] as? Double
            self.init(docId: body["_id"] as? String, latitude: latitude, longitude: longitude, name: name!, timestamp: NSDate(timeIntervalSince1970: Double(timestamp!)/1000.0))
        }
        else {
            print("Error initializing place from dictionary: \(dict)")
            return nil
        }
    }
    
    func toDictionary() -> DictionaryType
    {
        var dict: DictionaryType = [:]
        dict["type"] = "Feature"
        dict["created_at"] = self.timestamp
        dict["geometry"] = self.geometry!.toDictionary()
        dict["name"] = self.name
        return dict
    }
}
