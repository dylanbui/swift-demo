//
//  PropertySearchApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

class PropertySearchApi: PzBaseApi
{
    // *** POST *** http://sc.propzy.vn/root/sam-service/wikis/get-properties
    class func getPropertiesMapPin(searchParam: PropertySearchParam, completionHandler: @escaping (Bool ,Int, [MapKitPin]) -> ())
    {
        let strUrl = "http://app.propzy.vn:9090/sam/api/get-properties" // Lay du lieu server production
        // -- Default value --
        searchParam.forMap = false
        
        var arrPin: [MapKitPin] = []
        
        print("--- Post data")
        print("\(searchParam.postData.description)")
        
        DbHTTP.requestFor(PzResponse.self, method: .post, url: strUrl, json: searchParam.postData, queue: pzBgNetworkQueue) { (pzResponse) in
            
            if !pzResponse.httpResult.ok {
                completionHandler(false, 0, arrPin)
                return
            }
            
            guard let jsonResult = pzResponse.data as? Dictionary<String, Any>,
                let dataArr = jsonResult["list"] as? [Any] else {
                completionHandler(false, 0, arrPin)
                return
            }
            
             print("\(String(describing: dataArr))")
            
            // -- Neu ton tai "list" key thi xu ly thang nay nhu 1 mang --
            for item in dataArr {
                if let jsonRes = item as? DictionaryType {
                    if let unitProperty = PropertyUnit.init(map: Map(mappingType: .fromJSON, JSON: jsonRes)) {
//                        print("-> \(String(describing: unitProperty.title))")
//                        print("   unitLocation?.coordinate = \(String(describing: unitProperty.unitLocation?.coordinate))")
                        let pin = MapKitPin.init(property: unitProperty)
                        arrPin.append(pin)
                    }
                }
            }
            completionHandler(true, arrPin.count, arrPin)
        }
    }
    
    class func getPropertiesMapPinInAreas(searchParam: PropertySearchParam, completionHandler: @escaping (Bool ,Int, [MapKitPin]) -> ())
    {
        let strUrl = "http://app.propzy.vn:9090/sam/api/get-properties" // Lay du lieu server production
        // -- Default value --
        searchParam.forMap = true
        
        print("--- Post data")
        // prettify == true => hien thi format json, nhung dinh \n khi luu
        print("[JSON Query]: \(searchParam.postData.db_jsonString(prettify: true) ?? "")")
        print("-------------")
        
        self.requestForList(strUrl: strUrl, method: .post, params: searchParam.postData, queue: pzBgNetworkQueue) { (arrPins: [MapKitPin]?, pzResponse: PzResponse) in
            
            guard let arrPins = arrPins else {
                completionHandler(false, 0, [])
                return
            }
            
            completionHandler(true, arrPins.count, arrPins)
        }
        
        // var arrPin: [MapKitPin] = []
//        DbHTTP.requestFor(PzResponse.self, method: .post, url: strUrl, json: searchParam.postData, queue: pzBgNetworkQueue) { (pzResponse) in
//
//            if !pzResponse.httpResult.ok {
//                completionHandler(false, 0, arrPin)
//                return
//            }
//
//            guard let jsonResult = pzResponse.data as? Dictionary<String, Any>,
//                let dataArr = jsonResult["list"] as? [Any] else {
//                    completionHandler(false, 0, arrPin)
//                    return
//            }
//
//            // print("\(String(describing: dataArr))")
//
//            // -- Neu ton tai "list" key thi xu ly thang nay nhu 1 mang --
//            for item in dataArr {
//                if let jsonRes = item as? DictionaryType {
//                    if let unitProperty = PropertyUnit.init(map: Map(mappingType: .fromJSON, JSON: jsonRes)) {
//                        //                        print("-> \(String(describing: unitProperty.title))")
//                        //                        print("   unitLocation?.coordinate = \(String(describing: unitProperty.unitLocation?.coordinate))")
//                        let pin = MapKitPin.init(property: unitProperty)
//                        arrPin.append(pin)
//                    }
//                }
//            }
//            completionHandler(true, arrPin.count, arrPin)
//        }
    }

    class func getListingForListView(searchParam: PropertySearchParam,
                                     showLoading: Bool = false,
                                 callback: @escaping (_ success: Bool,_ totalItems: Int,_ listingArray: [PropertyUnit]) -> ())
    {
        // let url = "http://45.117.162.39:8080/sam/api/get-properties"
        let url = "http://app.propzy.vn:9090/sam/api/get-properties" // Lay du lieu server production
    
        // -- Default value --
        searchParam.forMap = false
        //        print(searchParam.postData.toJSONString() ?? "")
        // var resultArray = [PropertyUnit]()
        
        requestForList(strUrl: url, method: .post, params: searchParam.postData, queue: pzBgNetworkQueue) { (arrResult: [PropertyUnit]?, pzResponse: PzResponse) in
            guard let arrResult = arrResult else {
                callback(false, 0, [])
                return
            }
            
            callback(true, arrResult.count, arrResult)
        }
        
//        PropertySearchApi.getProperties(searchParam.postData, showLoading: showLoading) { (response) in
//            if let dictionary: DictionaryType = response.data as? DictionaryType {
//                var totalItems = 0
//                if let total = dictionary["totalProperties"] as? Int {
//                    totalItems = total
//                }
//                if let array = dictionary["list"] as? [DictionaryType] {
//                    for dict in array {
//                        let listingUnit: ListingUnit = Mapper<ListingUnit>().map(JSON: dict)!
//                        let locationUnit: LocationUnit = Mapper<LocationUnit>().map(JSON: dict)!
//                        listingUnit.unitLocation = locationUnit
//                        resultArray.append(listingUnit)
//                    }
//                    callback(true, totalItems,resultArray)
//                    return
//                }
//            }
//            callback(false,0,nil)
//        }

    }
    
}

