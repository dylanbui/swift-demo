//
//  Just.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/26/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

#if os(Linux)
import Dispatch
#endif

protocol MyResponseProtocol {
    init()
    func parseResult(resut: HTTPResult) -> Void
}

// stolen from python-requests
let statusCodeDescriptions = [
    // Informational.
    100: "continue",
    101: "switching protocols",
    102: "processing",
    103: "checkpoint",
    122: "uri too long",
    200: "ok",
    201: "created",
    202: "accepted",
    203: "non authoritative info",
    204: "no content",
    205: "reset content",
    206: "partial content",
    207: "multi status",
    208: "already reported",
    226: "im used",
    
    // Redirection.
    300: "multiple choices",
    301: "moved permanently",
    302: "found",
    303: "see other",
    304: "not modified",
    305: "use proxy",
    306: "switch proxy",
    307: "temporary redirect",
    308: "permanent redirect",
    
    // Client Error.
    400: "bad request",
    401: "unauthorized",
    402: "payment required",
    403: "forbidden",
    404: "not found",
    405: "method not allowed",
    406: "not acceptable",
    407: "proxy authentication required",
    408: "request timeout",
    409: "conflict",
    410: "gone",
    411: "length required",
    412: "precondition failed",
    413: "request entity too large",
    414: "request uri too large",
    415: "unsupported media type",
    416: "requested range not satisfiable",
    417: "expectation failed",
    418: "im a teapot",
    422: "unprocessable entity",
    423: "locked",
    424: "failed dependency",
    425: "unordered collection",
    426: "upgrade required",
    428: "precondition required",
    429: "too many requests",
    431: "header fields too large",
    444: "no response",
    449: "retry with",
    450: "blocked by windows parental controls",
    451: "unavailable for legal reasons",
    499: "client closed request",
    
    // Server Error.
    500: "internal server error",
    501: "not implemented",
    502: "bad gateway",
    503: "service unavailable",
    504: "gateway timeout",
    505: "http version not supported",
    506: "variant also negotiates",
    507: "insufficient storage",
    509: "bandwidth limit exceeded",
    510: "not extended",
]

public enum HTTPFile {
    case url(URL, String?) // URL to a file, mimetype
    case data(String, Foundation.Data, String?) // filename, data, mimetype
    case text(String, String, String?) // filename, text, mimetype
}

// Supported request types
public enum DbHTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

extension URLResponse {
    var HTTPHeaders: [String: String] {
        return (self as? HTTPURLResponse)?.allHeaderFields as? [String: String]
            ?? [:]
    }
}

public protocol URLComponentsConvertible {
    var urlComponents: URLComponents? { get }
}

extension String: URLComponentsConvertible {
    public var urlComponents: URLComponents? {
        return URLComponents(string: self)
    }
}

extension URL: URLComponentsConvertible {
    public var urlComponents: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)
    }
}

public protocol DbHTTPResponseProtocol {
    
    init()
    
    func parseResult(result: HTTPResult) -> Void
    
}

public class SimpleResponse: DbHTTPResponseProtocol {
    
    var responseResult: HTTPResult!
    
    required public init() { }
    
    public func parseResult(result: HTTPResult) {
        self.responseResult = result
    }
    
}

/// The only reason this is not a struct is the requirements for
/// lazy evaluation of `headers` and `cookies`, which is mutating the
/// struct. This would make those properties unusable with `HTTPResult`s
/// declared with `let`
public final class HTTPResult : NSObject {
    public final var content: Data?
    public var response: URLResponse?
    public var error: Error?
    public var request: URLRequest? { return task?.originalRequest }
    public var task: URLSessionTask?
    public var encoding = String.Encoding.utf8
    public var JSONReadingOptions = JSONSerialization.ReadingOptions(rawValue: 0)
    
    public var reason: String {
        if let code = self.statusCode, let text = statusCodeDescriptions[code] {
            return text
        }
        
        if let error = self.error {
            return error.localizedDescription
        }
        return "Unknown"
    }
    
    public var isRedirect: Bool {
        if let code = self.statusCode {
            return code >= 300 && code < 400
        }
        return false
    }
    
    public var isPermanentRedirect: Bool {
        return self.statusCode == 301
    }
    
    public override var description: String {
        if let status = statusCode,
            let urlString = request?.url?.absoluteString,
            let method = request?.httpMethod
        {
            return "\(method) \(urlString) \(status)"
        } else {
            return "<Empty>"
        }
    }
    
    public init(data: Data?, response: URLResponse?, error: Error?,
                task: URLSessionTask?)
    {
        self.content = data
        self.response = response
        self.error = error
        self.task = task
    }
    
    public var json: Any? {
        return content.flatMap {
            try? JSONSerialization.jsonObject(with: $0, options: JSONReadingOptions)
        }
    }
    
    public var statusCode: Int? {
        return (self.response as? HTTPURLResponse)?.statusCode
    }
    
    public var text: String? {
        return content.flatMap { String(data: $0, encoding: encoding) }
    }
    
    public lazy var headers: CaseInsensitiveDictionary<String, String> = {
        return CaseInsensitiveDictionary<String, String>(
            dictionary: self.response?.HTTPHeaders ?? [:])
    }()
    
    public lazy var cookies: [String: HTTPCookie] = {
        let foundCookies: [HTTPCookie]
        if let headers = self.response?.HTTPHeaders, let url = self.response?.url {
            foundCookies = HTTPCookie.cookies(withResponseHeaderFields: headers,
                                              for: url)
        } else {
            foundCookies = []
        }
        var result: [String: HTTPCookie] = [:]
        for cookie in foundCookies {
            result[cookie.name] = cookie
        }
        return result
    }()
    
    public var ok: Bool {
        return statusCode != nil && !(statusCode! >= 400 && statusCode! < 600)
    }
    
    public var url: URL? {
        return response?.url
    }
    
    public lazy var links: [String: [String: String]] = {
        var result = [String: [String: String]]()
        guard let content = self.headers["link"] else {
            return result
        }
        content.components(separatedBy: ", ").forEach { s in
            let linkComponents = s.components(separatedBy: ";")
                .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
            // although a link without a rel is valid, there's no way to reference it.
            if linkComponents.count > 1 {
                let url = linkComponents.first!
                let start = url.index(url.startIndex, offsetBy: 1)
                let end = url.index(url.endIndex, offsetBy: -1)
                let urlRange = start..<end
                var link: [String: String] = ["url": String(url[urlRange])]
                linkComponents.dropFirst().forEach { s in
                    if let equalIndex = s.index(of: "=") {
                        let componentKey = String(s[s.startIndex..<equalIndex])
                        let range = s.index(equalIndex, offsetBy: 1)..<s.endIndex
                        let value = s[range]
                        if value.first == "\"" && value.last == "\"" {
                            let start = value.index(value.startIndex, offsetBy: 1)
                            let end = value.index(value.endIndex, offsetBy: -1)
                            link[componentKey] = String(value[start..<end])
                        } else {
                            link[componentKey] = String(value)
                        }
                    }
                }
                if let rel = link["rel"] {
                    result[rel] = link
                }
            }
        }
        return result
    }()
    
    public func cancel() {
        task?.cancel()
    }
}

public struct CaseInsensitiveDictionary<Key: Hashable, Value>: Collection,
    ExpressibleByDictionaryLiteral
{
    private var _data: [Key: Value] = [:]
    private var _keyMap: [String: Key] = [:]
    
    public typealias Element = (key: Key, value: Value)
    public typealias Index = DictionaryIndex<Key, Value>
    public var startIndex: Index {
        return _data.startIndex
    }
    public var endIndex: Index {
        return _data.endIndex
    }
    public func index(after: Index) -> Index {
        return _data.index(after: after)
    }
    
    public var count: Int {
        assert(_data.count == _keyMap.count, "internal keys out of sync")
        return _data.count
    }
    
    public var isEmpty: Bool {
        return _data.isEmpty
    }
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        for (key, value) in elements {
            _keyMap["\(key)".lowercased()] = key
            _data[key] = value
        }
    }
    
    public init(dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            _keyMap["\(key)".lowercased()] = key
            _data[key] = value
        }
    }
    
    public subscript (position: Index) -> Element {
        return _data[position]
    }
    
    public subscript (key: Key) -> Value? {
        get {
            if let realKey = _keyMap["\(key)".lowercased()] {
                return _data[realKey]
            }
            return nil
        }
        set(newValue) {
            let lowerKey = "\(key)".lowercased()
            if _keyMap[lowerKey] == nil {
                _keyMap[lowerKey] = key
            }
            _data[_keyMap[lowerKey]!] = newValue
        }
    }
    
    public func makeIterator() -> DictionaryIterator<Key, Value> {
        return _data.makeIterator()
    }
    
    public var keys: Dictionary<Key, Value>.Keys {
        return _data.keys
    }
    public var values: Dictionary<Key, Value>.Values {
        return _data.values
    }
}

typealias TaskID = Int
public typealias Credentials = (username: String, password: String)
public typealias TaskProgressHandler = (HTTPProgress) -> Void
typealias TaskCompletionHandler = (HTTPResult) -> Void

struct TaskConfiguration {
    let credential: Credentials?
    let redirects: Bool
    let originalRequest: URLRequest?
    var data: Data
    let progressHandler: TaskProgressHandler?
    let completionHandler: TaskCompletionHandler?
}

public struct JustSessionDefaults {
    public var JSONReadingOptions: JSONSerialization.ReadingOptions
    public var JSONWritingOptions: JSONSerialization.WritingOptions
    public var headers: [String: String]
    public var multipartBoundary: String
    public var credentialPersistence: URLCredential.Persistence
    public var encoding: String.Encoding
    public var cachePolicy: NSURLRequest.CachePolicy
    public init(
        JSONReadingOptions: JSONSerialization.ReadingOptions =
        JSONSerialization.ReadingOptions(rawValue: 0),
        JSONWritingOptions: JSONSerialization.WritingOptions =
        JSONSerialization.WritingOptions(rawValue: 0),
        headers: [String: String] = [:],
        multipartBoundary: String = "Ju5tH77P15Aw350m3",
        credentialPersistence: URLCredential.Persistence = .forSession,
        encoding: String.Encoding = String.Encoding.utf8,
        cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData)
    {
        self.JSONReadingOptions = JSONReadingOptions
        self.JSONWritingOptions = JSONWritingOptions
        self.headers = headers
        self.multipartBoundary = multipartBoundary
        self.encoding = encoding
        self.credentialPersistence = credentialPersistence
        self.cachePolicy = cachePolicy
    }
}


public struct HTTPProgress {
    public enum `Type` {
        case upload
        case download
    }
    
    public let type: Type
    public let bytesProcessed: Int64
    public let bytesExpectedToProcess: Int64
    public var chunk: Data?
    public var percent: Float {
        return Float(bytesProcessed) / Float(bytesExpectedToProcess)
    }
}

let errorDomain = "net.justhttp.Just"

public protocol JustAdaptor {
    func request(
        _ method: DbHTTPMethod,
        url: URLComponentsConvertible,
        params: [String: Any],
        data: [String: Any],
        json: Any?,
        headers: [String: String],
        files: [String: HTTPFile],
        auth: Credentials?,
        cookies: [String: String],
        redirects: Bool,
        timeout: Double?,
        urlQuery: String?,
        requestBody: Data?,
        asyncProgressHandler: TaskProgressHandler?,
        asyncCompletionHandler: ((HTTPResult) -> Void)?
        ) -> HTTPResult
    
    init(session: URLSession?, defaults: JustSessionDefaults?)
}

public struct JustOf<Adaptor: JustAdaptor> {
    let adaptor: Adaptor
    public init(session: URLSession? = nil,
                defaults: JustSessionDefaults? = nil)
    {
        adaptor = Adaptor(session: session, defaults: defaults)
    }
}

extension JustOf {
    
    @discardableResult
    public func requestFor<Res: DbHTTPResponseProtocol>(
        _ method: DbHTTPMethod,
        url: String, // String Url
        params: [String: Any] = [:], // Menthod Get params
        data: [String: Any] = [:], // Post params
        json: Any? = nil, // Post with json
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((Res) -> Void)? = nil
        ) -> Res {
        
        let result = adaptor.request(
            method,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: [:],
            files: [:],
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            if let handle = asyncCompletionHandler {
                let res = Res()
                res.parseResult(result: httpResult)
                handle(res)
            }
        }
        
        let res = Res()
        res.parseResult(result: result)
        return res
    }
    
    @discardableResult
    public func getJsonFor<Res: DbHTTPResponseProtocol>(
        _ url: String, // String Url
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((Res) -> Void)? = nil
        ) -> Res {
       
        // -- Khong goi lai ham requestFor<Res: DbHTTPResponseProtocol> duoc --
        let result = adaptor.request(
            .get,
            url: url,
            params: [:],
            data: [:],
            json: nil,
            headers: ["content-type": "application/json"], // Nen set json
            files: [:],
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            if let handle = asyncCompletionHandler {
                let res = Res()
                res.parseResult(result: httpResult)
                handle(res)
            }
        }
        
        let res = Res()
        res.parseResult(result: result)
        return res
    }
    
    @discardableResult
    public func postJsonFor<Res: DbHTTPResponseProtocol>(
        _ url: URLComponentsConvertible, // String Url
        json: Any? = nil, // Post with json
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((Res) -> Void)? = nil
        ) -> Res {
        
        // -- Khong goi lai ham requestFor<Res: DbHTTPResponseProtocol> duoc --
        let result = adaptor.request(
            .post,
            url: url,
            params: [:],
            data: [:],
            json: json,
            headers: [:],
            files: [:],
            auth: nil,
            cookies: [:],
            redirects: true,
            timeout: nil,
            urlQuery: nil,
            requestBody: nil,
            asyncProgressHandler: asyncProgressHandler)
        { (httpResult) in
            if let handle = asyncCompletionHandler {
                let res = Res()
                res.parseResult(result: httpResult)
                handle(res)
            }
        }
        
        let res = Res()
        res.parseResult(result: result)
        return res
    }
    
}

extension JustOf {
    
    @discardableResult
    public func request(
        _ method: DbHTTPMethod,
        url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        return adaptor.request(
            method,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func delete(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        
        return adaptor.request(
            .delete,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func get(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        
        return adaptor.request(
            .get,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func head(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        
        return adaptor.request(
            .head,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func options(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        return adaptor.request(
            .options,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func patch(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        
        return adaptor.request(
            .patch,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func post(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        
        return adaptor.request(
            .post,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
    
    @discardableResult
    public func put(
        _ url: URLComponentsConvertible,
        params: [String: Any] = [:],
        data: [String: Any] = [:],
        json: Any? = nil,
        headers: [String: String] = [:],
        files: [String: HTTPFile] = [:],
        auth: (String, String)? = nil,
        cookies: [String: String] = [:],
        allowRedirects: Bool = true,
        timeout: Double? = nil,
        urlQuery: String? = nil,
        requestBody: Data? = nil,
        asyncProgressHandler: (TaskProgressHandler)? = nil,
        asyncCompletionHandler: ((HTTPResult) -> Void)? = nil
        ) -> HTTPResult {
        
        return adaptor.request(
            .put,
            url: url,
            params: params,
            data: data,
            json: json,
            headers: headers,
            files: files,
            auth: auth,
            cookies: cookies,
            redirects: allowRedirects,
            timeout: timeout,
            urlQuery: urlQuery,
            requestBody: requestBody,
            asyncProgressHandler: asyncProgressHandler,
            asyncCompletionHandler: asyncCompletionHandler
        )
    }
}

