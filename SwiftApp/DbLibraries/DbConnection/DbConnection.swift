//
//  DbConnection.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/5/18.
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
    }
    
    func exportHttpHeader() -> [String: String] {
        var paramHeaders: [String: String] = [:]
        for header in self.headers {
            paramHeaders[header.key] = header.requestHeaderValue
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
        self.headers = arrHeaders
    }
}

// MARK: - Define : Conection to server
// MARK: -

import UIKit
import AFNetworking
import Alamofire

typealias DbDispatchHandler = (DbResponse) -> ()
typealias DbUploadProcessHandler = (Progress) -> ()

class DbHttp: NSObject {
    
    // MARK: - dispatch : call server bat dong bo
    // MARK: -
    class func dispatch(Request request: DbRequest, dispatchHandler: @escaping DbDispatchHandler) {
        var method: HTTPMethod = .get
        switch request.method {
        case .GET:
            method = .get
        case .POST:
            method = .post
        case .PUT:
            method = .put
        case .DELETE:
            method = .delete
        }
        
        // -- Tao bg thread de run Alamofire --
        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        
        let datarequest: DataRequest = Alamofire.request(request.requestUrl, method: method,
                                                         parameters: request.query, encoding: URLEncoding.default,
                                                         headers: request.exportHttpHeader())
        
        if (request.contentType == DbHttpContentType.JSON) {
            datarequest.responseJSON(completionHandler: { (response) in
                // debugPrint(response)
                // -- Set data for response --
                if let responseObj = request.response {
                    responseObj.httpResponse = response.response
                    responseObj.parse(response.result.value as AnyObject, error: response.error)
                    dispatchHandler(responseObj)
                    print("response \(String(describing: responseObj.rawData))")
                }
            })
        } else {
            datarequest.responseString(completionHandler: { (response) in
                // -- Set data for response --
                if let responseObj = request.response {
                    responseObj.httpResponse = response.response
                    responseObj.parse(response.result.value as AnyObject, error: response.error)
                    dispatchHandler(responseObj)
                    print("response \(String(describing: responseObj.rawData))")
                }
            })
        }
    }
    
}

class DbConnection: NSObject
{
    static let shared = DbConnection()
    
    var isReachable: Bool?
    var sessionManager: AFHTTPSessionManager?
    
    // MARK: - Accessors - class func <=> final static
    class func sharedInstance() -> DbConnection
    {
        return shared
    }
    
    private override init()
    {
        super.init()
        self.isReachable = AFNetworkReachabilityManager.shared().isReachable
        self.sessionManager = AFHTTPSessionManager()
    }
    
    // MARK: - dispatchSynchronous : call server dong bo
    // MARK: -
    // -- Co the khong su dung gia tri tra ve --
    @discardableResult func dispatchSynchronous(Request request: DbRequest) -> DbResponse
    {
        let dispatchGroup = DispatchGroup() //dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        dispatchGroup.enter()
        self.dispatch(Request: request) { (response) in
            dispatchGroup.leave()
        }
        // -- Wait until dispatchGroup done --
        dispatchGroup.wait()
        return request.response!
    }
    
    // MARK: - dispatch : call server bat dong bo
    // MARK: -
    func upload(UploadRequest request: DbUploadRequest, processHandler: @escaping DbUploadProcessHandler, dispatchHandler: @escaping DbDispatchHandler)
    {
        // -- Default Response Serializer --
        self.sessionManager?.responseSerializer = AFHTTPResponseSerializer()
        if let response = request.response {
            if response.contentType! == DbHttpContentType.JSON {
                self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
            }
        } else {
            // -- Default response --
            request.response = DbResponse()
            request.contentType = DbHttpContentType.JSON
            self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
        }
        
        let rawRequest = AFHTTPRequestSerializer().multipartFormRequest(
            withMethod: "POST",
            urlString: request.requestUrl,
            parameters: request.query, constructingBodyWith: { (formData) in
                
                for uploadData in request.arrUploadData {
                    formData.appendPart(withFileData: uploadData.fileData!,
                                        name: uploadData.fileId!,
                                        fileName: uploadData.fileName!,
                                        mimeType: uploadData.mimeType!)
                }

        }, error: nil)

        let uploadTask = self.sessionManager?.uploadTask(withStreamedRequest: rawRequest as URLRequest, progress: { (process) in
            processHandler(process)
        }, completionHandler: { (urlResponse, anyData, error) in
            // -- Set data for response --
            if let response = request.response {
                response.httpResponse = urlResponse
                response.parse(anyData as AnyObject, error: error)
                dispatchHandler(response)
                print("response \(String(describing: response.rawData))")
            }
        })
        uploadTask?.resume()
    }
    
    // MARK: - dispatch : call server bat dong bo
    // MARK: -
    func dispatch(Request request: DbRequest, dispatchHandler: @escaping DbDispatchHandler)
    {
        // -- Default Request Serializer --
        self.sessionManager?.requestSerializer = AFHTTPRequestSerializer()
        if request.contentType == DbHttpContentType.JSON {
            self.sessionManager?.requestSerializer = AFJSONRequestSerializer()
        }
        // -- Default Response Serializer --
        self.sessionManager?.responseSerializer = AFHTTPResponseSerializer()
        if let response = request.response {
            if response.contentType! == DbHttpContentType.JSON {
                self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
            }
        } else {
            // -- Default response --
            request.response = DbResponse()
            request.contentType = DbHttpContentType.JSON
            self.sessionManager?.responseSerializer = AFJSONResponseSerializer()
        }
        
        var serializationError: NSError?
        let rawRequest = self.sessionManager?.requestSerializer.request(withMethod: request.method.rawValue, urlString: request.requestUrl, parameters: request.query, error: &serializationError)
        
        if serializationError != nil {
            print("serializationError : %@", serializationError.debugDescription)
            return
        }
        // -- Add header to request --
        for header in request.headers {
            header.setRequestHeader(request: rawRequest!)
        }
        
        var dataTask: URLSessionDataTask?
        dataTask = self.sessionManager?.dataTask(with: rawRequest as URLRequest!, uploadProgress: { (progress) in
            // -- Dont process --
        }, downloadProgress: { (progressData: Progress) in
            print("downloadProgress")
        }, completionHandler: { (urlResponse, anyData, error) in
            // -- Set data for response --
            if let response = request.response {
                response.httpResponse = urlResponse
                response.parse(anyData as AnyObject, error: error)
                dispatchHandler(response)
                print("response \(String(describing: response.rawData))")
            }
        })
        dataTask?.resume()
    }
    
    // MARK: - requestSynchronousData
    // MARK: -
    // https://gist.github.com/mcxiaoke/3edc23720fcbf589af134c914dd8a0a3
    /// Return data from synchronous URL request
    func requestSynchronousData(_ request: URLRequest) -> Data?
    {
        var data: Data? = nil
        let dispatchGroup = DispatchGroup() //dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        dispatchGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { (taskData, response, error) in
            data = taskData
            if data == nil, let error = error {print(error)}
            dispatchGroup.leave()
        }
        
        task.resume()
        // -- Wait until dispatchGroup done --
        dispatchGroup.wait()
        return data
    }
    
    /// Return data synchronous from specified endpoint
    func requestSynchronousDataWithURLString(_ requestString: String) -> Data?
    {
        guard let url = URL(string:requestString) else {return nil}
        let request = URLRequest(url: url)
        return self.requestSynchronousData(request)
    }
    
    /// Return JSON synchronous from URL request
    func requestSynchronousJSON(_ request: URLRequest) -> AnyObject?
    {
        guard let data = self.requestSynchronousData(request) else {return nil}
        //        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        //        return jsonData as AnyObject
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as AnyObject
    }
    
    /// Return JSON synchronous from specified endpoint
    func requestSynchronousJSONWithURLString(requestString: String) -> AnyObject?
    {
        guard let url = URL(string:requestString) else {return nil}
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return self.requestSynchronousJSON(request)
    }
    
}




