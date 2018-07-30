//
//  DbResponse.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

// MARK: - Define DbResponse
// MARK: -

public protocol DbResponseProtocol {
    
    var httpResponse: URLResponse? {get}
    var rawData: AnyObject? {get}
    var error: Error? {get}
    // var originalRequest: NSURLRequest? {get}
    var contentType: DbHttpContentType? {get}
    
    func parse(_ responseData: AnyObject?, error: Error?) -> Void
    
}
// -- Moi lop con deu phai ke thua tu thang DbResponse --
public class DbResponse: DbResponseProtocol {
    
    public var httpResponse: URLResponse?
    public var rawData: AnyObject?
    // public var originalRequest: NSURLRequest?
    public var contentType: DbHttpContentType?
    public var error: Error?
    
    public required init() {
        
    }
    
    public func parse(_ responseData: AnyObject?, error: Error?) -> Void {
        self.error = error
        self.rawData = responseData
    }
}


// MARK: - Demo extend class DbResponse
// MARK: -

struct PropzyError: Error
{
    let code: Int
    let message: String
    
    init(_ code:Int, message: String) {
        self.code = code
        self.message = message
    }
    
    public var localizedDescription: String {
        return "Code : \(self.code) -- Message : \(self.message)"
        // return message
    }
}


public class PropzyResponse: DbResponse {
    
    //    public var httpResponse: HTTPURLResponse?
    //    public var data: AnyObject?
    //    public var originalRequest: NSURLRequest?
    //    public var contentType: DbHttpContentType?
    //    public var error: Error?
    //    internal(set) public var result: ResultType?
    
    var message: String?
    var result: Bool?
    var code: Int?
    var dictData: [String: AnyObject]?
    
    var returnData: AnyObject?
    
    public required init() {
        super.init()
        self.contentType = DbHttpContentType.JSON
    }
    
    public override func parse(_ responseData: AnyObject?, error: Error?) -> Void {
        super.parse(responseData, error: error)
        if let err = error {
            print("Co loi xay ra \(err)")
            return
        }
        
        guard let responseData = responseData as? [String: AnyObject] else {
            // -- responseData la nil , khong lam gi ca --
            print("PropzyResponse responseData == nil")
            return
        }
        
        // print("PropzyResponse = \(responseData)")
        
        self.result = responseData["result"] as? Bool
        self.message = responseData["message"] as? String
        self.code = responseData["code"] as? Int

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
            let code = self.code ?? 0
            if [404, 405, 500, 403, 401, 409].db_contains([code]) {
                self.error = PropzyError.init(code, message: self.message ?? "System Not Found")
                return
            }
        }
        
        self.dictData = responseData["data"] as? [String: AnyObject]
        // -- Cai nay moi dung --
        self.returnData = responseData["data"] as AnyObject
    }
    
}

public class GoogleResponse: DbResponse {
    
    var result: [String: AnyObject]?
    
    var addressComponents: [AnyObject]?
    var formattedAddress: String?
    var geometry: AnyObject?
    var placeId: String?
    
    public required init() {
        super.init()
        self.contentType = DbHttpContentType.JSON
    }
    
    public override func parse(_ responseData: AnyObject?, error: Error?) -> Void {
        super.parse(responseData, error: error)
        
        if let err = error {
            print("Co loi xay ra \(err)")
            return
        }
        
        guard let responseData = responseData as? [String: AnyObject] else {
            // -- responseData la nil , khong lam gi ca --
            print("GoogleResponse responseData == nil")
            return
        }
        
        print("GoogleResponse = \(responseData)")
        //let result: [AnyObject]? = responseData["results"] as? [AnyObject]
        

        if let results: [AnyObject] = responseData["results"] as? [AnyObject] {
            self.result = results[0] as? [String: AnyObject]
            self.addressComponents = self.result!["address_components"] as? [AnyObject]
            self.formattedAddress = self.result!["formatted_address"] as? String
            self.geometry = self.result!["geometry"] as AnyObject
            self.placeId = self.result!["place_id"] as? String
        }
        
//        self.results = responseData["results"]
        
//        let addressComponentsss: [AnyObject]? = responseData.db_valueForKeyPath(keyPath: "results.address_components")
//        self.addressComponents = responseData[keyPath: "results.address_components"] as? [AnyObject]
        
        
//        self.formattedAddress = self.results["formatted_address"] as? String
//        self.geometry = self.results["geometry"] as AnyObject
//        self.placeId = self.results["place_id"] as? String
    }
    
}
