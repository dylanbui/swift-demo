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

