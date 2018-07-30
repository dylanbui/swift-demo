//
//  UserSession.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import ObjectMapper

class UserSession: DbSession
{
//    @property (strong, nonatomic) NSString      *objectType;
//    @property (strong, nonatomic) NSString      *accessToken;
//    @property (strong, nonatomic) NSString      *accountId;
//    @property (strong, nonatomic) NSString      *socialUid;
//    @property (strong, nonatomic) NSString      *userTypeId;
//    @property (strong, nonatomic) NSString      *userTypeName;
//    @property (assign, nonatomic) int       userType;
//
//    @property (nonatomic, assign) int       numberListings;
    
    var appEvnMode: ServerMode {
        get {
            return ServerMode.PRODUCTION_CONFIG
        }
        set { }
    }
    
    
    
    
    static let shared = UserSession()
    
    private override init() {
        super.init()
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
        //super.init(map: map)
    }

    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        
//        userId          <- map["userId"]
//        address         <- map["address"]
//        email           <- map["email"]
//        name            <- map["name"]
//        phone           <- map["phone"]
//        photo           <- map["photo"]
//        latitude        <- map["latitude"]
//        longitude       <- map["longitude"]
    }

    
}
