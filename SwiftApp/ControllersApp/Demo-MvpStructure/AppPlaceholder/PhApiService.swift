//
//  PhApiService.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/16/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

import ObjectMapper
import Alamofire

typealias PhCompleteHandler = (PhResponse) -> ()

typealias PhListHandler<T: Mappable> = (_ obj :[T]?, PhResponse) -> ()
typealias PhObjectHandler<T: Mappable> = (_ obj :T?, PhResponse) -> ()

public class PhApiService
{
    
}

public class PhResponse: DbResponse
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
        
        guard let responseData = response else {
            // -- responseData la nil , khong lam gi ca --
            print("PropzyResponse responseData == nil")
            let err = DbError.init(4040, message: "PropzyResponse responseData == nil")
            self.error = err
            return
        }
        
        self.data = responseData
    }
}

