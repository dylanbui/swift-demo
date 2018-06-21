//
//  DbObject.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/19/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper


class DbObject: Mappable {

//    var username: String?
//    var age: Int?
//    var weight: Double!
//    var array: [Any]?
//    var dictionary: [String : Any] = [:]
//    var bestFriend: User?                       // Nested User object
//    var friends: [User]?                        // Array of Users
//    var birthday: Date?
    
    init() {

    }
    
    required init?(map: Map) {
        
    }
    
//    func setUserDefaultsData(object obj: Any, forKey key: String) {
//        UserDefaults.standard.setValue(obj, forKey: key)
//        UserDefaults.standard.synchronize()
//    }
//    
//    func getUserDefaultsData(forKey key: String) -> Any? {
//
//        return UserDefaults.standard.object(forKey: key)
//    }
//    
//    func removeUserDefaultsData(forKey key: String) {
//        UserDefaults.standard.removeObject(forKey: key)
//    }

    
    // Mappable
    func mapping(map: Map) {
//        username    <- map["username"]
//        age         <- map["age"]
//        weight      <- map["weight"]
//        array       <- map["arr"]
//        dictionary  <- map["dict"]
//        bestFriend  <- map["best_friend"]
//        friends     <- map["friends"]
//        birthday    <- (map["birthday"], DateTransform())
    }
}
