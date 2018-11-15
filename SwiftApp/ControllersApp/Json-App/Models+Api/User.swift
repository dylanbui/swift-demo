//
//  User.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import ObjectMapper


class User: Mappable
{
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: [String : Any] = [:]
    
    var phone: String?
    var website: String?
    var company: [String : Any] = [:]
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        username        <- map["username"]
        email           <- map["email"]
        address         <- map["address"]
        phone           <- map["phone"]
        website         <- map["website"]
        company         <- map["company"]
    }
    
//    init(data: [String: AnyObject])
//    {
//        _ = Mapper().map(JSON: data, toObject: self)
//
//        // -- Dung 2 cach --
////        do {
////            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
////            let json: String = String(bytes: jsonData, encoding: String.Encoding.utf8)! //?? invalidJson
////            //Mapper<User>().map(JSONString: json)
////            //self.mapping(JSONString: json)
////            _ = Mapper().map(JSONString: json, toObject: self)
////
////        } catch {
////            // return invalidJson
////        }
//    }
    
    static func getAll(_ complete: @escaping ([User]) -> ())
    {
        DbHttp.get(Url: "https://jsonplaceholder.typicode.com/users") { (response) in
            
//            // if let err = response.error {
//            if response.error != nil {
//                // print("error.debugDescription = \(err.debugDescription)")
//                return
//            }
//            
////            if let anyObject = response.rawData {
//            if response.rawData != nil {
//                // print("response.rawData = nil")
//                return
//            }
//
//            var arr: [User] = []
//            for obj in response.rawData as! [AnyObject] {
//                let u:User = User(JSON: obj as! [String: Any])!
//                arr.append(u)
//            }
//            complete(arr)
        }
        
//        DbWebConnection.shared.get(Url: "https://jsonplaceholder.typicode.com/users", params: nil) { (anyObject, error) in
//            if error != nil {
//                print("error.debugDescription = \(error.debugDescription)")
//                return
//            }
////            if anyObject == nil {
////                print("AnyObject = nil")
////                return
////            }
//
//            guard let anyObject = anyObject else {
//                print("AnyObject = nil")
//                return
//            }
//
//            var arr: [User] = []
//            for obj in anyObject as! [AnyObject] {
//                let u:User = User(JSON: obj as! [String: Any])!
//                arr.append(u)
//            }
//            complete(arr)
//        }
        
    }
    
}
