//
//  Student.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

//import DbRealmObject

import ObjectMapper
//import RealmSwift
//import ObjectMapper_Realm

class Student: DbRealmObject
{
    @objc dynamic var id: Int = -1
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    
//    convenience required init() {
//        self.init()
//        self.firstName = "chua xac dinh"
//        self.lastName = "chua xac dinh"
//    }
    
    required convenience init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override func mapping(map: Map) {
        
        if map.mappingType == .fromJSON {
            id <- map["id"]
            firstName <- map["firstName"]
            lastName <- map["lastName"]
        } else {
            id >>> map["id"]
            firstName >>> map["firstName"]
            lastName >>> map["lastName"]
        }
        
//        if map.mappingType == .toJSON {
//            id <- map["id"]
//        }
        
//        if map.mappingType == .toJSON {
//            var id = self.id
//            id <- map["id"]
//        }
//        else {
//            id <- map["id"]
//        }
        
//        if map.mappingType == .fromJSON {
//            id <- map["id"]
//        } else {
//            id >>> map["id"]
//        }
//
//        firstName               <- map["firstName"]
//        lastName                <- map["lastName"]
        //friends               <- (map["friends"], ListTransform<User>())
    }

    
    
}
