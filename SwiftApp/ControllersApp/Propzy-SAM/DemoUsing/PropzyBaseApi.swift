//
//  PropzyBaseApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/27/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

import RealmSwift

typealias PropzyListHandler<T: Mappable> = (_ obj :[T]?, PropzyResponse) -> ()
typealias PropzyObjectHandler<T: Mappable> = (_ obj :T?, PropzyResponse) -> ()

//protocol IPropzyConnectionDelegate {
//    func onRequestComplete(_ response: DbPropzyResponse, andCallerId callerId: Int) -> Void
//    func onRequestError(_ error: Error, andCallerId callerId: Int) -> Void
//}


//struct PropzyError: Error
//{
//    let code: Int
//    let message: String
//
//    init(_ code:Int, message: String) {
//        self.code = code
//        self.message = message
//    }
//
//    public var localizedDescription: String {
//        return message
//    }
//}

public class PropzyBaseApi
{
    class func upload(strUrl: String, uploadData: [DbUploadData], params: [String: String]? = nil, processHandler: @escaping DbUploadProcessHandler, dispatchHandler: @escaping DbDispatchHandler)
    
    {
        let requestUpload = DbUploadRequestFor<PropzyResponse>()
        requestUpload.requestUrl = strUrl
        requestUpload.arrUploadData = uploadData
        requestUpload.query = ["type": "avatar"]
        
        DbHttp.upload(UploadRequest: requestUpload, processHandler: { (progress) in
            processHandler(progress)
            // -- Print debug --
            print("progress.fractionCompleted" + String(Float(progress.fractionCompleted)))
            
        }) { (response) in
            dispatchHandler(response)
            // -- Print debug --
            print("Upload => successHandler")
            print("responseData = \(String(describing: response.rawData))")
            // debugPrint(response)
            if let res: PropzyResponse = response as? PropzyResponse {
                print("PropzyResponse = \(String(describing: res.dictData))")
            }
        }
    }
    
    class func requestForObject<T: Mappable>(strUrl: String, method: DbHttpMethod = .GET, params: [String: String]? = nil, completionHandler: PropzyObjectHandler<T>?)
    {
//        let request = DbRequestFor<PropzyResponse>.init(method: method, requestUrl: strUrl)
//        //        request.method = DbHttpMethod.POST
//        //        request.contentType = DbHttpContentType.JSON
//        //
//        //        var arrHeaders: [DbHttpHeader] = []
//        //        arrHeaders.append(DbHttpHeader.Custom("Accept-Encoding", "gzip"))
//        //        arrHeaders.append(DbHttpHeader.Custom("Accept-Language", "vi-VN"))
//        //        request.headers = arrHeaders
//
//        // let params: [String: String]! = ["buildingId" : "2", "buildingName" : "194 Golden Building"]
//        if let params = params {
//            request.query = params
//        }
//
//        DbHttp.dispatch(Request: request) { (response) in
//            if let res: PropzyResponse = response as? PropzyResponse {
//                print("Goi thu successHandler")
//                print("responseData = \(String(describing: res.dictData))")
//                completionHandler?(parseToArray(T.self, pzResponse: res)?.first, res)
//            }
//        }
        
        request(strUrl: strUrl, method: method) { (response) in
            if let res: PropzyResponse = response as? PropzyResponse {
                if let err = res.error {
                    print("requestForObject Error = \(String(describing: err))")
                    completionHandler?(nil, res)
                    return
                }
                completionHandler?(parseToArray(T.self, pzResponse: res)?.first, res)
            }
        }
    }

    // -- Con chua xu ly duoc cache 1 object --
    class func requestObjectWithCache<T: DbRealmObject>(strUrl: String, objectPrimaryKeyValue: Any?, method: DbHttpMethod = .GET, params: [String: String]? = nil, completionHandler: PropzyObjectHandler<T>?)
    {
        requestForObject(strUrl: strUrl, method: method, params: params) { (obj: T?, response: PropzyResponse) in
            if let object = obj {
                // -- Co du lieu tra ve tu Service --
                // -- Save to Realm data, if existed primary key will be override  --
                DbRealmManager.saveWithCompletion(T: object, completion: { (sucess) in
                    print("Da ghi Realm Object thanh cong")
                })
                completionHandler?(object, response)
            } else {
                // -- Khong co du lieu tra ve tu Service => get from Realm db --
                DbRealmManager.getFetchObjectWithCustomPrimareyKey(T: T(), objectPrimaryKey: T.primaryKey() ?? "id", objectPrimaryKeyValue: objectPrimaryKeyValue as? String ?? "none", completionHandler: { (itemCache) in
                    completionHandler?(itemCache as? T, response)
                })
//                DbRealmManager.getFetchObject(T: <#T##Object#>, objectID: <#T##String#>, completionHandler: <#T##(Object?) -> Void#>)
//                DbRealmManager.getAllListOf(T: T(), completionHandler: { (arrCache) in
//                    completionHandler?(arrCache as? [T] , response)
//                })
            }
        }
    }
    
    class func requestListWithCache<T: DbRealmObject>(strUrl: String, method: DbHttpMethod = .GET, params: [String: String]? = nil, completionHandler: PropzyListHandler<T>?)
    {
        requestForList(strUrl: strUrl, method: method, params: params) { ( arr: [T]?, response: PropzyResponse) in
            if let arrObject = arr {
                // -- Co du lieu tra ve tu Service --
                // -- Save to Realm data, if existed primary key will be override  --
                DbRealmManager.saveArrayObjects(T: arrObject, completion: { (success) in
                    print("Da ghi Realm List thanh cong")
                })
                completionHandler?(arrObject, response)
            } else {

                // -- Khong co du lieu tra ve tu Service => get from Realm db --
                DbRealmManager.getAllListOf(T: T(), completionHandler: { (arrCache) in
                    completionHandler?(arrCache as? [T], response)
                })
            }
        }
    }

    
    class func requestForList<T: Mappable>(strUrl: String, method: DbHttpMethod = .GET, params: [String: String]? = nil, completionHandler: PropzyListHandler<T>?)
    {
//        let request = DbRequestFor<PropzyResponse>.init(method: method, requestUrl: strUrl)
//        // let params: [String: String]! = ["buildingId" : "2", "buildingName" : "194 Golden Building"]
//        if let params = params {
//            request.query = params
//        }
//
//        DbHttp.dispatch(Request: request) { (response) in
//            if let res: PropzyResponse = response as? PropzyResponse {
//                print("Goi thu successHandler")
//                print("responseData = \(String(describing: res.dictData))")
//
//                completionHandler?(parseToArray(T.self, pzResponse: res), res)
//            }
//        }
        
        request(strUrl: strUrl, method: method) { (response) in
            if let res: PropzyResponse = response as? PropzyResponse {
                if let err = res.error {
                    print("requestForList Error = \(String(describing: err))")
                    completionHandler?(nil, res)
                    return
                }
                completionHandler?(parseToArray(T.self, pzResponse: res), res)
            }
        }
    }
    
    class func request(strUrl: String, method: DbHttpMethod = .POST, params: [String: String]? = nil, completionHandler: @escaping DbDispatchHandler)
    {
        let request = DbRequestFor<PropzyResponse>.init(method: method, requestUrl: strUrl)
        // let params: [String: String]! = ["buildingId" : "2", "buildingName" : "194 Golden Building"]
        if let params = params {
            request.query = params
        }
        
        DbHttp.dispatch(Request: request) { (response) in
            
            // -- Try debug --
//            debugPrint(request)
//            debugPrint(response)
//            print("Request = \(String(describing: request))")
//            print("Response = \(String(describing: response))")
            // -- --------- --
            // -- Chi xu ly loi mang, hien thong bao popup --
            if let res: PropzyResponse = response as? PropzyResponse {
                // -- Xu ly thong bao ket noi mang, hay cac thong bao loi thong dung --
                if let errNetwork = res.error as? DbNetworkError {
                    // -- Loi lien quan den mang --
                    print("DbNetworkError = \(String(describing: errNetwork))")
                    // -- Show warning network --
                    Pz.showErrorNetwork()
                }
                // -- Complete Handle --
                completionHandler(res)
            }
            
//            if let res: PropzyResponse = response as? PropzyResponse {
//                // -- Xu ly thong bao ket noi mang, hay cac thong bao loi thong dung --
//                if let errNetwork = res.error as? DbNetworkError {
//                    // -- Loi lien quan den mang --
//                    print("DbNetworkError = \(String(describing: errNetwork))")
//                    return
//                }
//                if let errPropzy = res.error as? PropzyError {
//                    // -- Loi lien quan den he thong Propzy --
//                    print("PropzyError = \(String(describing: errPropzy))")
//                    return
//                }
//                // -- Loi chung chung --
//                if let err = res.error {
//                    // -- Loi lien quan den mang --
//                    print("Common Error = \(String(describing: err))")
//                    return
//                }
//                // -- Complete Handle --
//                completionHandler(res)
//            }
        }
    }
    
    class func parseToArray<T: Mappable>(_ obj: T.Type, pzResponse: PropzyResponse) -> [T]?
    {
        var arr: [T] = []
        if let dataArr = pzResponse.returnData as? [AnyObject] {
            for item in dataArr {
                if let jsonResult = item as? Dictionary<String, Any> {
                    // do whatever with jsonResult
//                    arr.append(T(JSON: jsonResult)!)
                    arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonResult))!)
                }
            }
            // return arr
        } else if let jsonResult = pzResponse.returnData as? Dictionary<String, Any> {
//            arr.append(T(JSON: jsonResult)!)
            arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonResult))!)
        }
        return arr
    }

//    class func parseToObject<T: Mappable>(_ obj: T, pzResponse: DbPropzyResponse) -> T?
//    {
//        if let jsonResult = pzResponse.returnData as? Dictionary<String, Any> {
//            return T(JSON: jsonResult)
//        }
//        return nil
//    }
}

/// Used to store all data associated with an non-serialized response of a data or upload request.
public struct MyDataResponse {
    /// The URL request sent to the server.
    public let request: URLRequest?
    
    /// The server's response to the URL request.
    public let response: HTTPURLResponse?
    
    /// The data returned by the server.
    public let data: Data?
    
    /// The error encountered while executing or validating the request.
    public let error: Error?
    
    /// The timeline of the complete lifecycle of the request.
    public let timeline: Timeline
    
    var _metrics: AnyObject?
    
    public let params: [String: Any]?
    
    /// Creates a `DefaultDataResponse` instance from the specified parameters.
    ///
    /// - Parameters:
    ///   - request:  The URL request sent to the server.
    ///   - response: The server's response to the URL request.
    ///   - data:     The data returned by the server.
    ///   - error:    The error encountered while executing or validating the request.
    ///   - timeline: The timeline of the complete lifecycle of the request. `Timeline()` by default.
    ///   - metrics:  The task metrics containing the request / response statistics. `nil` by default.
    public init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        timeline: Timeline = Timeline(),
        metrics: AnyObject? = nil)
    {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.timeline = timeline
        
        self._metrics = metrics
        
        self.params = ["":""]
    }
}


