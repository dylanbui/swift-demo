//
//  Category.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/26/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper
//import ObjectMapperAdditions

//class Category: Object, Mappable // , CustomStringConvertible
class Category: DbRealmObject // , CustomStringConvertible
{
    @objc dynamic var categoryId: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var min: Int = 0
    @objc dynamic var max: Int = 1000
    @objc dynamic var defaultImage: String = ""
    
    override class func primaryKey() -> String? {
        return "categoryId"
    }
    
    //    convenience required init() {
    //        self.init()
    //        self.firstName = "chua xac dinh"
    //        self.lastName = "chua xac dinh"
    //    }
    
    required convenience init?(map: Map) {
        //fatalError("init(map:) has not been implemented")
        self.init()
    }
    
    override func mapping(map: Map)
    {
//        categoryId          <- map["categoryId"]
//        name                <- map["name"]
//        min                 <- map["min"]
//        max                 <- map["max"]
//        defaultImage        <- map["defaultImage"]
        //friends               <- (map["friends"], ListTransform<User>())
        
        super.mapping(map: map)
        // -- Chi co 1 cach nay de cuu do loi primaryKey --
        if map.mappingType == .fromJSON {
            categoryId          <- map["categoryId"]
            name                <- map["name"]
            min                 <- map["min"]
            max                 <- map["max"]
            defaultImage        <- map["defaultImage"]
        } else { // .toJSON
            categoryId          >>> map["categoryId"]
            name                >>> map["name"]
            min                 >>> map["min"]
            max                 >>> map["max"]
            defaultImage        >>> map["defaultImage"]
        }
    }
    
    override public var description: String {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }


}
