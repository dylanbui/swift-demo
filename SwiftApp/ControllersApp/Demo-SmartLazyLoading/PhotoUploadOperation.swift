//
//  UploadOperation.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation


class PhotoUploadOperation: DbOperation
{
    var operationId: String = ""
    var photoAsset: PhotoAsset!
    var uploadUrl: URL!
    
    var completionHandler: PhotoUploadCompletion?
    var progressHandler: PhotoUploadProgress?

    
    init(photoAsset: PhotoAsset)
    {
        self.operationId = photoAsset.localIdentifier
        self.photoAsset = photoAsset
        super.init()
    }
    
    override func execute()
    {
        // do work, then call finish()
        // -- Chu y , khi tao hinh anh luc nay khong can bat dong bo, vi no da chay trong task con --
        self.photoAsset.fetchOriginalImage(Synchronous: true) { (image, info) in
            
            guard let uploadImg = image else {
                // -- Loi khong tao duoc anh --
                // -- Co the dung anh tam, anh loi de hien thi --
                // -- Call finished operation --
                self.finish()
                return
            }
            
            var uploadData = DbUploadData()
            uploadData.fileId = "upload_file"
            
            // -- Use for PHP Server --
//            uploadData.fileName = "avatar_1.jpg"
//            uploadData.mimeType = "image/jpeg"
//            uploadData.fileData = UIImageJPEGRepresentation(uploadImg, 1.0)
            uploadData.fileId = "file"
            uploadData.fileName = "survey.png"
            uploadData.mimeType = "image/png"
            uploadData.fileData = UIImagePNGRepresentation(uploadImg)
            
            let requestUpload = DbUploadRequestFor<PropzyResponse>()
            requestUpload.requestUrl = self.uploadUrl.absoluteString
            print("requestUpload.requestUrl = \(String(describing: requestUpload.requestUrl))")
            requestUpload.arrUploadData = [uploadData]
            requestUpload.query = ["type": "survey"]
            
            DbHttp.upload(UploadRequest: requestUpload, processHandler: { (progress) in
                // print("progress.fractionCompleted - " + String(Float(progress.fractionCompleted)))
                self.progressHandler?(self.photoAsset, progress, nil)
            }) { (response) in
                print("Upload => successHandler")
                print("responseData = \(String(describing: response.rawData))")
                // debugPrint(response)
                
                guard let res: PropzyResponse = response as? PropzyResponse,
                    let data = res.data as? DictionaryType else {
                        print("Co loi tra ve du lieu")
                        if self.isCancelled {
                            self.photoAsset.uploadState = .Failed
                        }
                        self.completionHandler?(self.photoAsset, nil)
                        self.finish()
                        return
                }
                
                // self.photoAsset.uploadDone = true
                // -- Save full url --
                self.photoAsset.fullImageUrl = data["link"] as? String
                    
                self.completionHandler?(self.photoAsset, nil)
                // -- Call finished operation --
                self.finish()
            }
        
        }
    }
}
