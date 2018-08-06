//
//  PzListingApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/6/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class PzListingApi: PropzyBaseApi {
    
    class func getListing(completionHandler: @escaping PropzyListHandler<PzListing>) -> Void
    {
        let url = ServiceUrl.createPath("/listing?access_token=\(UserSession.shared.accessToken!)")
        //request(strUrl: url, params: postParams, completionHandler: completionHandler)
        //requestListWithCache(strUrl: url, completionHandler: completionHandler)
        
        // -- Chay tot --
        requestListWithCache(strUrl: url) { (arr: [PzListing]?, pzResponse: PropzyResponse) in
            print("da lay xong")
            completionHandler(arr, pzResponse)
        }
        return;
    }
    
    class func getListingDetail(withId listingId:Int, completionHandler: @escaping PropzyObjectHandler<PzListingItem>) -> Void
    {
        let url = ServiceUrl.createPath("/listing/\(listingId)?access_token=\(UserSession.shared.accessToken!)")
        //request(strUrl: url, params: postParams, completionHandler: completionHandler)
        //requestListWithCache(strUrl: url, completionHandler: completionHandler)
        
        // -- Chay tot --
        requestObjectWithCache(strUrl: url, objectPrimaryKeyValue: listingId) { (itemCache: PzListingItem?, pzResponse: PropzyResponse) in
            print("da lay xong")
            completionHandler(itemCache, pzResponse)
        }
        return;
    }
    
}
