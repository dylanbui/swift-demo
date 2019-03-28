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
//typealias DbDispatchHandler = (DbResponse) -> Void

public class PzBaseApi
{
    class func upload<T: Mappable>(strUrl: String, uploadData: [String: DbHTTPFile],
                      params: [String: String]? = nil,
                      processHandler: @escaping DbTaskProgressHandler, completionHandler: DbPzListHandler<T>?)
        
    {
        //params!["type"] = "avatar"
        DbHTTP.jsonUploadFor(PzResponse.self, url: strUrl, json: params, files: uploadData,
                             asyncProgressHandler: processHandler) { (pzResponse) in
                                if pzResponse.httpResult.ok {
                                    completionHandler?(parseToArray(T.self, data: pzResponse.data), pzResponse)
                                } else {
                                    // Xu ly loi
                                    completionHandler?(nil, pzResponse)
                                }
        }
    }
    
    class func requestForObject<T: Mappable>(strUrl: String,
                                             method: DbHTTPMethod = .get,
                                             params: [String: String]? = nil,
                                             completionHandler: DbPzObjectHandler<T>?)
    {
        DbHTTP.requestFor(PzResponse.self, method: method, url: strUrl, json: params) { (pzResponse) in
            if pzResponse.httpResult.ok {
                completionHandler?(parseToArray(T.self, data: pzResponse.data)?.first, pzResponse)
            } else {
                // Xu ly loi
                completionHandler?(nil, pzResponse)
            }
        }
    }
    
    // -- Con chua xu ly duoc cache 1 object --
    class func requestObjectWithCache<T: DbRealmObject>(strUrl: String, objectPrimaryKeyValue: Any?, method: DbHttpMethod = .GET, params: [String: String]? = nil, completionHandler: PropzyObjectHandler<T>?)
    {
//        requestForObject(strUrl: strUrl, method: method, params: params) { (obj: T?, response: PropzyResponse) in
//            if let object = obj {
//                // -- Co du lieu tra ve tu Service --
//                // -- Save to Realm data, if existed primary key will be override  --
//                DbRealmManager.saveWithCompletion(T: object, completion: { (sucess) in
//                    print("Da ghi Realm Object thanh cong")
//                })
//                completionHandler?(object, response)
//            } else {
//                // -- Khong co du lieu tra ve tu Service => get from Realm db --
//                DbRealmManager.getFetchObjectWithCustomPrimareyKey(T: T(), objectPrimaryKey: T.primaryKey() ?? "id", objectPrimaryKeyValue: objectPrimaryKeyValue as? String ?? "none", completionHandler: { (itemCache) in
//                    completionHandler?(itemCache as? T, response)
//                })
//                //                DbRealmManager.getFetchObject(T: <#T##Object#>, objectID: <#T##String#>, completionHandler: <#T##(Object?) -> Void#>)
//                //                DbRealmManager.getAllListOf(T: T(), completionHandler: { (arrCache) in
//                //                    completionHandler?(arrCache as? [T] , response)
//                //                })
//            }
//        }
    }
    
    class func requestListWithCache<T: DbRealmObject>(strUrl: String, method: DbHttpMethod = .GET, params: [String: String]? = nil, completionHandler: PropzyListHandler<T>?)
    {
//        requestForList(strUrl: strUrl, method: method, params: params) { ( arr: [T]?, response: PropzyResponse) in
//            if let arrObject = arr {
//                // -- Co du lieu tra ve tu Service --
//                // -- Save to Realm data, if existed primary key will be override  --
//                DbRealmManager.saveArrayObjects(T: arrObject, completion: { (success) in
//                    print("Da ghi Realm List thanh cong")
//                })
//                completionHandler?(arrObject, response)
//            } else {
//
//                // -- Khong co du lieu tra ve tu Service => get from Realm db --
//                DbRealmManager.getAllListOf(T: T(), completionHandler: { (arrCache) in
//                    completionHandler?(arrCache as? [T], response)
//                })
//            }
//        }
    }
    
    
    class func requestForList<T: Mappable>(strUrl: String,
                                           method: DbHTTPMethod = .get,
                                           params: [String: String]? = nil,
                                           completionHandler: DbPzListHandler<T>?)
    {
        DbHTTP.requestFor(PzResponse.self, method: method, url: strUrl, json: params) { (pzResponse) in
            if pzResponse.httpResult.ok {
                completionHandler?(parseToArray(T.self, data: pzResponse.data), pzResponse)
            } else {
                // Xu ly loi
                completionHandler?(nil, pzResponse)
            }
        }
    }
    
    class func parseToArray<T: Mappable>(_ obj: T.Type, data: Any?) -> [T]?
    {
        var arr: [T] = []
        if let dataArr = data as? [AnyObject] {
            for item in dataArr {
                if let jsonResult = item as? Dictionary<String, Any> {
                    // do whatever with jsonResult
                    //                    arr.append(T(JSON: jsonResult)!)
                    arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonResult))!)
                }
            }
            // return arr
        } else if let jsonResult = data as? Dictionary<String, Any> {
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

