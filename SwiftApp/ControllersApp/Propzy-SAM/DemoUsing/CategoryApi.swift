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
        let url = ServiceUrl.createPath("/categories")
        //request(strUrl: url, params: postParams, completionHandler: completionHandler)
        //requestListWithCache(strUrl: url, completionHandler: completionHandler)

        // -- Chay tot --
        requestListWithCache(strUrl: url) { (arr: [Category]?, pzResponse: PropzyResponse) in
            print("da lay xong")
            completionHandler(arr, pzResponse)
        }
        return;
        
        // -- Xu ly cache with Realm --
//        requestForList(strUrl: url) { (arr: [Category]?, pzResponse: PropzyResponse) in
//            if let arrCat = arr {
//                // -- Co du lieu tra ve tu Service --
//                // -- Save to Realm data, if existed primary key will be override  --
//                DbRealmManager.saveArrayObjects(T: arrCat, completion: { (success) in
//                    print("Da ghi category thanh cong")
//                })
//                completionHandler(arrCat, pzResponse)
//            } else {
//                // -- Khong co du lieu tra ve tu Service => get from Realm db --
//                DbRealmManager.getAllListOf(T: Category(), completionHandler: { (arrCategory) in
//                    completionHandler(arrCategory as? [Category], pzResponse)
//                })
//            }
//        }
        
//        requestForList(strUrl: url, completionHandler: completionHandler)
        
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
