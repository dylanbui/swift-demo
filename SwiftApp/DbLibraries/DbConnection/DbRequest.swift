//
//  DbRequest.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

public enum DbHttpMethod: String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
}

public typealias MIMEType = String

public enum DbHttpContentType: RawRepresentable {
    
    case JSON
    case form
    case multipart(String)
    
    public typealias RawValue = MIMEType
    
    public init?(rawValue: DbHttpContentType.RawValue) {
        switch rawValue {
        case "application/json": self = .JSON
        default: return nil
        }
    }
    
    public var rawValue: DbHttpContentType.RawValue {
        switch self {
        case .JSON: return "application/json"
        case .form: return "application/x-www-form-urlencoded"
        case .multipart(let boundary): return "multipart/form-data; boundary=\(boundary)"
        }
    }
}

public enum DbHttpHeader: Equatable {
    
    case ContentDisposition(String)
    case Accept([DbHttpContentType])
    case ContentType(DbHttpContentType)
    case Authorization(String)
    case Custom(String, String)
    
    public var key: String {
        switch self {
        case .ContentDisposition:
            return "Content-Disposition"
        case .Accept:
            return "Accept"
        case .ContentType:
            return "Content-Type"
        case .Authorization:
            return "Authorization"
        case .Custom(let key, _):
            return key
        }
    }
    
    public var requestHeaderValue: String {
        switch self {
        case .ContentDisposition(let disposition):
            return disposition
        case .Accept(let types):
            let typeStrings = types.map({$0.rawValue})
            return typeStrings.joined(separator: ", ")
        case .ContentType(let type):
            return type.rawValue
        case .Authorization(let token):
            return token //token.requestHeaderValue
        case .Custom(_, let value):
            return value
        }
    }
    
    public func setRequestHeader(request: NSMutableURLRequest) {
        request.setValue(requestHeaderValue, forHTTPHeaderField: key)
    }
    
    public static func ==(lhs: DbHttpHeader, rhs: DbHttpHeader) -> Bool {
        return lhs.key == rhs.key && lhs.requestHeaderValue == rhs.requestHeaderValue
    }
    
}

public typealias DbRequestQuery = [String: String]

public protocol DbRequestType {
    
    var contentType: DbHttpContentType? {get}
    var body: NSData? {get}
    
    var method: DbHttpMethod {get}
    var requestUrl: String {get}
    var headers: [DbHttpHeader] {get}
    var query: DbRequestQuery {get}
    
}

public class DbRequest: DbRequestType {
    
    public var contentType: DbHttpContentType?
    public var body: NSData?
    public var method: DbHttpMethod
    public var requestUrl: String
    public var headers: [DbHttpHeader]
    public var query: DbRequestQuery
    
    init() {
        
        self.method = .POST
        self.requestUrl = ""
        self.headers = []
        self.query = [:]
        
        self.contentType = nil
        self.body = nil
    }
    
    public convenience init(method: DbHttpMethod, requestUrl: String, query: DbRequestQuery = DbRequestQuery(), headers: [DbHttpHeader] = []) {
        self.init()
        
        self.method = method
        self.requestUrl = requestUrl
        self.query = query
        self.headers = headers
        self.body = nil
    }
    
    
}


public protocol DbResponseProtocol {
    
    var httpResponse: HTTPURLResponse? {get}
    var data: AnyObject? {get}
    var error: Error? {get}
    var originalRequest: NSURLRequest? {get}
    var contentType: DbHttpContentType? {get}
    
    func parse(_ responseData: AnyObject?, error: Error?) -> Void
    
}

public class DbResponse: DbResponseProtocol {
    
    public var httpResponse: HTTPURLResponse?
    public var data: AnyObject?
    public var originalRequest: NSURLRequest?
    public var contentType: DbHttpContentType?
    public var error: Error?
    //    internal(set) public var result: ResultType?
    
    init() {
        
    }
    
    public func parse(_ responseData: AnyObject?, error: Error?) -> Void {
        self.error = error
        self.data = responseData
    }
    
}

//public enum HTTPMethod: String {
//    case GET    = "GET"
//    case POST   = "POST"
//    case PUT    = "PUT"
//    case DELETE = "DELETE"
//}
//
//public protocol Endpoint {
//    // -- Chuyen thang nay thanh 1 ham co the chuyen URL, luu request URL --
//    var path: String {get}
//    var signed: Bool {get}
//    var method: HTTPMethod {get}
//}
//
//public typealias MIMEType = String
//
//public enum HTTPContentType: RawRepresentable {
//    
//    case JSON
//    case form
//    case multipart(String)
//    
//    public typealias RawValue = MIMEType
//    
//    public init?(rawValue: HTTPContentType.RawValue) {
//        switch rawValue {
//        case "application/json": self = .JSON
//        default: return nil
//        }
//    }
//    
//    public var rawValue: HTTPContentType.RawValue {
//        switch self {
//        case .JSON: return "application/json"
//        case .form: return "application/x-www-form-urlencoded"
//        case .multipart(let boundary): return "multipart/form-data; boundary=\(boundary)"
//        }
//    }
//}
//
//public enum HTTPHeader: Equatable {
//    
//    case ContentDisposition(String)
//    case Accept([HTTPContentType])
//    case ContentType(HTTPContentType)
//    case Authorization(String)
//    case Custom(String, String)
//    
//    public var key: String {
//        switch self {
//        case .ContentDisposition:
//            return "Content-Disposition"
//        case .Accept:
//            return "Accept"
//        case .ContentType:
//            return "Content-Type"
//        case .Authorization:
//            return "Authorization"
//        case .Custom(let key, _):
//            return key
//        }
//    }
//    
//    public var requestHeaderValue: String {
//        switch self {
//        case .ContentDisposition(let disposition):
//            return disposition
//        case .Accept(let types):
//            let typeStrings = types.map({$0.rawValue})
//            return typeStrings.joined(separator: ", ")
//        case .ContentType(let type):
//            return type.rawValue
//        case .Authorization(let token):
//            return token //token.requestHeaderValue
//        case .Custom(_, let value):
//            return value
//        }
//    }
//    
//    public func setRequestHeader(request: NSMutableURLRequest) {
//        request.setValue(requestHeaderValue, forHTTPHeaderField: key)
//    }
//    
//    public static func ==(lhs: HTTPHeader, rhs: HTTPHeader) -> Bool {
//        return lhs.key == rhs.key && lhs.requestHeaderValue == rhs.requestHeaderValue
//    }
//
//}
//
//
//
//public typealias DbRequestQuery = [String: String]
//
//public protocol DbRequestType {
//    
//    var body: NSData? {get}
//    var method: HTTPMethod {get}
//    var requestUrl: String {get}
//    var headers: [HTTPHeader] {get}
//    var query: DbRequestQuery {get}
//    
//}
//
//public struct DbRequest: DbRequestType {
//    
//    public let body: NSData?
//    public let method: HTTPMethod
//    public let requestUrl: String
//    public let headers: [HTTPHeader]
//    public let query: DbRequestQuery
//    
//    public init(method: HTTPMethod, requestUrl: String, query: DbRequestQuery = DbRequestQuery(), headers: [HTTPHeader] = []) {
//        self.method = method
//        self.requestUrl = requestUrl
//        self.query = query
//        self.headers = headers
//        self.body = nil
//    }
//    
//    
//}



