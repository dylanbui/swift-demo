//
//  UserApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class UserApi: PropzyBaseApi {
    
    class func doLogin(_ parameters: Dictionary<String, String>, completionHandler: @escaping DbDispatchHandler) -> Void
    {        
        let url = ServiceUrl.shared.getServiceUrl(ServerKey.API_BASE_URL_KEY) + "/user/signIn"
        var postParams = ["osName" : "iOs",
                      "deviceName" : UIDevice.current.deviceType.displayName,
                      "versionName" : UIDevice.current.systemVersion]
        // -- Merge --
        postParams += parameters
        // -- Call request --
        // -- Khi chay den day, chi con loi do he thong propzy --
        // -- Network and response error will be process in parent class --
        request(strUrl: url, params: postParams, completionHandler: completionHandler)
        
//        request(strUrl: url, params: postParams) { (response) in
//            // -- Khi chay den day, chi con loi do he thong propzy --
//            // -- Network and response error will be process in parent class --
//            completionHandler(response)
//        }
    }
    
    class func register(completionHandler: @escaping PropzyObjectHandler<Category>) -> Void
    {
        //request("http://45.117.162.49:8080/diy/api/categories", params: nil, requestId: 123, completionHandler: completionHandler)
        //        requestFor("http://45.117.162.49:8080/diy/api/categories", params: nil, completionHandler: { (response: DbPropzyResponse?, error: Error?) in
        //
        //            completionHandler(parseToArray(Category.self, pzResponse: response!)?.first, error)
        //
        //            //            if let arr = parseToArray(Category.self, pzResponse: response!) {
        //            //                completionHandler(arr.first, error)
        //            //                return
        //            //            }
        //            //            completionHandler(nil, error)
        //
        //        })
    }
}
