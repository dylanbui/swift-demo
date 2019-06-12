//
//  PzAdminApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

class PzAdminApi: PzBaseApi
{
    class func getDistrictList(completionHandler: @escaping DbPzListHandler<DistrictRmUnit>) -> Void
    {
        let url = "http://45.117.162.39:8080/sam/api/districts/-1"
        // -- Chay tot --
//        requestListWithCache(strUrl: url) { (arr: [DistrictRmUnit]?, pzResponse: PzResponse) in
//            print("da lay xong DISTRICT")
//            completionHandler(arr, pzResponse)
//        }

        // -- Test thu cache --
        cacheRequestForList(strUrl: url, cacheName: "api_districts") { (arr: [DistrictRmUnit]?, pzResponse: PzResponse) in
            print("da lay xong DISTRICT")
            completionHandler(arr, pzResponse)
        }
        
    }
    
    class func getWardList(completionHandler: @escaping DbPzListHandler<WardRmUnit>) -> Void
    {
        let url = "http://45.117.162.39:8080/sam/api/wards/-1"
        
        // -- Chay tot --
        requestListWithCache(strUrl: url) { (arr: [WardRmUnit]?, pzResponse: PzResponse) in
            print("da lay xong WARD")
            completionHandler(arr, pzResponse)
        }
    }
    
    class func getWardBy(District districtId: Int, completionHandler: @escaping DbPzListHandler<WardRmUnit>) -> Void
    {
        let url = "http://45.117.162.39:8080/sam/api/wards/\(districtId)"
        
        // -- Lay ve ward theo district => save or update to Ward Table --
        requestListWithCache(strUrl: url) { (arr: [WardRmUnit]?, pzResponse: PzResponse) in
            print("da lay xong WARD")
            if arr != nil {
                completionHandler(arr, pzResponse)
                return
            }
            
            // -- Lay tu cache Ward Table voi districtId condition --
            let arrWard = WardRmUnit.er.db_all(WithCondition: "districtId = \(districtId)")
            completionHandler(arrWard, pzResponse)
        }
        
    }
}
