//
//  PhotoUploadManager.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias PhotoUploadCompletion = (_ photoAsset: PhotoAsset, _ error: Error?) -> Void
typealias PhotoUploadProgress = (_ photoAsset: PhotoAsset, _ progress: Progress,_ error: Error?) -> Void

final class PhotoUploadManager
{
    private var completionHandler: PhotoUploadCompletion?
    private var progressHandler: PhotoUploadProgress?
    
    lazy var photoUploadQueue: DbOperationQueue = {
        var queue = DbOperationQueue()
        queue.name = "com.flickrTest.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        // queue.maxConcurrentOperationCount = 1
        return queue
    }()
    let imageCache = NSCache<NSString, UIImage>()
    
    static let shared = PhotoUploadManager()
    private init () {}
    
    public var uploadUrl: URL!
    
    func upload(_ photoAsset: PhotoAsset, complete: @escaping PhotoUploadCompletion,
                progress: @escaping PhotoUploadProgress) {
        self.completionHandler = complete
        self.progressHandler = progress
        
//        if photoAsset.uploadDone {
//            self.completionHandler?(photoAsset, nil)
//            return
//        }
        
        if photoAsset.uploadState == .Done {
            self.completionHandler?(photoAsset, nil)
            return
        }

        /* check if there is a download task that is currently downloading the same image. */
        if let operations = (photoUploadQueue.operations as? [PhotoUploadOperation])?.filter({$0.operationId == photoAsset.localIdentifier && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Increase the priority to - VERY HIGH - for \(photoAsset.localIdentifier)")
            operation.queuePriority = .veryHigh
        }else {
            /* create a new task to download the image.  */
            print("Create a new task for \(photoAsset.localIdentifier)")
            
            let operation = PhotoUploadOperation(photoAsset: photoAsset)
            operation.uploadUrl = self.uploadUrl
            operation.queuePriority = .high
            if photoAsset.indexPath == nil {
                operation.queuePriority = .high
            }
            
            operation.progressHandler = { (_ photoAsset, _ progress, _ error) in
                self.progressHandler?(photoAsset, progress, error)
            }
            operation.completionHandler = { (_ photoAsset, _ error) in
                //photoAsset.uploadDone = true
                self.completionHandler?(photoAsset, nil)
            }
            
            photoUploadQueue.addOperation(operation)            
        }
    }
    
    /* FUNCTION to reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
    func slowDownPhotoUploadTaskfor (_ photoAsset: PhotoAsset)
    {
        if let operations = (photoUploadQueue.operations as? [PhotoUploadOperation])?.filter({$0.operationId == photoAsset.localIdentifier && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority to - LOW - for \(photoAsset.localIdentifier)")
            operation.queuePriority = .low
        }
    }
    
    func cancelAll()
    {
        photoUploadQueue.cancelAllOperations()
    }
    
}
