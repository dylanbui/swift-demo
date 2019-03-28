//
//  DbHttpExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/28/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Day la lop mo rong do DucBui phat trien de su dung https://github.com/JustHTTP/Just
//  Da rename cho de su dung

import Foundation

public protocol DbHTTPResponseProtocol {
    
    var httpResult: DbHTTPResult {get}
    
    init(result: DbHTTPResult)
    func parseResult() -> Void
}

// -- For demo --
public class SimpleResponse: DbHTTPResponseProtocol {
    
    public let httpResult: DbHTTPResult
    
    required public init(result: DbHTTPResult)
    {
        self.httpResult = result
    }
    
    public func parseResult() { }
}

public class MyGoogleResponse: DbHTTPResponseProtocol {
    
    public let httpResult: DbHTTPResult
    
    var result: [String: Any]?
    var addressComponents: [Any]?
    var formattedAddress: String?
    var geometry: Any?
    var placeId: String?
    
    required public init(result: DbHTTPResult) {
        self.httpResult = result
    }
    
    public func parseResult()
    {
        if httpResult.ok == false {
            return
        }
        
        guard let responseData = self.httpResult.json as? [String: Any] else {
            // -- responseData la nil , khong lam gi ca --
            print("GoogleResponse responseData == nil")
            return
        }
        
        print("GoogleResponse = \(responseData)")
        //let result: [AnyObject]? = responseData["results"] as? [AnyObject]
        
        if let results: [Any] = responseData["results"] as? [Any] {
            self.result = results[0] as? [String: Any]
            self.addressComponents = self.result!["address_components"] as? [Any]
            self.formattedAddress = self.result!["formatted_address"] as? String
            self.geometry = self.result!["geometry"] as Any
            self.placeId = self.result!["place_id"] as? String
        }
    }
    
}




extension ConnectionOf {
    
    @discardableResult
    public func requestFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        method: DbHTTPMethod,
        url: URLComponentsConvertible, // String Url
        params: [String: Any] = [:], // Method Get params
        data: [String: Any] = [:], // Post params
        json: Any? = nil, // Post with json
        asyncProgressHandler: (DbTaskProgressHandler)? = nil,
        asyncCompletionHandler: ((T) -> Void)? = nil
        ) -> T {
        
        let result = adaptor.request(
            method,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: [:],
            files: [:],
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            if let handle = asyncCompletionHandler {
                let res = typeObj.init(result: httpResult)
                res.parseResult()
                handle(res)
            }
        }
        
        let res = typeObj.init(result: result)
        res.parseResult()
        return res
    }
    
    public func jsonGetFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        url: URLComponentsConvertible, // String Url
        asyncProgressHandler: (DbTaskProgressHandler)? = nil,
        asyncCompletionHandler: @escaping ((T) -> Void)
        ) {
        
        // -- Khong goi lai ham requestFor<Res: DbHTTPResponseProtocol> duoc --
        _ = adaptor.request(
            .get,
            url: url,
            params: [:],
            data: [:],
            json: nil,
            headers: ["content-type": "application/json"], // Nen set json
            files: [:],
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            let res = typeObj.init(result: httpResult)
            res.parseResult()
            asyncCompletionHandler(res)
        }
        
    }
    
    public func jsonPostFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        url: URLComponentsConvertible, // String Url
        json: Any? = nil, // Post with json
        asyncProgressHandler: (DbTaskProgressHandler)? = nil,
        asyncCompletionHandler: @escaping ((T) -> Void)
        ) {
        
        // -- Khong goi lai ham requestFor<T: DbHTTPResponseProtocol> duoc --
        _ = adaptor.request(
            .post,
            url: url,
            params: [:],
            data: [:],
            json: json,
            headers: [:],
            files: [:],
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            let res = typeObj.init(result: httpResult)
            res.parseResult()
            asyncCompletionHandler(res)
        }
    }
    
    public func jsonUploadFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        url: URLComponentsConvertible, // String Url
        json: Any? = nil, // Post with json
        files: [String: DbHTTPFile],
        asyncProgressHandler: @escaping DbTaskProgressHandler,
        asyncCompletionHandler: @escaping ((T) -> Void)
        ) {
        
        // -- Khong goi lai ham requestFor<T: DbHTTPResponseProtocol> duoc --
        _ = adaptor.request(
            .post,
            url: url,
            params: [:],
            data: [:],
            json: json,
            headers: [:],
            files: files,
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            let res = typeObj.init(result: httpResult)
            res.parseResult()
            asyncCompletionHandler(res)
        }
        
    }
    
}
