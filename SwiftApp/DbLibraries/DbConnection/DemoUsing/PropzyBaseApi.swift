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
                completionHandler?(parseToArray(T.self, pzResponse: res)?.first, res)
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
            
            if let res: PropzyResponse = response as? PropzyResponse {
                // -- Xu ly thong bao ket noi mang, hay cac thong bao loi thong dung --
                if let errNetwork = res.error as? DbNetworkError {
                    // -- Loi lien quan den mang --
                    print("DbNetworkError = \(String(describing: errNetwork))")
                    return
                }
                if let errPropzy = res.error as? PropzyError {
                    // -- Loi lien quan den he thong Propzy --
                    print("PropzyError = \(String(describing: errPropzy))")
                    return
                }
                // -- Loi chung chung --
                if let err = res.error {
                    // -- Loi lien quan den mang --
                    print("Common Error = \(String(describing: err))")
                    return
                }
                // -- Complete Handle --
                completionHandler(res)
            }
        }
    }
    
    class func parseToArray<T: Mappable>(_ obj: T.Type, pzResponse: PropzyResponse) -> [T]?
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
}
