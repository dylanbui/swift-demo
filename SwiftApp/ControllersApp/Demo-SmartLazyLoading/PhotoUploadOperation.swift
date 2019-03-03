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
//        DispatchQueue.main.delayed(self.delay) {
//            self.finish()
//        }
        
        self.photoAsset.fetchOriginalImage { (image, info) in
            
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
            uploadData.fileName = "avatar_1.jpg"
            uploadData.mimeType = "image/jpeg"
            uploadData.fileData = UIImageJPEGRepresentation(uploadImg, 1.0);
            
            let requestUpload = DbUploadRequestFor<PropzyResponse>()
            requestUpload.requestUrl = self.uploadUrl.absoluteString
            requestUpload.arrUploadData = [uploadData]
            requestUpload.query = ["type": "avatar"]
            
            DbHttp.upload(UploadRequest: requestUpload, processHandler: { (progress) in
                print("progress.fractionCompleted" + String(Float(progress.fractionCompleted)))
                self.progressHandler?(self.photoAsset, progress, nil)
            }) { (response) in
                print("Upload => successHandler")
                print("responseData = \(String(describing: response.rawData))")
                // debugPrint(response)
                if let res: PropzyResponse = response as? PropzyResponse {
                    print("PropzyResponse = \(String(describing: res.data))")
                    
                    self.photoAsset.uploadDone = true
                    // -- Save full url --
                    // self.photoAsset.fullImageUrl = res.data
                }
                
                // -- Call finished operation --
                self.finish()
            }
        
        }
    }
}
