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

/*
 Cac task khi hoan thanh deu o background thread. neu can update UI can chuyen len main thread
 
 DispatchQueue.main.async{
    // put your code here
 }
 
 hoac truyen DispatchQueue vao ham
 
 */


extension ConnectionOf
{
    public func requestFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        method: DbHTTPMethod,
        url: URLComponentsConvertible, // String Url
        params: [String: Any] = [:], // Method Get params
        data: [String: Any] = [:], // Post params
        json: Any? = nil, // Post with json
        headers: [String: String] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        queue: DispatchQueue? = nil,
        asyncProgressHandler: (DbTaskProgressHandler)? = nil,
        asyncCompletionHandler: @escaping ((T) -> Void))
    {
        _ = adaptor.request(
            method,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: [:],
            auth: auth,
            cookies: cookies,
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler) { (httpResult) in
                let res = typeObj.init(result: httpResult)
                res.parseResult()
                // (queue ?? DispatchQueue.global(qos: .utility)).async { handle(res) }
                if let thread = queue {
                    thread.async { asyncCompletionHandler(res) }
                } else {
                    asyncCompletionHandler(res)
                }
        }
    }
    
    public func jsonGetFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        url: URLComponentsConvertible, // String Url
        queue: DispatchQueue? = nil,
        asyncProgressHandler: (DbTaskProgressHandler)? = nil,
        asyncCompletionHandler: @escaping ((T) -> Void))
    {
        // -- DucBui 21/06/2019 : fix --
        self.requestFor(T.self, method: .get, url: url,
                        headers: ["content-type": "application/json"], // Nen set json
            queue: queue,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler)
    }
    
    public func jsonPostFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        url: URLComponentsConvertible, // String Url
        json: Any? = nil, // Post with json
        queue: DispatchQueue? = nil,
        asyncProgressHandler: (DbTaskProgressHandler)? = nil,
        asyncCompletionHandler: @escaping ((T) -> Void))
    {
        // -- DucBui 21/06/2019 : fix --
        self.requestFor(T.self, method: .post, url: url, json: json,
                        headers: ["content-type": "application/json"], // Nen set json
            queue: queue,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler)
    }
    
    public func jsonUploadFor<T: DbHTTPResponseProtocol>(
        _ typeObj: T.Type,
        url: URLComponentsConvertible, // String Url
        params: [String: Any] = [:], // Url get params
        data: [String: Any] = [:], // Post with Dictionary
        json: Any? = nil, // Post with json
        files: [String: DbHTTPFile],
        queue: DispatchQueue? = nil,
        asyncProgressHandler: @escaping DbTaskProgressHandler,
        asyncCompletionHandler: @escaping ((T) -> Void))
    {
        // -- Khong goi lai ham requestFor<T: DbHTTPResponseProtocol> vi la upload, requestFor ko co files --
        _ = adaptor.request(
            .post,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: ["content-type": "application/json"], // Nen set json
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
            // (queue ?? DispatchQueue.global(qos: .utility)).async { asyncCompletionHandler(res) }
            if let thread = queue {
                thread.async { asyncCompletionHandler(res) }
            } else {
                asyncCompletionHandler(res)
            }
        }
    }
    
}
