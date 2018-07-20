//
//  ServiceUrl.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/29/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

fileprivate let DEV_CONFIG_DATA: [String: String] = [
    "FACEBOOK_ID_KEY":               "498695030305903",
    "GOOGLE_SERVICE_API_KEY":        "AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg",
    "GOOGLE_PLACES_API_KEY":         "AIzaSyD4thxU1wx7wEJT0G7twiBvlFae2XEUK6M",
    
    "API_BASE_URL_KEY":              "http://124.158.14.30:8080/diy/api", // Develop Server
    "UPLOAD_PHOTO_BASE_URL_KEY":     "http://124.158.14.30:8080/file/api", // Develop Server
    
    "PRODUCT_URL_KEY":               "http://develop.agents.propzy.vn/",
    "SHARE_PRODUCT_URL_KEY":         "http://develop.propzy.vn/",
    
    "MEDIA_URL_KEY":                 "http://develop.cdn.propzy.vn/media_test/%@"
]

fileprivate let TEST_CONFIG_DATA: [String: String] = [
    "FACEBOOK_ID_KEY":               "437726473074188",
    "GOOGLE_SERVICE_API_KEY":        "AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg",
    "GOOGLE_PLACES_API_KEY":         "AIzaSyD4thxU1wx7wEJT0G7twiBvlFae2XEUK6M",
    
    "API_BASE_URL_KEY":              "http://124.158.14.32:8080/diy/api", // Test Server
    "UPLOAD_PHOTO_BASE_URL_KEY":     "http://124.158.14.32:8080/file/api", // Test Server
    
    "PRODUCT_URL_KEY":               "http://agents.propzy.vn/",
    "SHARE_PRODUCT_URL_KEY":         "http://propzy.vn/",
    
    "MEDIA_URL_KEY":                 "http://cdn.propzy.vn/media/%@"
]

fileprivate let PRODUCTION_CONFIG_DATA: [String: String] = [
    "FACEBOOK_ID_KEY":               "498695030305903",
    "GOOGLE_SERVICE_API_KEY":        "AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg",
    "GOOGLE_PLACES_API_KEY":         "AIzaSyD4thxU1wx7wEJT0G7twiBvlFae2XEUK6M",
    
    "API_BASE_URL_KEY":              "http://124.158.14.22:9090/diy/api", // Production Server
    "UPLOAD_PHOTO_BASE_URL_KEY":     "http://124.158.14.22:9090/file/api", // Production Server
    
    "PRODUCT_URL_KEY":               "http://agents.propzy.vn/",
    "SHARE_PRODUCT_URL_KEY":         "http://propzy.vn/",
    
    "MEDIA_URL_KEY":                 "http://cdn.propzy.vn/media/%@"
]

public enum ServerKey: String {
    case FACEBOOK_ID_KEY = "FACEBOOK_ID_KEY"
    case GOOGLE_SERVICE_API_KEY = "GOOGLE_SERVICE_API_KEY"
    case GOOGLE_PLACES_API_KEY = "GOOGLE_PLACES_API_KEY"
    
    case API_BASE_URL_KEY = "API_BASE_URL_KEY"
    case UPLOAD_PHOTO_BASE_URL_KEY = "UPLOAD_PHOTO_BASE_URL_KEY"
    case PRODUCT_URL_KEY = "PRODUCT_URL_KEY"

    case SHARE_PRODUCT_URL_KEY = "SHARE_PRODUCT_URL_KEY"
    case MEDIA_URL_KEY = "MEDIA_URL_KEY"
}



public enum ServerMode: Int {
    case DEV_CONFIG = 0
    case TEST_CONFIG = 1
    case PRODUCTION_CONFIG = 2
    
    var configData: [String: String] {
        switch self {
        case .DEV_CONFIG:
            return DEV_CONFIG_DATA
        case .TEST_CONFIG:
            return TEST_CONFIG_DATA
        case .PRODUCTION_CONFIG:
            return PRODUCTION_CONFIG_DATA
        }
    }
    
    var name: String {
        switch self {
        case .DEV_CONFIG:
            return "Dev Mode"
        case .TEST_CONFIG:
            return "Test Mode"
        case .PRODUCTION_CONFIG:
            return "Production Mode"
        }
    }
    
    var serverModeData: [String: Int] {
        return ["1. Dev Mode": ServerMode.DEV_CONFIG.rawValue,
                "2. Test Mode": ServerMode.TEST_CONFIG.rawValue,
                "3. Production Mode": ServerMode.PRODUCTION_CONFIG.rawValue]
    }
    
    
}

typealias SelectServerModeHandle = (ServerMode) -> Void

class ServiceUrl {
    
    static let shared = ServiceUrl()
    
    var serverMode :ServerMode! = ServerMode.PRODUCTION_CONFIG
    
    private var compeleteSelect: SelectServerModeHandle?
    
    private init() {

    }
    
    func getServiceUrl(_ key: ServerKey) -> String {
        if let api = self.serverMode.configData[key.rawValue] {
            return api
        }
        return ""
    }
    
    func getAppConfig(byMode server: ServerMode) -> [String: String] {
        return self.serverMode.configData
    }
    
    func addChangeModeControl(_ view: UIView, selectHandle: SelectServerModeHandle?) -> Void {
        self.compeleteSelect = selectHandle
        
        let myButton = UIButton.init(type: .roundedRect)
        myButton.frame = CGRect(Db.screenWidth() - 145, 20, 130, 30);
        

        
        // let arrOption = Array(self.serverMode.serverModeData.keys)
        // let arrOption = [String] (self.serverMode.serverModeData.keys)
        
        myButton.setTitle(self.serverMode.name, for: .normal)
        myButton.backgroundColor = UIColor.white
        
        myButton.addTarget(self, action: #selector(btnChangeServer_Click), for: .touchUpInside)
        view.addSubview(myButton)
    }
    
    @objc private func btnChangeServer_Click(sender: UIButton) -> Void {
        let arrOption = [ServerMode.DEV_CONFIG.name, ServerMode.TEST_CONFIG.name, ServerMode.PRODUCTION_CONFIG.name]
        
        let options = DbSelectorActionSheet(title: "Chọn server: ", dismissButtonTitle: "Done", otherButtonTitles: arrOption, dismissOnSelect: true)
        options.selectedIndex = serverMode.rawValue;
        options.showWith { (buttonIndex, isCancel) in
            if !isCancel {
                self.serverMode = ServerMode.init(rawValue: buttonIndex) //buttonIndex as! ServerMode
                sender.setTitle(self.serverMode.name, for: .normal)
                if let complete = self.compeleteSelect {
                    complete(self.serverMode)
                }
            }
        }
    }
    
}
