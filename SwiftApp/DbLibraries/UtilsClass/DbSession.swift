//
//  DbSession.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/19/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

let APP_SESSION_KEY: String! = "APP_SESSION_KEY"
let DEVICE_PUSH_TOKEN: String! = "DEVICE_PUSH_TOKEN"
let PUSH_NOTIFY_INFO_TOKEN: String! = "PUSH_NOTIFY_INFO_TOKEN"


class DbSession: DbObject {
    
    var userId: String?
    var address: String?
    var email: String?
    var name: String?
    var phone: String?
    var photo: String?
    
    var latitude: Double! = 0
    var longitude: Double! = 0
    
    // MARK: - Push Notify Info
    // MARK: -

    func getPushNotifyInfo() -> [String: AnyObject]? {
        return self.getUserDefaultsData(forKey: PUSH_NOTIFY_INFO_TOKEN) as? [String: AnyObject]
    }
    
    func setPushNotifyInfo(_ params: [String: AnyObject]) {
        self.setUserDefaultsData(object: params, forKey: PUSH_NOTIFY_INFO_TOKEN)
    }
    
    // MARK: - Push Notification Token
    // MARK: -
    func getDevicePushNotificationToken() -> String? {
        if Db.isSimulator() {
            return "notuser659ef7634ff919e6a866aab41b7bc60039339ac8cd85b90c888fb"
        }
        return self.getUserDefaultsData(forKey: DEVICE_PUSH_TOKEN) as? String
    }

    func setDevicePushNotificationToken(_ token: String) {
        self.setUserDefaultsData(object: token, forKey: DEVICE_PUSH_TOKEN)
    }

    // MARK: - Data From Last Session
    // MARK: -
    func reloadDataFromLastSession() {
        if let strJson = self.getUserDefaultsData(forKey: APP_SESSION_KEY) as? String {
            _ = Mapper().map(JSONString: strJson, toObject: self)
        }
    }
    
    func saveDataFromLastSession() {
        let strJson = self.toJSONString()
        self.setUserDefaultsData(object: strJson!, forKey: APP_SESSION_KEY)
    }
    
    func clearAllSessionData() {
        // -- Clear data --
        self.removeUserDefaultsData(forKey: APP_SESSION_KEY)
    }
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        userId          <- map["userId"]
        address         <- map["address"]
        email           <- map["email"]
        name            <- map["name"]
        phone           <- map["phone"]
        photo           <- map["photo"]
        latitude        <- map["latitude"]
        longitude       <- map["longitude"]
    }
    
    
}
