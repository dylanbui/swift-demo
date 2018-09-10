//
//  CountryUnitApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/6/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

class CountryUnitApi: PropzyBaseApi
{
    class func synchronizeUnitDataWithServer(completionHandler: (() -> Void)?) -> Void
    {
        let group = DbGroup()
        // -- City --
        group.async(DbQueue.global(.background)) { () -> (Void) in
            group.enter()
            CountryUnitApi.getCityList(completionHandler: { (arrCityUnit, pzResponse) in
                group.leave()
            })
        }
        // -- District --
        group.async(DbQueue.global(.background)) { () -> (Void) in
            group.enter()
            CountryUnitApi.getDistrictList(completionHandler: { (arrCityUnit, pzResponse) in
                group.leave()
            })
        }
        // -- Ward --
        group.async(DbQueue.global(.background)) { () -> (Void) in
            group.enter()
            CountryUnitApi.getWardList(completionHandler: { (arrCityUnit, pzResponse) in
                group.leave()
            })
        }
        // -- Call Main Thread --
        group.notify(DbQueue.main) { () -> (Void) in
            completionHandler?()
        }
    }
    
    class func getCityList(completionHandler: @escaping PropzyListHandler<CityUnit>) -> Void
    {
        // let url = ServiceUrl.createPath("/categories")
        let url = "http://45.117.162.60:8080/sam/api/cities/-1"
        //request(strUrl: url, params: postParams, completionHandler: completionHandler)
        //requestListWithCache(strUrl: url, completionHandler: completionHandler)
        
        // -- Chay tot --
        requestListWithCache(strUrl: url) { (arr: [CityUnit]?, pzResponse: PropzyResponse) in
            print("da lay xong CITY")
            completionHandler(arr, pzResponse)
        }

    }
    
    class func getDistrictList(completionHandler: @escaping PropzyListHandler<DistrictUnit>) -> Void
    {
        // let url = ServiceUrl.createPath("/categories")
        let url = "http://45.117.162.60:8080/sam/api/districts/-1"
        //request(strUrl: url, params: postParams, completionHandler: completionHandler)
        //requestListWithCache(strUrl: url, completionHandler: completionHandler)
        
        // -- Chay tot --
        requestListWithCache(strUrl: url) { (arr: [DistrictUnit]?, pzResponse: PropzyResponse) in
            print("da lay xong DISTRICT")
            completionHandler(arr, pzResponse)
        }
        
    }
    
    class func getWardList(completionHandler: @escaping PropzyListHandler<WardUnit>) -> Void
    {
        // let url = ServiceUrl.createPath("/categories")
        let url = "http://45.117.162.60:8080/sam/api/wards/-1"
        //request(strUrl: url, params: postParams, completionHandler: completionHandler)
        //requestListWithCache(strUrl: url, completionHandler: completionHandler)
        
        // -- Chay tot --
        requestListWithCache(strUrl: url) { (arr: [WardUnit]?, pzResponse: PropzyResponse) in
            print("da lay xong WARD")
            completionHandler(arr, pzResponse)
        }
        
    }
}
