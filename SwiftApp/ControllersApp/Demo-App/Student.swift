//
//  Student.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

import ObjectMapper
import ObjectMapperAdditions

//class Student: DbRealmObject
//{
//    @objc dynamic var id: Int = -1
//    @objc dynamic var firstName: String = ""
//    @objc dynamic var lastName: String = ""
//    
////    convenience required init() {
////        self.init()
////        self.firstName = "chua xac dinh"
////        self.lastName = "chua xac dinh"
////    }
//    
//    required convenience init?(map: Map) {
//        fatalError("init(map:) has not been implemented")
//    }
//    
////    override class func primaryKey() -> String? {
////        return "id"
////    }
//    
////    override func defaultPrimaryKey() -> String {
////        return "id"
////    }
//    
//    override func mapping(map: Map)
//    {
////        id                      <- map["id"]
////        id                      <- map["id"]
////        firstName               <- map["firstName"]
////        lastName                <- map["lastName"]
//        //friends               <- (map["friends"], ListTransform<User>())
//
//        // .toJSON() requires Realm write transaction or it'll crash
////        let isWriteRequired = realm != nil && realm?.isInWriteTransaction == false
////        isWriteRequired ? realm?.beginWrite() : ()
////
////        // id <- map["id"]
////        id <- (map["id"], IntTransform())
////
////        // firstName <- map["firstName"]
////        firstName <- (map["firstName"], StringTransform())
////
////        // lastName <- map["lastName"]
////        lastName <- (map["lastName"], StringTransform())
////
////        isWriteRequired ? try? realm?.commitWrite() : ()
//        
//        if map.mappingType == .fromJSON {
//            id <- map["id"]
//            firstName <- map["firstName"]
//            lastName <- map["lastName"]
//        } else {
//            id >>> map["id"]
//            firstName >>> map["firstName"]
//            lastName >>> map["lastName"]
//        }
//        
////        if map.mappingType == .toJSON {
////            id <- map["id"]
////        }
//        
////        if map.mappingType == .toJSON {
////            var id = self.id
////            id <- map["id"]
////        }
////        else {
////            id <- map["id"]
////        }
//        
////        if map.mappingType == .fromJSON {
////            id <- map["id"]
////        } else {
////            id >>> map["id"]
////        }
////
//    }
//
//    
//    
//}
