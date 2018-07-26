//
//  CategoriesApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/3/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation


class CategoriesApi: PropzyApi {
    
    //class func getCategories(completionHandler: @escaping ([Category]?, Error?) -> Void) -> Void {
    
    class func getCategories(completionHandler: @escaping PzListHandler<Category>) -> Void
    {
        //request("http://45.117.162.49:8080/diy/api/categories", params: nil, requestId: 123, completionHandler: completionHandler)
        
        requestFor("http://45.117.162.49:8080/diy/api/categories", params: nil, completionHandler: { (response: DbPropzyResponse?, error: Error?) in
            
            completionHandler(parseToArray(Category.self, pzResponse: response!), error)
            
//            if (error != nil) {
//                // let aaa = parseToArray(Category.self, pzResponse: response!)
//                completionHandler(nil, error)
//            } else {
//                completionHandler(parseToArray(Category.self, pzResponse: response!), nil)
//            }
        })
    }
    
    class func getCategoriesObject(completionHandler: @escaping PzObjectHandler<Category>) -> Void
    {
        //request("http://45.117.162.49:8080/diy/api/categories", params: nil, requestId: 123, completionHandler: completionHandler)
        
        requestFor("http://45.117.162.49:8080/diy/api/categories", params: nil, completionHandler: { (response: DbPropzyResponse?, error: Error?) in
            
            completionHandler(parseToArray(Category.self, pzResponse: response!)?.first, error)
            
//            if let arr = parseToArray(Category.self, pzResponse: response!) {
//                completionHandler(arr.first, error)
//                return
//            }
//            completionHandler(nil, error)
            
        })
    }
    
    class func getCategoriesWithDelegate(delegate: IDbWebConnectionDelegate, callerId: Int) -> Void {
        
//        request("http://124.158.14.30:8080/diy/api/categories", params: nil, requestId: callerId, completionHandler: delegate)
//        (DbPropzyResponse?, Error
        
        requestFor("http://45.117.162.49:8080/diy/api/categories", params: nil, completionHandler: { (response: DbPropzyResponse?, error: Error?) in            
//            if error != nil {
//                print("Error = \(String(describing: error))")
//                return
//            }
//            print("getCategories: ")
//            print("\(String(describing: response?.data))")
        })
        

        
        
    }
    
}
