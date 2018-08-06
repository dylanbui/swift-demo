//
//  PzListing.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/6/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import ObjectMapper

class PzListing: DbRealmObject
{
    @objc dynamic var diyId: Int = -1
    @objc dynamic var rlistingId: Int = -1
    @objc dynamic var latitude: Float = 0
    @objc dynamic var longitude: Float = 0

    @objc dynamic var listingTypeId: Int = -1
    @objc dynamic var propertyTypeId: Int = -1
    
    @objc dynamic var address: String = ""
    @objc dynamic var houseNumberRoad: String = ""
    
    override class func primaryKey() -> String? {
        return "diyId"
    }
    
    // -- ko dung duoc --
//    convenience required init() {
//        self.init()
//    }
    
    required convenience init?(map: Map) {
        //fatalError("init(map:) has not been implemented")
        self.init()
    }
    
    override func mapping(map: Map)
    {
        super.mapping(map: map)
        // -- Chi co 1 cach nay de cuu do loi primaryKey --
        if map.mappingType == .fromJSON {
            diyId                       <- map["diyId"]
            rlistingId                  <- map["rlistingId"]
            latitude                    <- map["latitude"]
            longitude                   <- map["longitude"]
            listingTypeId               <- map["listingTypeId"]
            propertyTypeId              <- map["propertyTypeId"]
            address                     <- map["address"]
            houseNumberRoad             <- map["houseNumberRoad"]
        } else { // .toJSON
            diyId                       >>> map["diyId"]
            rlistingId                  >>> map["rlistingId"]
            latitude                    >>> map["latitude"]
            longitude                   >>> map["longitude"]
            listingTypeId               >>> map["listingTypeId"]
            propertyTypeId              >>> map["propertyTypeId"]
            address                     >>> map["address"]
            houseNumberRoad             >>> map["houseNumberRoad"]

        }
    }

}

