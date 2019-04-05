//
//  Geometry.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/5/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

class Geometry: NSObject
{
    var latitude: Double
    var longitude: Double
    
    init?(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
        
    func toDictionary() -> [String: Any]
    {
        var dict: [String:Any] = [:]
        dict["type"] = "Point"
        dict["coordinates"] = [self.longitude, self.latitude]
        return dict
    }
}

