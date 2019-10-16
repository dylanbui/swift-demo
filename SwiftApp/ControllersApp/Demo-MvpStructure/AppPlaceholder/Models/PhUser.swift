//
//  PhUser.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/16/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

class PhUser: Mappable
{
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: [String : Any] = [:]
    
    var phone: String?
    var website: String?
    var company: [String : Any] = [:]
    
    required init?(map: Map)
    {
        self.mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map)
    {
        id              <- map["id"]
        name            <- map["name"]
        username        <- map["username"]
        email           <- map["email"]
        address         <- map["address"]
        phone           <- map["phone"]
        website         <- map["website"]
        company         <- map["company"]
    }
}
