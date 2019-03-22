//
//  PhotoAsset.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import Photos

// This enum contains all the possible states a photo record can be in
enum PhotoAssetUploadState {
    case New, Done, Uploading, Failed, Waiting
}

class PhotoAsset : Equatable
{
    public var localIdentifier: String
    public var fullImageUrl: String?
    public var indexPath: IndexPath?
    public var uploadDone: Bool = false // Co the bo khong su dung, chuyen qua su dung uploadState
    public var uploadState: PhotoAssetUploadState = .New
    public var uploadProgress: Progress?
    
    private var asset: DbAsset!
    private let imageCache = NSCache<NSString, UIImage>()
    
    init (asset: DbAsset, indexPath: IndexPath?) {
        self.asset = asset
        self.localIdentifier = asset.localIdentifier
        self.indexPath = indexPath
        self.uploadState = .New
        
        // -- Get thumb image and save to cache --
        self.getThumbPhoto { (image) in }
    }
    
    func getThumbPhoto(complete: @escaping (_ image: UIImage) -> Void )
    {
        if let cachedImage = imageCache.object(forKey: "thumb_"+self.asset.localIdentifier as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
            complete(cachedImage)
            return
        }
        
        // -- Tinh toan image de lay thumb phu hop --
        let size: CGSize = CGSize(width: 90, height: 90)
        self.asset.fetchImage(with: size) { (image, info) in
            if let newImage = image {
                complete(newImage)
                self.imageCache.setObject(newImage, forKey: "thumb_"+self.asset.localIdentifier as NSString)
            }
        }
    }
    
    func fetchOriginalImage(Synchronous sync: Bool = false, completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)
    {
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = sync
        
        // -- Chinh lai ham nay de lay thong so phu hop cho upload file --
        self.asset.fetchOriginalImage(options: options) { (image, info) in
            completeBlock(image, info)
        }
    }
    
}

func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
    return lhs.localIdentifier == rhs.localIdentifier
}
