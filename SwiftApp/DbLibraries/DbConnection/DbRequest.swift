//
//  DbRequest.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//


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



