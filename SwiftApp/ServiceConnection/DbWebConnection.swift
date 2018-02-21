//
//  DbWebConnection.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/21/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import AFNetworking

typealias DataTaskSuccessHandler = (URLResponse?, AnyObject?) -> Void
typealias DataTaskErrorHandler = (URLResponse?, AnyObject?, Error?) -> Void
typealias DataTaskProcessHandler = (Progress?) -> ()

typealias DispatchSuccessHandler = (DbResponse) -> Void
typealias DispatchErrorHandler = (DbResponse, Error?) -> Void
typealias DispatchProcessHandler = (Progress?) -> Void




class MyResponse: DbResponse
{
    var message: String?
    var result: Bool?
    var code: Int?
    
    required init()
    {
        super.init()

    }
    
    override func parse(_ responseData: AnyObject?, error: Error?)
    {
        super.parse(responseData, error: error)

    }
}

//class DbUploadData: NSObject
//{
//    var fileData: NSData?
//    var fileId: String?
//    var fileName: String?
//    var mimeType: String?
//}

protocol IDbWebConnectionDelegate
{
    func onRequestCompleteWithContent(_ content: AnyObject, andCallerId callerId: Int);
    func onRequestErrorWithContent(_ content: AnyObject, andCallerId callerId: Int, andError error: NSError);
    
    func onRequestProgress(_ downloadProgress: Progress, andCallerId callerId: Int);
}

typealias DbWebConnectionBlock = (AnyObject?, Error?) -> Void

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
    
    func get(Url url: String, params: [String: AnyObject]?, block: DbWebConnectionBlock?) -> Void
    {
        self.request(Url: url, withMethod: "GET", parameters: params,
                     progressHandler: nil,
                     successHandler: { (urlResponse, anyData) in
                        if let block = block {
                            block(anyData, nil)
                        }
        }) { (urlResponse, anyData, error) in
            if let block = block {
                block(nil, error)
            }
        }
    }
    
    func post(Url url: String, params: [String: AnyObject]?, block: DbWebConnectionBlock?) -> Void
    {
        self.request(Url: url, withMethod: "POST", parameters: params,
                     progressHandler: nil,
                     successHandler: { (urlResponse, anyData) in
                        if let block = block {
                            block(anyData, nil)
                        }
        }) { (urlResponse, anyData, error) in
            if let block = block {
                block(nil, error)
            }
        }
    }

    // -- Co the khong su dung gia tri tra ve --
    @discardableResult func dispatchSynchronous(Request request: DbRequest) -> DbResponse
    {
        let dispatchGroup = DispatchGroup() //dispatch_semaphore_t = dispatch_semaphore_create(0)

        dispatchGroup.enter()
        self.dispatch(Request: request) { (response) in
            dispatchGroup.leave()
        }
        // -- Wait until dispatchGroup done --
        dispatchGroup.wait()
        return request.response!
    }
    
    func dispatch(Request request: DbRequest ,successHandler success: DispatchSuccessHandler?)
    {
        // -- Default Request Serializer --
        self.sessionManager?.requestSerializer = AFHTTPRequestSerializer()
        if request.contentType == DbHttpContentType.JSON {
            self.sessionManager?.requestSerializer = AFJSONRequestSerializer()
        }
        // -- Default Response Serializer --
        self.sessionManager?.responseSerializer = AFHTTPResponseSerializer()
        if let response = request.response {
            if response.contentType! == DbHttpContentType.JSON {
                self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
            }
        } else {
            // -- Default response --
            request.response = DbResponse()
            request.contentType = DbHttpContentType.JSON
            self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
        }
        
        var serializationError: NSError?
        let rawRequest = self.sessionManager?.requestSerializer.request(withMethod: request.method.rawValue, urlString: request.requestUrl, parameters: request.query, error: &serializationError)
        
        if serializationError != nil {
            print("serializationError : %@", serializationError.debugDescription)
            return
        }
        // -- Add header to request --
        for header in request.headers {
            header.setRequestHeader(request: rawRequest!)
        }
        
        var dataTask: URLSessionDataTask?
        dataTask = self.sessionManager?.dataTask(with: rawRequest as URLRequest!, uploadProgress: { (progress) in
            // -- Dont process --
        }, downloadProgress: { (progressData: Progress) in
            print("downloadProgress")
        }, completionHandler: { (urlResponse, anyData, error) in
            if let success = success {
                // -- TODO: Set data for response --
                if let response = request.response {
                    response.parse(anyData as AnyObject, error: error)
                    success(response)
                    print("response \(String(describing: response.rawData))")
                }
            }
        })
        dataTask?.resume()
    }
    
    func dispatch(Request request: DbRequest, withResponse response: DbResponse
        ,progressHandler progress: DispatchProcessHandler?
        ,successHandler success: DispatchSuccessHandler?
        ,failureHandler failure: DispatchErrorHandler?)
    {
        // -- Default Request Serializer --
        self.sessionManager?.requestSerializer = AFHTTPRequestSerializer()
        if request.contentType == DbHttpContentType.JSON {
            self.sessionManager?.requestSerializer = AFJSONRequestSerializer()
        }
        // -- Default Response Serializer --
        self.sessionManager?.responseSerializer = AFHTTPResponseSerializer()
        if response.contentType! == DbHttpContentType.JSON {
            self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
        }
        
        var serializationError: NSError?
        let rawRequest = self.sessionManager?.requestSerializer.request(withMethod: request.method.rawValue, urlString: request.requestUrl, parameters: request.query, error: &serializationError)
        
        if serializationError != nil {
            print("serializationError : %@", serializationError.debugDescription)
            return
        }
        // -- Add header to request --
        for header in request.headers {
            header.setRequestHeader(request: rawRequest!)
        }
        
        var dataTask: URLSessionDataTask?
        dataTask = self.sessionManager?.dataTask(with: rawRequest as URLRequest!, uploadProgress: { (progress) in
            // -- Dont process --
        }, downloadProgress: { (progressData: Progress) in
            print("downloadProgress")
            if let progress = progress {
                progress(progressData)
            }
        }, completionHandler: { (urlResponse, anyData, error) in
            if let error = error, let failure = failure {
                print("error \(error)")
                // -- TODO: Set data for response --
                response.error = error
                failure(response, error)
            } else if let success = success {
                // -- TODO: Set data for response --
                response.parse(anyData as AnyObject!, error: nil)
                success(response)
                print("response \(String(describing: response.rawData))")
            }
        })
        
        dataTask?.resume()

        
    }

    func request(Url strUrl: String, withMethod method: String, parameters params: [String:AnyObject]?
        ,progressHandler progress: DataTaskProcessHandler?
        ,successHandler success: DataTaskSuccessHandler?
        ,failureHandler failure: DataTaskErrorHandler? )
    {
        
        self.sessionManager?.requestSerializer = AFJSONRequestSerializer()
        self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
        
        
        var serializationError: NSError?
        let request = self.sessionManager?.requestSerializer.request(withMethod: method, urlString: strUrl, parameters: params, error: &serializationError)
        
        request?.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request?.addValue("vi-VN", forHTTPHeaderField: "Accept-Language")
        
        if serializationError != nil {
            print("serializationError : %@", serializationError.debugDescription)
            return
        }
        
//        open func dataTask(with request: URLRequest, uploadProgress uploadProgressBlock: ((Progress) -> Swift.Void)?, downloadProgress downloadProgressBlock: ((Progress) -> Swift.Void)?, completionHandler: ((URLResponse, Any?, Error?) -> Swift.Void)? = nil) -> URLSessionDataTask

        
        var dataTask: URLSessionDataTask?
        

//        dataTask = self.sessionManager?.dataTask(with: request as URLRequest!, completionHandler: { (urlResponse, anyData, error) in
//            
//        })
        
        dataTask = self.sessionManager?.dataTask(with: request as URLRequest!, uploadProgress: { (progress) in
            // -- Dont process --
        }, downloadProgress: { (progressData) in
            if let progress = progress {
                progress(progressData)
            }
        }, completionHandler: { (urlResponse, anyData, error) in
            if let error = error, let failure = failure {
                failure(urlResponse, anyData as AnyObject!, error)
            } else if let success = success {
                success(urlResponse, anyData as AnyObject!)
            }
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
