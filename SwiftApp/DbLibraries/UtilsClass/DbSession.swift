//
//  DbSession.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/19/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

let DB_APP_SESSION_KEY: String! = "DB_APP_SESSION_KEY"
let DB_DEVICE_PUSH_TOKEN: String! = "DB_DEVICE_PUSH_TOKEN"
let DB_PUSH_NOTIFY_INFO_TOKEN: String! = "DB_PUSH_NOTIFY_INFO_TOKEN"

class DbSession: DbObject {
    
    var userId: String?
    var address: String?
    var email: String?
    var name: String?
    var phone: String?
    var photo: String?
    var createdDate: Date?
    var birthDay: String?
    
    var accessToken: String?
    
    var latitude: Double! = 0
    var longitude: Double! = 0
    
    // MARK: - Push Notify Info
    // MARK: -
    func getPushNotifyInfo() -> [String: AnyObject]? {
        return UserDefaults.getDictionary(key: DB_PUSH_NOTIFY_INFO_TOKEN)
    }
    
    func setPushNotifyInfo(_ params: [String: AnyObject]) {
        UserDefaults.setObject(key: DB_PUSH_NOTIFY_INFO_TOKEN, value: params)
    }
    
    // MARK: - Push Notification Token
    // MARK: -
    func getDevicePushNotificationToken() -> String {
        if Db.isSimulator() {
            return "notuser659ef7634ff919e6a866aab41b7bc60039339ac8cd85b90c888fb"
        }
        return UserDefaults.getString(key: DB_DEVICE_PUSH_TOKEN) ?? "not_found"
    }

    func setDevicePushNotificationToken(_ token: String) {
        UserDefaults.setObject(key: DB_DEVICE_PUSH_TOKEN, value: token)
    }
    
    func loadDataFrom(_ data: [String : Any]) {
        _ = Mapper().map(JSON: data, toObject: self)
    }

    // MARK: - Data From Last Session
    // MARK: -
    func reloadDataFromLastSession() {
        if let strJson = UserDefaults.getString(key: DB_APP_SESSION_KEY) {
            _ = Mapper().map(JSONString: strJson, toObject: self)
        }
    }
    
    func saveDataFromLastSession() {
        let strJson = self.toJSONString()
        UserDefaults.setObject(key: DB_APP_SESSION_KEY, value: strJson!)
    }
    
    func clearAllSessionData() {
        // -- Clear data --
        UserDefaults.remove(key: DB_APP_SESSION_KEY)
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
        createdDate     <- (map["createdDate"], DateTransform())
        birthDay        <- map["birthDay"]
        latitude        <- map["latitude"]
        longitude       <- map["longitude"]
        accessToken     <- map["accessToken"]
    }
    
    
}

extension DbSession: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description:String {
        return "==>accessToken           = " + (accessToken ?? "")
    }
    
    public var debugDescription:String {
        var output: [String] = []

        output.append("userId       = " + (userId ?? ""))
        output.append("address      = " + (address ?? ""))
        output.append("email        = " + (email ?? ""))
        output.append("name         = " + (name ?? ""))
        output.append("phone        = " + (phone ?? ""))
        output.append("photo        = " + (photo ?? ""))
        output.append("createdDate  = " + (createdDate?.db_string() ?? ""))
        output.append("birthDay     = " + (birthDay ?? ""))
        output.append("accessToken  = " + (accessToken ?? ""))
        
        return output.joined(separator: "\n")
    }
}

