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

public final class HTTP: NSObject, URLSessionDelegate, JustAdaptor {
    
    public init(session: Foundation.URLSession? = nil,
                defaults: JustSessionDefaults? = nil)
    {
        super.init()
        if let initialSession = session {
            self.session = initialSession
        } else {
            self.session = URLSession(configuration: URLSessionConfiguration.default,
                                      delegate: self, delegateQueue: nil)
        }
        
        if let initialDefaults = defaults {
            self.defaults = initialDefaults
        } else {
            self.defaults = JustSessionDefaults()
        }
    }
    
    var taskConfigs: [TaskID: TaskConfiguration]=[:]
    var defaults: JustSessionDefaults!
    var session: URLSession!
    var invalidURLError = NSError(
        domain: errorDomain,
        code: 0,
        userInfo: [NSLocalizedDescriptionKey: "[Just] URL is invalid"]
    )
    
    var syncResultAccessError = NSError(
        domain: errorDomain,
        code: 1,
        userInfo: [
            NSLocalizedDescriptionKey:
            "[Just] You are accessing asynchronous result synchronously."
        ]
    )
    
    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append((
                percentEncodeString(key),
                percentEncodeString("\(value)"))
            )
        }
        
        return components
    }
    
    func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for (key, value) in parameters.sorted(by: { $0.key < $1.key }) {
            components += self.queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" }).joined(separator: "&")
    }
    
    func percentEncodeString(_ originalObject: Any) -> String {
        if originalObject is NSNull {
            return "null"
        } else {
            var reserved = CharacterSet.urlQueryAllowed
            reserved.remove(charactersIn: ": #[]@!$&'()*+, ;=")
            return String(describing: originalObject)
                .addingPercentEncoding(withAllowedCharacters: reserved) ?? ""
        }
    }
    
    
    func makeTask(_ request: URLRequest, configuration: TaskConfiguration)
        -> URLSessionDataTask?
    {
        let task = session.dataTask(with: request)
        taskConfigs[task.taskIdentifier] = configuration
        return task
    }
    
    func synthesizeMultipartBody(_ data: [String: Any], files: [String: HTTPFile])
        -> Data?
    {
        var body = Data()
        let boundary = "--\(self.defaults.multipartBoundary)\r\n"
            .data(using: defaults.encoding)!
        for (k, v) in data {
            let valueToSend: Any = v is NSNull ? "null" : v
            body.append(boundary)
            body.append("Content-Disposition: form-data; name=\"\(k)\"\r\n\r\n"
                .data(using: defaults.encoding)!)
            body.append("\(valueToSend)\r\n".data(using: defaults.encoding)!)
        }
        
        for (k, v) in files {
            body.append(boundary)
            var partContent: Data? = nil
            var partFilename: String? = nil
            var partMimetype: String? = nil
            switch v {
            case let .url(URL, mimetype):
                partFilename = URL.lastPathComponent
                if let URLContent = try? Data(contentsOf: URL) {
                    partContent = URLContent
                }
                partMimetype = mimetype
            case let .text(filename, text, mimetype):
                partFilename = filename
                if let textData = text.data(using: defaults.encoding) {
                    partContent = textData
                }
                partMimetype = mimetype
            case let .data(filename, data, mimetype):
                partFilename = filename
                partContent = data
                partMimetype = mimetype
            }
            if let content = partContent, let filename = partFilename {
                let dispose = "Content-Disposition: form-data; name=\"\(k)\"; filename=\"\(filename)\"\r\n"
                body.append(dispose.data(using: defaults.encoding)!)
                if let type = partMimetype {
                    body.append(
                        "Content-Type: \(type)\r\n\r\n".data(using: defaults.encoding)!)
                } else {
                    body.append("\r\n".data(using: defaults.encoding)!)
                }
                body.append(content)
                body.append("\r\n".data(using: defaults.encoding)!)
            }
        }
        
        if body.count > 0 {
            body.append("--\(self.defaults.multipartBoundary)--\r\n"
                .data(using: defaults.encoding)!)
        }
        
        return body
    }
    
    public func synthesizeRequest(
        _ method: DbHTTPMethod,
        url: URLComponentsConvertible,
        params: [String: Any],
        data: [String: Any],
        json: Any?,
        headers: CaseInsensitiveDictionary<String, String>,
        files: [String: HTTPFile],
        auth: Credentials?,
        timeout: Double?,
        urlQuery: String?,
        requestBody: Data?
        ) -> URLRequest? {
        if var urlComponents = url.urlComponents {
            let queryString = query(params)
            
            if queryString.count > 0 {
                urlComponents.percentEncodedQuery = queryString
            }
            
            var finalHeaders = headers
            var contentType: String? = nil
            var body: Data?
            
            if let requestData = requestBody {
                body = requestData
            } else if files.count > 0 {
                body = synthesizeMultipartBody(data, files: files)
                let bound = self.defaults.multipartBoundary
                contentType = "multipart/form-data; boundary=\(bound)"
            } else {
                if let requestJSON = json {
                    contentType = "application/json"
                    body = try? JSONSerialization.data(withJSONObject: requestJSON,
                                                       options: defaults.JSONWritingOptions)
                } else {
                    if data.count > 0 {
                        // assume user wants JSON if she is using this header
                        if headers["content-type"]?.lowercased() == "application/json" {
                            body = try? JSONSerialization.data(withJSONObject: data,
                                                               options: defaults.JSONWritingOptions)
                        } else {
                            contentType = "application/x-www-form-urlencoded"
                            body = query(data).data(using: defaults.encoding)
                        }
                    }
                }
            }
            
            if let contentTypeValue = contentType {
                finalHeaders["Content-Type"] = contentTypeValue
            }
            
            if let auth = auth,
                let utf8 = "\(auth.0):\(auth.1)".data(using: String.Encoding.utf8)
            {
                finalHeaders["Authorization"] = "Basic \(utf8.base64EncodedString())"
            }
            if let URL = urlComponents.url {
                var request = URLRequest(url: URL)
                request.cachePolicy = defaults.cachePolicy
                request.httpBody = body
                request.httpMethod = method.rawValue
                if let requestTimeout = timeout {
                    request.timeoutInterval = requestTimeout
                }
                
                for (k, v) in defaults.headers {
                    request.addValue(v, forHTTPHeaderField: k)
                }
                
                for (k, v) in finalHeaders {
                    request.addValue(v, forHTTPHeaderField: k)
                }
                return request
            }
            
        }
        return nil
    }
    
    public func request(
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
        asyncCompletionHandler: ((HTTPResult) -> Void)?) -> HTTPResult {
        
        let isSynchronous = asyncCompletionHandler == nil
        let semaphore = DispatchSemaphore(value: 0)
        var requestResult: HTTPResult = HTTPResult(data: nil, response: nil,
                                                   error: syncResultAccessError, task: nil)
        
        let caseInsensitiveHeaders = CaseInsensitiveDictionary<String, String>(
            dictionary: headers)
        guard let request = synthesizeRequest(method, url: url,
                                              params: params, data: data, json: json, headers: caseInsensitiveHeaders,
                                              files: files, auth: auth, timeout: timeout, urlQuery: urlQuery,
                                              requestBody: requestBody) else
        {
            let erronousResult = HTTPResult(data: nil, response: nil,
                                            error: invalidURLError, task: nil)
            if let handler = asyncCompletionHandler {
                handler(erronousResult)
            }
            return erronousResult
        }
        addCookies(request.url!, newCookies: cookies)
        let config = TaskConfiguration(
            credential: auth,
            redirects: redirects,
            originalRequest: request,
            data: Data(),
            progressHandler: asyncProgressHandler)
        { result in
            if let handler = asyncCompletionHandler {
                handler(result)
            }
            if isSynchronous {
                requestResult = result
                semaphore.signal()
            }
        }
        
        if let task = makeTask(request, configuration: config) {
            task.resume()
        }
        
        if isSynchronous {
            let timeout = timeout.flatMap { DispatchTime.now() + $0 }
                ?? DispatchTime.distantFuture
            _ = semaphore.wait(timeout: timeout)
            return requestResult
        }
        return requestResult
    }
    
    func addCookies(_ URL: Foundation.URL, newCookies: [String: String]) {
        for (k, v) in newCookies {
            if let cookie = HTTPCookie(properties: [
                HTTPCookiePropertyKey.name: k,
                HTTPCookiePropertyKey.value: v,
                HTTPCookiePropertyKey.originURL: URL,
                HTTPCookiePropertyKey.path: "/"
                ])
            {
                session.configuration.httpCookieStorage?.setCookie(cookie)
            }
        }
    }
}

extension HTTP: URLSessionTaskDelegate, URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition,
        URLCredential?) -> Void)
    {
        var endCredential: URLCredential? = nil
        
        if let taskConfig = taskConfigs[task.taskIdentifier],
            let credential = taskConfig.credential
        {
            if !(challenge.previousFailureCount > 0) {
                endCredential = URLCredential(
                    user: credential.0,
                    password: credential.1,
                    persistence: self.defaults.credentialPersistence
                )
            }
        }
        
        completionHandler(.useCredential, endCredential)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask,
                           willPerformHTTPRedirection response: HTTPURLResponse,
                           newRequest request: URLRequest,
                           completionHandler: @escaping (URLRequest?) -> Void)
    {
        if let allowRedirects = taskConfigs[task.taskIdentifier]?.redirects {
            if !allowRedirects {
                completionHandler(nil)
                return
            }
            completionHandler(request)
        } else {
            completionHandler(request)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask,
                           didSendBodyData bytesSent: Int64, totalBytesSent: Int64,
                           totalBytesExpectedToSend: Int64)
    {
        if let handler = taskConfigs[task.taskIdentifier]?.progressHandler {
            handler(
                HTTPProgress(
                    type: .upload,
                    bytesProcessed: totalBytesSent,
                    bytesExpectedToProcess: totalBytesExpectedToSend,
                    chunk: nil
                )
            )
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                           didReceive data: Data)
    {
        if let handler = taskConfigs[dataTask.taskIdentifier]?.progressHandler {
            handler(
                HTTPProgress(
                    type: .download,
                    bytesProcessed: dataTask.countOfBytesReceived,
                    bytesExpectedToProcess: dataTask.countOfBytesExpectedToReceive,
                    chunk: data
                )
            )
        }
        if taskConfigs[dataTask.taskIdentifier]?.data != nil {
            taskConfigs[dataTask.taskIdentifier]?.data.append(data)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask,
                           didCompleteWithError error: Error?)
    {
        if let config = taskConfigs[task.taskIdentifier],
            let handler = config.completionHandler
        {
            let result = HTTPResult(
                data: config.data,
                response: task.response,
                error: error,
                task: task
            )
            result.JSONReadingOptions = self.defaults.JSONReadingOptions
            result.encoding = self.defaults.encoding
            handler(result)
        }
        taskConfigs.removeValue(forKey: task.taskIdentifier)
    }
}

public let Just = JustOf<HTTP>()
