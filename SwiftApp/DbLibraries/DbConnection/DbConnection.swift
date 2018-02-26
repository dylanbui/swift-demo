//
//  DbConnection.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/5/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

// MARK: - Define : Conection to server
// MARK: -

import UIKit
import Alamofire

typealias DbDispatchHandler = (DbResponse) -> ()
typealias DbUploadProcessHandler = (Progress) -> ()

class DbHttp: NSObject {
    
    class func post(Url url: String, dispatchHandler: @escaping DbDispatchHandler)
    {
        self.postFor(Url: url, dispatchHandler: dispatchHandler)
    }
    
    // -- Defaut return JSON --
    @discardableResult class func postFor<T: DbResponse>(Url url: String, dispatchHandler: @escaping DbDispatchHandler) -> T?
    {
        let request = DbRequestFor<T>()
        request.requestUrl = url
        request.method = .POST
        
        self.dispatch(Request: request, dispatchHandler: dispatchHandler)
        
        return nil
    }
    
    class func get(Url url: String, dispatchHandler: @escaping DbDispatchHandler)
    {
        self.getFor(Url: url, dispatchHandler: dispatchHandler)
    }

    // -- Defaut return JSON --
    @discardableResult class func getFor<T: DbResponse>(Url url: String, dispatchHandler: @escaping DbDispatchHandler) -> T?
    {
        let request = DbRequestFor<T>()
        request.requestUrl = url
        request.method = .GET
        
        self.dispatch(Request: request, dispatchHandler: dispatchHandler)
        
        return nil
    }
    
    // MARK: - dispatch : call server bat dong bo
    // MARK: -
    class func dispatch(Request request: DbRequest, queue: DispatchQueue? = nil, dispatchHandler: @escaping DbDispatchHandler)
    {
        if NetworkReachabilityManager()!.isReachable {
            // -- Set data for response --
            if let responseObj = request.response {
                responseObj.parse(nil, error: DbNetworkError.connectionError)
                dispatchHandler(responseObj)
            }
            return
        }
        
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
        let dataRequest: DataRequest = Alamofire.request(request.requestUrl, method: method,
                                                         parameters: request.query, encoding: URLEncoding.default,
                                                         headers: request.exportHttpHeader())
        
        // -- Su dung cau truc export request co nen khong ? --
        // let dataRequest: DataRequest = request.exportRequest() as! DataRequest
        
        if (request.contentType == DbHttpContentType.JSON) {
            dataRequest.responseJSON(queue: queue, completionHandler: { (response) in
                // debugPrint(response)
                // -- Set data for response --
                if let responseObj = request.response {
                    responseObj.httpResponse = response.response
                    responseObj.parse(response.result.value as AnyObject, error: response.error)
                    dispatchHandler(responseObj)
                    // print("response \(String(describing: responseObj.rawData))")
                }
            })
        } else {
            dataRequest.responseString(queue: queue, completionHandler: { (response) in
                // -- Set data for response --
                if let responseObj = request.response {
                    responseObj.httpResponse = response.response
                    responseObj.parse(response.result.value as AnyObject, error: response.error)
                    dispatchHandler(responseObj)
                    // print("response \(String(describing: responseObj.rawData))")
                }
            })
        }
    }
    
    // MARK: - dispatch : call server bat dong bo
    // MARK: -
    // -- Van chua upload duoc multi files --
    class func upload(UploadRequest request: DbUploadRequest, processHandler: @escaping DbUploadProcessHandler, dispatchHandler: @escaping DbDispatchHandler)
    {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for uploadData in request.arrUploadData {
                    // -- Add image data --
                    if let data = uploadData.fileData {
                        multipartFormData.append(data,
                                                 withName: uploadData.fileId!,
                                                 fileName: uploadData.fileName!,
                                                 mimeType: uploadData.mimeType!)
                    }
                }
//                    multipartFormData.append(uploadData.fileData!,
//                                             withName: uploadData.fileId!, // "imagefile"
//                                             fileName: uploadData.fileName!, // "image.jpg"
//                                             mimeType: uploadData.mimeType!) // "image/jpeg"
                // -- Add post params --
                for (key, value) in request.query {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
        },
            to: request.requestUrl,
            headers: request.exportHttpHeader(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress { progress in
//                        print("here = progress.fractionCompleted" + String(Float(progress.fractionCompleted)))
                        processHandler(progress)
                    }
                    upload.validate()
                    upload.responseJSON { response in
                        // debugPrint(response)
                        // -- Set data for response --
                        if let responseObj = request.response {
                            responseObj.httpResponse = response.response
                            responseObj.parse(response.result.value as AnyObject, error: response.error)
                            dispatchHandler(responseObj)
                            // print("response upload = \(String(describing: responseObj.rawData))")
                        }
                    }
                case .failure(let encodingError):
                    debugPrint(encodingError)
                    // -- Set data for response --
                    if let responseObj = request.response {
                        responseObj.httpResponse = nil
                        responseObj.parse(nil, error: encodingError)
                        dispatchHandler(responseObj)
                    }
                }
        })
    }
    
    
    // MARK: - dispatchSynchronous : Call server Synchronous (Dong bo)
    // MARK: -
    // -- Co the khong su dung gia tri tra ve --
    @discardableResult class func dispatchSync(Request request: DbRequest) -> DbResponse
    {
        // https://github.com/Dalodd/Alamofire-Synchronous
        let semaphore = DispatchSemaphore(value: 0) //dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        // -- Su dung Semaphore de waiting cac Thread hoan tat cung voi nhau --
        // let queue = DispatchQueue(label: "com.test.api", qos: .background, attributes: .concurrent)
        let queue = DispatchQueue.global(qos: .default)
        DbHttp.dispatch(Request: request, queue: queue) { (response) in
            print("Chay xong")
            debugPrint(response)
            semaphore.signal()
        }
        // -- Wait until dispatchSemaphore done --
        _ = semaphore.wait(timeout: .distantFuture)
        
        // -- Cach su dung Group --
        //        let group = DispatchGroup()
        //        group.enter()
        //        DbHttp.dispatch(Request: request, queue: DispatchQueue.global(qos: .default)) { (response) in
        //            print("Chay xong")
        //            debugPrint(response)
        //            group.leave()
        //        }
        //        // -- Wait until dispatchSemaphore done --
        //        _ = group.wait(timeout: .distantFuture)
        
        return request.response!
    }
    
    // MARK: -
    // https://gist.github.com/mcxiaoke/3edc23720fcbf589af134c914dd8a0a3
    /// Return data from synchronous URL request
    class func requestSynchronousData(_ request: URLRequest) -> Data?
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
    class func requestSynchronousDataWithURLString(_ requestString: String) -> Data?
    {
        guard let url = URL(string:requestString) else {return nil}
        let request = URLRequest(url: url)
        return self.requestSynchronousData(request)
    }
    
    /// Return JSON synchronous from URL request
    class func requestSynchronousJSON(_ request: URLRequest) -> AnyObject?
    {
        guard let data = self.requestSynchronousData(request) else {return nil}
        //        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        //        return jsonData as AnyObject
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as AnyObject
    }
    
    /// Return JSON synchronous from specified endpoint
    class func requestSynchronousJSONWithURLString(requestString: String) -> AnyObject?
    {
        guard let url = URL(string:requestString) else {return nil}
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return self.requestSynchronousJSON(request)
    }

}




