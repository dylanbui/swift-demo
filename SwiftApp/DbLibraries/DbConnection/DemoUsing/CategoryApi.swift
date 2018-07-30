//
//  CategoryApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

class CategoryApi: PropzyBaseApi {
    
    class func getCategory(completionHandler: @escaping PropzyListHandler<Category>) -> Void
    {
        //request("http://45.117.162.49:8080/diy/api/categories", params: nil, requestId: 123, completionHandler: completionHandler)
//        requestFor("http://45.117.162.49:8080/diy/api/categories", params: nil, completionHandler: { (response: DbPropzyResponse?, error: Error?) in
//
//            completionHandler(parseToArray(Category.self, pzResponse: response!), error)
//
//            //            if (error != nil) {
//            //                // let aaa = parseToArray(Category.self, pzResponse: response!)
//            //                completionHandler(nil, error)
//            //            } else {
//            //                completionHandler(parseToArray(Category.self, pzResponse: response!), nil)
//            //            }
//        })
    }
    
    class func getCategoryObject(completionHandler: @escaping PropzyObjectHandler<Category>) -> Void
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
