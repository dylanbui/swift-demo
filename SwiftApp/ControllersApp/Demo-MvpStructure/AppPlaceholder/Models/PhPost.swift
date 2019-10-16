//
//  PhPost.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/16/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

class PhPost: Mappable
{
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
    
    required init?(map: Map)
    {
        self.mapping(map: map)
    }
    
    // Mappable
    func mapping(map: Map)
    {
        id                  <- map["id"]
        userId              <- map["userId"]
        title               <- map["title"]
        body                <- map["body"]
    }

}
