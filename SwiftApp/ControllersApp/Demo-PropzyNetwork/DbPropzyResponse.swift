//
//  DbPropzyResponse.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/3/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

extension DataRequest {

    func responseObject<T: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            return .success(responseObject)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

public class DbPropzyResponse: ResponseObjectSerializable, CustomStringConvertible {
    
    var strUrl: String?
    var message: String?
    var result: Bool?
    var code: Int?
    var returnData: AnyObject?
    
    var validatedMessage: String?
    var additional: String?
    
    
    private var representation: [String: Any]?
    
    public var description: String {
        return "Response data: \(String(describing: representation))"
    }
    
    required public init?(response: HTTPURLResponse, representation: Any) {
        guard
            let url = response.url?.absoluteString,
            let representation = representation as? [String: Any],
            let returnData = representation["data"],
            let message = representation["message"] as? String,
            let result = representation["result"] as? Bool,
            let strCode = representation["code"] as? String
            else { return nil }
        
        self.representation = representation
        self.strUrl = url
        self.message = message
        self.result = result
        self.code = Int(strCode)
        self.returnData = returnData as AnyObject
        
        if let validatedMessage = representation["validatedMessage"] as? String, !validatedMessage.isEmpty {
            self.validatedMessage = validatedMessage
        } else {
            print("validatedMessage has wrong value")
        }

        if let additional = representation["additional"] as? String, !additional.isEmpty {
            self.additional = additional
        } else {
            print("additional has wrong value")
        }
        
//        guard let validatedMessage = representation["validatedMessage"] as? String, !validatedMessage.isEmpty else {
//            print("validatedMessage has wrong value")
//            validatedMessage = nil
//        }
//        self.validatedMessage = validatedMessage
        
//        let validatedMessage = representation["validatedMessage"] as? String,
//        let additional = representation["additional"] as? String
//        self.additional = additional
    }
}

/*
 
 Alamofire.request("https://example.com/users/mattt").responseObject { (response: DataResponse<DbPropzyResponse>) in
    debugPrint(response)
 
    if let propzy = response.result.value {
        print("User: { username: \(propzy.message), name: \(dictData.name) }")
    }
 }

 */

typealias DbWebConnectionHandler = (DbPropzyResponse?, Error?) -> ()

protocol IDbWebConnectionDelegate {
    func onRequestComplete(_ response: DbPropzyResponse, andCallerId callerId: Int) -> Void
    func onRequestError(_ error: Error, andCallerId callerId: Int) -> Void
}


public class PropzyApi {
    
    class func request<T: Mappable>(_ strUrl: String, method: HTTPMethod = .get, params: [String: String]? = nil, requestId: Int = 0, completionHandler: Any?) {
        // Phai duoc su dung trong ten bien
        let callbackBlock = completionHandler as? DbWebConnectionHandler
        let callbackDelegate = completionHandler as? IDbWebConnectionDelegate
        
        let dictHeaders = ["Accept-Encoding": "gzip", "Accept-Language": "vi-VN"]
        
        // -- Tao bg thread de run Alamofire --
        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        let dataRequest: DataRequest = Alamofire.request(strUrl, method: method,
                                                         parameters: params, encoding: URLEncoding.default,
                                                         headers: dictHeaders)
        
        _ = dataRequest.responseObject { (response: DataResponse<DbPropzyResponse>) in
            // debugPrint(response)
            
            if let propzy = response.result.value {
                
                if callbackBlock != nil {
                    callbackBlock?(propzy, nil)
                } else {
                    callbackDelegate?.onRequestComplete(propzy, andCallerId: requestId)
                }
                
//                guard let data = response.data else {
//                    return;
//                }
                
                if let dataArr = response.value?.returnData as? [AnyObject] {
                    
                    
                } else {
                    let dataObj = response.value?.returnData as! [String: AnyObject]
                    let a = T(map: Map(mappingType: .fromJSON, JSON: dataObj))
                }
                
                
                
                
                
                
                
                //                if let callbackBlock = completionHandler as? DbWebConnectionHandler {
                //                    callbackBlock(propzy, nil)
                //                    return
                //                }
                //                if let callbackDelegate = completionHandler as? IDbWebConnectionDelegate {
                //                    callbackDelegate.onRequestComplete(propzy, andCallerId: requestId)
                //                    return
                //                }
            }
            
            if let error = response.error {
                
                if callbackBlock != nil {
                    callbackBlock?(nil, error)
                } else {
                    callbackDelegate?.onRequestError(error, andCallerId: requestId)
                }
                
                //                if let callbackBlock = completionHandler as? DbWebConnectionHandler {
                //                    callbackBlock(nil, error)
                //                    return
                //                }
                //                if let callbackDelegate = completionHandler as? IDbWebConnectionDelegate {
                //                    callbackDelegate.onRequestError(error, andCallerId: requestId)
                //                    return
                //                }
            }
            
        }
        
        
    }
    
    class func request(_ strUrl: String, method: HTTPMethod = .get, params: [String: String]? = nil, requestId: Int = 0, completionHandler: Any?) {
        
        let callbackBlock = completionHandler as? DbWebConnectionHandler
        let callbackDelegate = completionHandler as? IDbWebConnectionDelegate
        
        let dictHeaders = ["Accept-Encoding": "gzip", "Accept-Language": "vi-VN"]
        
        // -- Tao bg thread de run Alamofire --
        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        let dataRequest: DataRequest = Alamofire.request(strUrl, method: method,
                                                         parameters: params, encoding: URLEncoding.default,
                                                         headers: dictHeaders)
        
        _ = dataRequest.responseObject { (response: DataResponse<DbPropzyResponse>) in
            // debugPrint(response)
            
            if let propzy = response.result.value {
                
                if callbackBlock != nil {
                    callbackBlock?(propzy, nil)
                } else {
                    callbackDelegate?.onRequestComplete(propzy, andCallerId: requestId)
                }
                
//                if let callbackBlock = completionHandler as? DbWebConnectionHandler {
//                    callbackBlock(propzy, nil)
//                    return
//                }
//                if let callbackDelegate = completionHandler as? IDbWebConnectionDelegate {
//                    callbackDelegate.onRequestComplete(propzy, andCallerId: requestId)
//                    return
//                }
            }

            if let error = response.error {
                
                if callbackBlock != nil {
                    callbackBlock?(nil, error)
                } else {
                    callbackDelegate?.onRequestError(error, andCallerId: requestId)
                }

//                if let callbackBlock = completionHandler as? DbWebConnectionHandler {
//                    callbackBlock(nil, error)
//                    return
//                }
//                if let callbackDelegate = completionHandler as? IDbWebConnectionDelegate {
//                    callbackDelegate.onRequestError(error, andCallerId: requestId)
//                    return
//                }
            }

        }
        
        
    }
    
    
}

