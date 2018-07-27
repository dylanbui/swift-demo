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

struct PzError: Error
{
    let code: Int
    let message: String
    
    init(_ code:Int, message: String) {
        self.code = code
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
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

public class DbPropzyResponse: ResponseObjectSerializable, CustomStringConvertible
{
    var strUrl: String?
    var message: String?
    var result: Bool?
    var code: Int?
    var returnData: AnyObject?
    
    var validatedMessage: String?
    var additional: String?
    
    // -- Custom error --
    var error: PzError?
    
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
            // print("validatedMessage has wrong value"). Demo
        }

        if let additional = representation["additional"] as? String, !additional.isEmpty {
            self.additional = additional
        } else {
            // print("additional has wrong value"). Demo
        }
        
        // -- Custom error --
        if (self.result == false) {
            // self.error = NSError(domain: self.message ?? "", code: self.code ?? 0, userInfo: nil)
            self.error = PzError.init(self.code ?? 0, message: self.message ?? "Khong xac dinh")
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

typealias DbWebConnectionHandler = (DbPropzyResponse?, Error?) -> Void

protocol IDbWebConnectionDelegate {
    func onRequestComplete(_ response: DbPropzyResponse, andCallerId callerId: Int) -> Void
    func onRequestError(_ error: Error, andCallerId callerId: Int) -> Void
}

typealias PzWebConnectionHandler = (DbPropzyResponse?, Error?) -> Void

protocol IPzWebConnectionDelegate {
    func onRequestComplete(_ response: DbPropzyResponse, andCallerId callerId: Int) -> Void
    func onRequestError(_ error: Error, andCallerId callerId: Int) -> Void
}

// ---------------------------------------------------------------

typealias PzListHandler<T: Mappable> = (_ obj :[T]?, Error?) -> ()
typealias PzObjectHandler<T: Mappable> = (_ obj :T?, Error?) -> ()

protocol IPzApiConnectionDelegate {
    associatedtype elementType
    
    func onRequestComplete(WithList response: [elementType], andCallerId callerId: Int) -> Void
    func onRequestComplete(WithObject response: elementType, andCallerId callerId: Int) -> Void
    func onRequestError(_ error: Error, andCallerId callerId: Int) -> Void
}

// Da xu ly duoc nua duong
// Cam thay roi ram them nen chuyen lai phien ban goc, nhung cai nay hay co nhieu phan ky thuat tot phai rang tip tuc nghien cuu


public class PropzyApi {
    
    class func parseToArray<T: Mappable>(_ obj: T.Type, pzResponse: DbPropzyResponse) -> [T]?
    {
        var arr: [T] = []
        if let dataArr = pzResponse.returnData as? [AnyObject] {
            for item in dataArr {
                if let jsonResult = item as? Dictionary<String, Any> {
                    // do whatever with jsonResult
                    arr.append(T(JSON: jsonResult)!)
                }
            }
            return arr
        } else if let jsonResult = pzResponse.returnData as? Dictionary<String, Any> {
            arr.append(T(JSON: jsonResult)!)
        }
        return nil
    }
    
//    class func parseToObject<T: Mappable>(_ obj: T, pzResponse: DbPropzyResponse) -> T?
//    {
//        if let jsonResult = pzResponse.returnData as? Dictionary<String, Any> {
//            return T(JSON: jsonResult)
//        }
//        return nil
//    }
    
    class func requestFor<T: Mappable>(Object obj: T.Type, strUrl: String, method: HTTPMethod = .get, params: [String: String]? = nil, completionHandler: Any?) {
        
        let dictHeaders = ["Accept-Encoding": "gzip", "Accept-Language": "vi-VN"]
        
        // -- Tao bg thread de run Alamofire --
        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        let dataRequest: DataRequest = Alamofire.request(strUrl, method: method,
                                                         parameters: params, encoding: URLEncoding.default,
                                                         headers: dictHeaders)
        
        _ = dataRequest.responseObject { (response: DataResponse<DbPropzyResponse>) in
            
            //        let callbackListBlock = completionHandler as? PzListHandler<T>
            //        let callbackObjectDelegate = completionHandler as? PzObjectHandler<T>
            
//            if let callbackListBlock = completionHandler as? PzListHandler<T> {
//
//            } else if let callbackObjectDelegate = completionHandler as? PzObjectHandler<T> {
//
//            } else {
//                fatalError("May la thang nao")
//                return
//            }
            
            // debugPrint(response)
//            if let propzy = response.result.value {
//                completionHandler?(propzy, nil)
//                return
//            }
//
//            if let error = response.error {
//                completionHandler?(nil, error)
//            }
        }
    }
    
    
    class func requestFor(_ strUrl: String, method: HTTPMethod = .get, params: [String: String]? = nil, completionHandler: PzWebConnectionHandler?) {
        
        let dictHeaders = ["Accept-Encoding": "gzip", "Accept-Language": "vi-VN"]
        
        // -- Tao bg thread de run Alamofire --
        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        let dataRequest: DataRequest = Alamofire.request(strUrl, method: method,
                                                         parameters: params, encoding: URLEncoding.default,
                                                         headers: dictHeaders)
        
        _ = dataRequest.responseObject { (response: DataResponse<DbPropzyResponse>) in
            // debugPrint(response)
            
            if let error = response.error as? AFError {
                let userInfor: [String: Any] = [NSLocalizedDescriptionKey: error.errorDescription ?? ""]
                let err = NSError(domain: "PropzyApi", code: error.responseCode ?? 0, userInfo: userInfor)
                completionHandler?(nil, err)
            }

            
            
            if let propzy = response.result.value {
                
                if propzy.result == false {
                    let err = NSError(domain: propzy.message ?? "", code: propzy.code ?? 0, userInfo: nil)
                    completionHandler?(nil, err)
                    return
                }
                
                completionHandler?(propzy, nil)
                return
            }
            
        }
    }
    
    
//    class func requestFor<T: Mappable>(_ obj: T, strUrl: String, method: HTTPMethod = .get, params: [String: String]? = nil, requestId: Int = 0, completionHandler: Any?) {
//        // Phai duoc su dung trong ten bien
//        let callbackBlock = completionHandler as? DbWebConnectionHandler
//        let callbackDelegate = completionHandler as? IDbWebConnectionDelegate
//
//        let callbackListBlock = completionHandler as? PzListHandler<T>
//        let callbackObjectDelegate = completionHandler as? PzObjectHandler<T>
//
//        let dictHeaders = ["Accept-Encoding": "gzip", "Accept-Language": "vi-VN"]
//
//        // -- Tao bg thread de run Alamofire --
//        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
//        let dataRequest: DataRequest = Alamofire.request(strUrl, method: method,
//                                                         parameters: params, encoding: URLEncoding.default,
//                                                         headers: dictHeaders)
//
//        _ = dataRequest.responseObject { (response: DataResponse<DbPropzyResponse>) in
//            // debugPrint(response)
//
//            if let propzy = response.result.value {
//
//                if callbackBlock != nil {
//                    callbackBlock?(propzy, nil)
//                } else {
//                    callbackDelegate?.onRequestComplete(propzy, andCallerId: requestId)
//                }
//
////                guard let data = response.data else {
////                    return;
////                }
//
//                if let dataArr = response.value?.returnData as? [AnyObject] {
//
//
//                } else if let dataObj = response.value?.returnData as? [String: AnyObject] {
//                    let a = T(map: Map(mappingType: .fromJSON, JSON: dataObj))
//                }
//
////                if let callbackBlock = completionHandler as? DbWebConnectionHandler {
////                    callbackBlock(propzy, nil)
////                    return
////                }
////                if let callbackDelegate = completionHandler as? IDbWebConnectionDelegate {
////                    callbackDelegate.onRequestComplete(propzy, andCallerId: requestId)
////                    return
////                }
//            }
//
//            if let error = response.error {
//
//                if callbackBlock != nil {
//                    callbackBlock?(nil, error)
//                } else {
//                    callbackDelegate?.onRequestError(error, andCallerId: requestId)
//                }
//
//                //                if let callbackBlock = completionHandler as? DbWebConnectionHandler {
//                //                    callbackBlock(nil, error)
//                //                    return
//                //                }
//                //                if let callbackDelegate = completionHandler as? IDbWebConnectionDelegate {
//                //                    callbackDelegate.onRequestError(error, andCallerId: requestId)
//                //                    return
//                //                }
//            }
//
//        }
//
//
//    }
    
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

