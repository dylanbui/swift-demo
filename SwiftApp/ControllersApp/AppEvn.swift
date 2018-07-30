//
//  AppEvn.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/27/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Khong su dung

import Foundation

//public enum db {
//    static func aaaa(name: String) {
//        print(name)
//    }
//
//    class Employee {
//
//        var short_ID:Int = 0
//        var short_NAME:String = ""
//
//        init(id: Int, name: String) {
//            self.short_NAME = name
//            self.short_ID = id
//        }
//    }
//
//}
//

//FACEBOOK_ID_KEY:               @"437726473074188",
//// -- Key name : DIY iOS - Full Services Key (Production) --
//GOOGLE_SERVICE_API_KEY:        @"AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg",
////             GOOGLE_SERVICE_API_KEY:        @"AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg",
////             GOOGLE_PLACES_API_KEY:         @"AIzaSyD4thxU1wx7wEJT0G7twiBvlFae2XEUK6M",
//
////             API_BASE_URL_KEY:              @"http://124.158.14.22:9090/diy/api", // Production Server
////             UPLOAD_PHOTO_BASE_URL_KEY:     @"http://124.158.14.61:9090/file/api", // Production Server
//
//// -- Viettel server --
//API_BASE_URL_KEY:              @"http://app.propzy.vn:9090/diy/api", // Production Server
//UPLOAD_PHOTO_BASE_URL_KEY:     @"http://cdn.propzy.vn:9090/file/api", // Production Server
//
//PRODUCT_URL_KEY:               @"http://agents.propzy.vn/",
//SHARE_PRODUCT_URL_KEY:         @"http://propzy.vn/",
//
//MEDIA_URL_KEY:                 @"http://cdn.propzy.vn/media/%@"

public enum EvnConfigKey: String {
    case FACEBOOK_ID_KEY            = "FACEBOOK_ID_KEY"
    case GOOGLE_SERVICE_API_KEY     = "GOOGLE_SERVICE_API_KEY"
    case API_BASE_URL_KEY           = "API_BASE_URL_KEY"
    case PRODUCT_URL_KEY            = "PRODUCT_URL_KEY"
    case SHARE_PRODUCT_URL_KEY      = "SHARE_PRODUCT_URL_KEY"
    case MEDIA_URL_KEY              = "MEDIA_URL_KEY"
}

public enum AppEvn: String {
    case Developer = "Developer"
    case Test = "Test"
    case Production = "Production"
    
    var config: [EvnConfigKey: String] {
        switch self {
        case .Developer:
            return devConfig()
        case .Test:
            return testConfig()
        case .Production:
            return productionConfig()
        }
    }
    
    func configWith(Key key:EvnConfigKey) -> String {
        return config[key] ?? "none"
    }
    
    private func devConfig() -> [EvnConfigKey: String] {
        return [
            EvnConfigKey.FACEBOOK_ID_KEY: "",
            EvnConfigKey.GOOGLE_SERVICE_API_KEY: "",
            EvnConfigKey.API_BASE_URL_KEY: "",
            EvnConfigKey.PRODUCT_URL_KEY: "",
            EvnConfigKey.SHARE_PRODUCT_URL_KEY: "",
            EvnConfigKey.MEDIA_URL_KEY: "",
        ]
    }

    private func testConfig() -> [EvnConfigKey: String] {
        return [
            EvnConfigKey.FACEBOOK_ID_KEY: "",
            EvnConfigKey.GOOGLE_SERVICE_API_KEY: "",
            EvnConfigKey.API_BASE_URL_KEY: "",
            EvnConfigKey.PRODUCT_URL_KEY: "",
            EvnConfigKey.SHARE_PRODUCT_URL_KEY: "",
            EvnConfigKey.MEDIA_URL_KEY: "",
        ]
    }

    private func productionConfig() -> [EvnConfigKey: String] {
        return [
            EvnConfigKey.FACEBOOK_ID_KEY: "",
            EvnConfigKey.GOOGLE_SERVICE_API_KEY: "",
            EvnConfigKey.API_BASE_URL_KEY: "",
            EvnConfigKey.PRODUCT_URL_KEY: "",
            EvnConfigKey.SHARE_PRODUCT_URL_KEY: "",
            EvnConfigKey.MEDIA_URL_KEY: "",
        ]
    }

}
