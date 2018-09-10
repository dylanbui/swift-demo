//
//  PropzyResponse.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/10/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import UIKit

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


public class PropzyResponse: DbResponse
{
    var message: String?
    var result: Bool = false
    var code: Int = 0
    var data: Any?
    
    public required init()
    {
        super.init()
        self.contentType = DbHttpContentType.JSON
    }
    
    public override func parse(_ response: Any?, error: Error?) -> Void
    {
        super.parse(response, error: error)
        
        if let err = error {
            print("===== System error =====")
            print("\(err)")
            print("===== ============ =====")
            self.error = err
            return
        }
        
        guard let responseData = response as? [String: Any] else {
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

public class GoogleResponse: DbResponse
{
    var result: [String: AnyObject]?
    
    var addressComponents: [AnyObject]?
    var formattedAddress: String?
    var geometry: AnyObject?
    var placeId: String?
    
    public required init()
    {
        super.init()
        self.contentType = DbHttpContentType.JSON
    }
    
    public override func parse(_ responseData: Any?, error: Error?) -> Void
    {
        super.parse(responseData, error: error)
        
        if let err = error {
            print("Co loi xay ra \(err)")
            return
        }
        
        guard let responseData = responseData as? [String: Any] else {
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
