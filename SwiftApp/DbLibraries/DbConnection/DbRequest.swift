//
//  DbRequest.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

// MARK: - Define headers
// MARK: -

public typealias MIMEType = String

public typealias DbRequestQuery = [String: String]

public struct DbUploadData
{
    var fileData: Data?
    var fileId: String?
    var fileName: String?
    var mimeType: String?
}

public enum DbHttpMethod: String {
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
}

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
    
    //public var requestHeaderValue: String {
    public var headerValue: String {
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
        request.setValue(headerValue, forHTTPHeaderField: key)
    }
    
    public static func ==(lhs: DbHttpHeader, rhs: DbHttpHeader) -> Bool {
        return lhs.key == rhs.key && lhs.headerValue == rhs.headerValue
    }
    
}

//#define WS_DEFAULT_HTTP_ERROR 1000
//#define WS_CONNECTION_HTTP_ERROR WS_DEFAULT_HTTP_ERROR + 1
//#define WS_URL_ERROR WS_CONNECTION_HTTP_ERROR + 1
//#define WS_JSON_PARSING_FAILED WS_URL_ERROR + 1
//#define WS_RETURN_ERROR WS_JSON_PARSING_FAILED + 1
//#define WS_NETWORK_CONNECTION_ERROR WS_RETURN_ERROR + 1

enum DbNetworkError: Error {
    case unknownError
    case notFound
    case connectionError
    case jsonParseError
    //    case invalidCredentials
    //    case invalidRequest
    //    case notFound
    //    case invalidResponse
    //    case serverError
    //    case serverUnavailable
    //    case timeOut
    //    case unsuppotedURL
    
    public var description: String {
        switch self {
        case .notFound:
            return "Not found error"
        case .connectionError:
            return "Connection error. Cellular Data Is Turned Off"
        case .jsonParseError:
            return "Format json parse error"
            
        case .unknownError:
            return "Unknown error"
        }
    }
    
    var debugDescription: String {
        return self.description
    }
}

// MARK: - Define DbRequest
// MARK: -

public protocol DbRequestType {
    
    var method: DbHttpMethod {get}
    var requestUrl: String {get}
    var contentType: DbHttpContentType {get}
    var headers: [DbHttpHeader] {get}
    var query: DbRequestQuery {get}
    
    var response: DbResponse? {get}
}

public class DbRequest: DbRequestType {
    
    public var method: DbHttpMethod
    public var requestUrl: String
    public var contentType: DbHttpContentType
    public var headers: [DbHttpHeader]
    public var query: DbRequestQuery
    
    public var response: DbResponse?
    
    convenience init() {
        self.init(method: .POST, requestUrl: "", query: [:], headers: [])
    }
    
    convenience init(method: DbHttpMethod, requestUrl: String) {
        self.init(method: method, requestUrl: requestUrl, query: [:], headers: [])
    }
    
    init(method: DbHttpMethod, requestUrl: String, query: DbRequestQuery = DbRequestQuery(), headers: [DbHttpHeader] = []) {
        self.method = method
        self.requestUrl = requestUrl
        self.query = query
        self.headers = headers
        self.contentType = .JSON
        
        self.response = DbResponse()
    }
    
    func exportHttpHeader() -> [String: String]
    {
        var paramHeaders: [String: String] = [:]
        for header in self.headers {
            paramHeaders[header.key] = header.headerValue
        }
        return paramHeaders
    }
}

public class DbUploadRequest: DbRequest {
    
    public var arrUploadData = [DbUploadData]()
    
    init() {
        super.init(method: .POST, requestUrl: "", query: [:], headers: [])
    }
    
    init(requestUrl: String, uploadData: DbUploadData) {
        super.init(method: .POST, requestUrl: requestUrl, query: [:], headers: [])
        self.arrUploadData.append(uploadData)
    }
}

public class DbUploadRequestFor<ResponseType: DbResponse> : DbUploadRequest {
    
    override init() {
        super.init()
        self.response = ResponseType()
    }
    
    override init(requestUrl: String, uploadData: DbUploadData) {
        super.init(requestUrl: requestUrl, uploadData: uploadData)
        self.response = ResponseType()
    }
}

// -- ResponseType la 1 lop bat ky, ke thua tu DbResponse --
public class DbRequestFor<ResponseType: DbResponse>: DbRequest {
    
    convenience init()
    {
        self.init(method: .POST, requestUrl: "", query: [:], headers: [])
    }
    
    convenience init(method: DbHttpMethod, requestUrl: String) {
        self.init(method: method, requestUrl: requestUrl, query: [:], headers: [])
    }
    
    override init(method: DbHttpMethod, requestUrl: String, query: DbRequestQuery = DbRequestQuery(), headers: [DbHttpHeader] = []) {
        super.init(method: method, requestUrl: requestUrl, query: query, headers: headers)
        self.response = ResponseType()
        
        self.contentType = DbHttpContentType.JSON
        
        // -- Demo headers --
        var arrHeaders: [DbHttpHeader] = []
        arrHeaders.append(DbHttpHeader.Custom("Accept-Encoding", "gzip"))
        arrHeaders.append(DbHttpHeader.Custom("Accept-Language", "vi-VN"))
        arrHeaders.append(DbHttpHeader.Custom("Content-Type", "application/json")) // JSON Request

        self.headers = arrHeaders
    }
}

