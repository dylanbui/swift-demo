//
//  Category.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/26/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapperAdditions

import Realm
import RealmSwift

class Category: Object, Mappable // , CustomStringConvertible
{
    @objc dynamic var categoryId: Int = -1
    @objc dynamic var name: String = ""
    @objc dynamic var min: Int = 0
    @objc dynamic var max: Int = 1000
    @objc dynamic var defaultImage: String = ""
    
    //    convenience required init() {
    //        self.init()
    //        self.firstName = "chua xac dinh"
    //        self.lastName = "chua xac dinh"
    //    }
    
    required convenience init?(map: Map) {
        //fatalError("init(map:) has not been implemented")
        self.init()
    }
    
    func mapping(map: Map)
    {
        categoryId          <- map["categoryId"]
        name                <- map["name"]
        min                 <- map["min"]
        max                 <- map["max"]
        defaultImage        <- map["defaultImage"]
        //friends               <- (map["friends"], ListTransform<User>())
    }
    
    override public var description: String {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }


}
