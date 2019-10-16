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
    
    /// The server's response to the URL request.
    var urlResponse: URLResponse? {get}
    /// The URL request sent to the server.
    var urlRequest: URLRequest? {get}
    /// The data returned by the server.
    var rawData: Data? {get}
    /// The result of response serialization.
    var responseResult: Any? {get}
    
    var error: Error? {get}
    // var originalRequest: NSURLRequest? {get}
    var contentType: DbHttpContentType? {get}
    
    init()
    
    func parse(_ responseData: Any?, error: Error?) -> Void
    
}

struct DbError: Error
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

// -- Moi lop con deu phai ke thua tu thang DbResponse --
public class DbResponse: DbResponseProtocol {

    public var urlResponse: URLResponse?
    public var urlRequest: URLRequest?
    public var rawData: Data?
    public var responseResult: Any?
    
    public var contentType: DbHttpContentType?
    public var error: Error?
    
    public required init() {
        
    }
    
    public func parse(_ responseData: Any?, error: Error?) -> Void {
        self.error = error
        self.responseResult = responseData
    }
}


extension DbResponse: CustomStringConvertible, CustomDebugStringConvertible {

    public var description:String {
        return self.responseResult.debugDescription
    }

    public var debugDescription:String {
        var output: [String] = []

//        output.append(urlRequest != nil ? "[Request]: \(urlRequest!.httpMethod ?? "GET") \(urlRequest!)" : "[Request]: nil")
//        output.append(urlResponse != nil ? "[Response]: \(urlResponse!)" : "[Response]: nil")
        output.append("[Data]: \(rawData?.count ?? 0) bytes")
        output.append("[ResponseResult]: \(responseResult.debugDescription)")

        return output.joined(separator: "\n")
    }
}



