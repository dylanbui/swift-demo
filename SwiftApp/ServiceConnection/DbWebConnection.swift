//
//  DbWebConnection.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/21/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import AFNetworking

class DbResponse: NSObject
{
    var message: String?
    var result: Bool?
    var code: Int?
    var data: Any?
    
    override init()
    {
        super.init()
        
    }
}

class DbUploadData: NSObject
{
    var fileData: NSData?
    var fileId: String?
    var fileName: String?
    var mimeType: String?
}

protocol IDbWebConnectionDelegate
{
    func onRequestCompleteWithContent(_ content: Any, andCallerId callerId: Int);
    func onRequestErrorWithContent(_ content: Any, andCallerId callerId: Int, andError error: NSError);
    
    func onRequestProgress(_ downloadProgress: Progress, andCallerId callerId: Int);
}

typealias DbResponseBlock = (Any, NSError) -> Void

class DbWebConnection: NSObject
{
    static let shared = DbWebConnection()
    
    var isReachable: Bool?
    var sessionManager: AFHTTPSessionManager?
    
    // MARK: - Accessors
    class func sharedInstance() -> DbWebConnection
    {
        return shared
    }
    
    private override init()
    {
        super.init()
        self.isReachable = AFNetworkReachabilityManager.shared().isReachable
        self.sessionManager = AFHTTPSessionManager()
    }
    

    func sayhi()
    {
        self.sessionManager?.requestSerializer = AFJSONRequestSerializer()
        self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
        
        var serializationError: NSError?
        let request = self.sessionManager?.requestSerializer.request(withMethod: "POST", urlString: "", parameters: nil, error: &serializationError)
        
        request?.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request?.addValue("vi-VN", forHTTPHeaderField: "Accept-Language")
        
        if serializationError != nil {
            print("serializationError : %@", serializationError.debugDescription)
            return
        }
        
        var dataTask: URLSessionDataTask?

        dataTask = self.sessionManager?.dataTask(with: request as URLRequest, completionHandler: { (urlResponse, anyData, error) in
            
        })
        dataTask?.resume()
        
        // -- Set Request is Json --
//        [sessionManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
//        // -- Set Response is Json --
//        [sessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
//
//        NSError *serializationError = nil;
//        NSMutableURLRequest *request = [sessionManager.requestSerializer requestWithMethod:method
//            URLString:[[NSURL URLWithString:strURL relativeToURL:nil] absoluteString]
//            parameters:dictParams
//            error:&serializationError];
//        // -- Use gzip decompression --
//        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//        [request setValue:@"vi-VN" forHTTPHeaderField:@"Accept-Language"];
//
//        if (serializationError) {
//            NSLog(@"serializationError : %@", [serializationError description]);
//            return;
//        }
        
        
    }
    
    // https://gist.github.com/mcxiaoke/3edc23720fcbf589af134c914dd8a0a3
    /// Return data from synchronous URL request
    func requestSynchronousData(_ request: URLRequest) -> Data?
    {
        var data: Data? = nil
        let dispatchGroup = DispatchGroup() //dispatch_semaphore_t = dispatch_semaphore_create(0)

        dispatchGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { (taskData, response, error) in
            data = taskData
            if data == nil, let error = error {print(error)}
            dispatchGroup.leave()
        }
        
        task.resume()
        // -- Wait until dispatchGroup done --
        dispatchGroup.wait()
        return data
    }
        
    /// Return data synchronous from specified endpoint
    func requestSynchronousDataWithURLString(_ requestString: String) -> Data?
    {
        guard let url = URL(string:requestString) else {return nil}
        let request = URLRequest(url: url)
        return self.requestSynchronousData(request)
    }
    
    /// Return JSON synchronous from URL request
    func requestSynchronousJSON(_ request: URLRequest) -> AnyObject?
    {
        guard let data = self.requestSynchronousData(request) else {return nil}
//        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
//        return jsonData as AnyObject
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as AnyObject
    }
    
    /// Return JSON synchronous from specified endpoint
    func requestSynchronousJSONWithURLString(requestString: String) -> AnyObject?
    {
        guard let url = URL(string:requestString) else {return nil}
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return self.requestSynchronousJSON(request)
    }
    
}
