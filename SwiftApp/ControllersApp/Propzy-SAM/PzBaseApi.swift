//
//  PzBaseApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/28/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

public class PzResponse: DbHTTPResponseProtocol
{
    var message: String?
    var result: Bool = false
    var code: Int = 0
    var data: Any?
    var error: Error?
    
    public let httpResult: DbHTTPResult
    
    required public init(result: DbHTTPResult)
    {
        self.httpResult = result
    }

    public func parseResult()
    {
        guard let responseData = self.httpResult.json as? [String: Any] else {
            // -- responseData la nil , khong lam gi ca --
            print("PropzyResponse responseData == nil")
            return
        }
        
        // print("PropzyResponse = \(responseData)")
        
        self.result = responseData["result"] as! Bool
        self.message = responseData["message"] as? String
        
        // -- Khong su dung duoc ma khong bit tai sao --
        // self.code = responseData["code"] as! Int
        // self.code = responseData["code"] as? Int ?? 0
        
        //self.code = (responseData["code"] as! String).db_int!
        self.code = Int(responseData["code"] as! String)!
        
        //        SUCCESS("200", "Thao tác thành công"),
        //        DATA_NOT_FOUND("404", "Không tìm thấy dữ liệu"),
        //        PARAMETER_INVALID("405", "Tham số không hợp lệ"),
        //        SYSTEM_ERROR("500", "Lỗi hệ thống"),
        //        FORBIDDEN("403", "Bị cấm sử dụng"),
        //        UNAUTHORIZED("401", "Không được phép"),
        //        CONFLIT("409", "Thông tin đã tồn tại trong hệ thống");
        // -- Chi xu ly nhung loi he thong liet ke o tren --
        if self.result == false {
            // -- Propzy Error System --
            /// let code = self.code ?? 0
            if [404, 405, 500, 403, 401, 409].db_contains([code]) {
                self.error = PropzyError.init(code, message: self.message ?? "System Not Found")
                return
            }
        }
        
        self.data = responseData["data"] as Any
    }
}



typealias DbPzListHandler<T: Mappable> = (_ obj :[T]?, PzResponse) -> ()
typealias DbPzObjectHandler<T: Mappable> = (_ obj :T?, PzResponse) -> ()

public class PzBaseApi
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
                print("PropzyResponse = \(String(describing: res.data))")
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
        if let dataArr = pzResponse.data as? [AnyObject] {
            for item in dataArr {
                if let jsonResult = item as? Dictionary<String, Any> {
                    // do whatever with jsonResult
                    //                    arr.append(T(JSON: jsonResult)!)
                    arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonResult))!)
                }
            }
            // return arr
        } else if let jsonResult = pzResponse.data as? Dictionary<String, Any> {
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

