//
//  Actor.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/25/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class Actor: Object, Mappable {
    //    dynamic var username: NSString?
    //    var friends: List<User>?
    
    @objc dynamic var id: Int = -1
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    
    //    convenience required init() {
    //        self.init()
    //        self.firstName = "chua xac dinh"
    //        self.lastName = "chua xac dinh"
    //    }
    
    required convenience init?(map: Map)
    {
        self.init()
    }
    
    override class func primaryKey() -> String?
    {
        return "id"
    }
    
    func mapping(map: Map)
    {
//        //friends               <- (map["friends"], ListTransform<User>())
        
        // -- Chi co 1 cach nay de cuu do loi primaryKey --
        if map.mappingType == .fromJSON {
            id <- map["id"]
            firstName <- map["firstName"]
            lastName <- map["lastName"]
        } else { // .toJSON
            id >>> map["id"]
            firstName >>> map["firstName"]
            lastName >>> map["lastName"]
        }
        
    }
    
    
    
}
