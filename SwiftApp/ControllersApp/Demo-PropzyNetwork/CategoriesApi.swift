//
//  CategoriesApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/3/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation


class CategoriesApi: PropzyApi {
    
    class func getCategories(completionHandler: DbWebConnectionHandler) -> Void {
        
        request("http://124.158.14.30:8080/diy/api/categories", params: nil, requestId: 123, completionHandler: completionHandler)
        
    }
    
    class func getCategoriesWithDelegate(delegate: IDbWebConnectionDelegate, callerId: Int) -> Void {
        
        request("http://124.158.14.30:8080/diy/api/categories", params: nil, requestId: callerId, completionHandler: delegate)
        
    }
    
}
