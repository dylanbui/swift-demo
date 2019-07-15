//
//  PzBaseApi.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/28/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Ket hop tahnh cong giua DbHTTP moi copy va EasyRealm

import Foundation
import ObjectMapper
//import RealmSwift

public let pzUtilNetworkQueue = DispatchQueue(label: "vn.propzy.uti.network", qos: .utility)
public let pzBgNetworkQueue = DispatchQueue(label: "vn.propzy.bg.network", qos: .background)

public class PzResponse: NSObject, DbHTTPResponseProtocol, NSCoding
{
    public func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.httpResult, forKey: "httpResult")
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        let result = aDecoder.decodeObject(forKey: "httpResult") as! DbHTTPResult
        self.httpResult = result
        
        super.init()
        self.parseResult()
    }
    
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
    
    class func requestListWithCache<T: DbrmObjectMappable>(strUrl: String,
                                                      method: DbHTTPMethod = .get,
                                                      params: [String: String]? = nil, completionHandler: DbPzListHandler<T>?)
    {
        requestForList(strUrl: strUrl, method: method, params: params) { ( arr: [T]?, response: PzResponse) in
            if let arrObject = arr {
                // -- Co du lieu tra ve tu Service --
                // -- Save to Realm data, if existed primary key will be override  --
                for obj: T in arrObject {
                    obj.er.db_saveOrUpdate()
                }
                completionHandler?(arrObject, response)
            } else {
                // -- Khong co du lieu tra ve tu Service => get from Realm db --
                // -- Chi lay danh sach, khong co condition  --
                // -- Lay tu cache --
                let arrObj = T.er.db_all()
                completionHandler?(arrObj, response)
            }
        }
    }
    
    class func cacheRequestForList<T: Mappable>(strUrl: String,
                                           method: DbHTTPMethod = .get,
                                           params: [String: String]? = nil,
                                           cacheName: String,
                                           cacheAge: Int = 0,
                                           completionHandler: DbPzListHandler<T>?)
    {
        print("===> Cache name = \(cacheName)")
        if let pzRes = DbCache.instance.readObject(forKey: cacheName) as? PzResponse {
            print("Read from cache")
            completionHandler?(parseToArray(T.self, data: pzRes.data), pzRes)
            return
        }
        
        DbHTTP.requestFor(PzResponse.self, method: method, url: strUrl, json: params) { (pzResponse) in
            if pzResponse.httpResult.ok {
                // -- Save to cache --
                print("Save to cache")
                DbCache.instance.write(object: pzResponse, forKey: cacheName)
            }
            DbUtils.dispatchToMainQueue {
                if pzResponse.httpResult.ok {
                    completionHandler?(parseToArray(T.self, data: pzResponse.data), pzResponse)
                } else {
                    // Xu ly loi
                    completionHandler?(nil, pzResponse)
                }
            }
        }
    }
    
    class func requestForList<T: Mappable>(strUrl: String,
                                           method: DbHTTPMethod = .get,
                                           params: DictionaryType? = nil,
                                           queue: DispatchQueue = DispatchQueue.main,
                                           completionHandler: DbPzListHandler<T>?)
    {
        DbHTTP.requestFor(PzResponse.self, method: method, url: strUrl, json: params, queue: queue) { (pzResponse) in
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
        if let dataArr = data as? [Any] {
            for item in dataArr {
                if let jsonResult = item as? Dictionary<String, Any> {
                    // do whatever with jsonResult
                    // arr.append(T(JSON: jsonResult)!)
                    arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonResult))!)
                }
            }
        } else if let jsonResult = data as? Dictionary<String, Any> {
            // -- Neu ton tai "list" key thi xu ly thang nay nhu 1 mang --
            if let dataArr = jsonResult["list"] as? [Any] {
                for item in dataArr {
                    if let jsonRes = item as? DictionaryType {
                        arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonRes))!)
                    }
                }
                return arr
            }
            // -- Xu ly nhu 1 doi tuong --
            // arr.append(T(JSON: jsonResult)!)
            arr.append(T(map: Map(mappingType: .fromJSON, JSON: jsonResult))!)
        }
        return arr
    }
    
}

