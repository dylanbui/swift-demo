//
//  DemoLazyUploadViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/3/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//
/*
 Phien ban nay chay khong on dinh, kiem soat upload done trong operator khong tot, de lam tham khao thoi
 
 */

import UIKit

class DemoLazyUploadViewController_V1: UIViewController
{
    @IBOutlet var myCollectionView: UICollectionView!
    
    var arrPhotoAsset: [PhotoAsset] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupCollection()

        // Do any additional setup after loading the view.
        PhotoUploadManager.shared.uploadUrl = URL.init(string: "http://45.117.162.49:8080/file/api/upload")!
    }

    func setupCollection()
    {
        let spacing: CGFloat = 5
        let itemHeight: CGFloat = 90
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        // Apply flow layout
        self.myCollectionView.collectionViewLayout = layout
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        
        self.myCollectionView.register(ImageRowCollectionCell.self, forCellWithReuseIdentifier: "imageRowCollectionCell")
        let nib = UINib(nibName: "ImageRowCollectionCell", bundle: nil)
        self.myCollectionView.register(nib, forCellWithReuseIdentifier: "imageRowCollectionCell")
        
        self.myCollectionView.isPagingEnabled = false
    }
    
    @IBAction func btnResult_Click(_ sender: UIButton)
    {
        for asset in self.arrPhotoAsset {
            print("-- \(String(describing: asset.indexPath))")
            print("     \(String(describing: asset.uploadDone))")
            print("     \(String(describing: asset.fullImageUrl))")
        }
    }
    
    @IBAction func btnAddPhoto_Click(_ sender: UIButton)
    {
        let pickerController = DbMediaPickerController.initMultiSelectPhoto()
        
        pickerController.didSelectAssets = { (assets: [DbAsset]) -> Void in
            
            var indexPaths: [IndexPath] = []
            var currentItemCount = self.arrPhotoAsset.count
            
            for asset: DbAsset in assets {
                // -- Create IndexPath --
                let indexPath = IndexPath.init(row: currentItemCount, section: 0)
                indexPaths.append(indexPath)
                // -- Create PhotoAsset --
                let photoAsset = PhotoAsset.init(asset: asset, indexPath: indexPath)
                self.arrPhotoAsset.append(photoAsset)
                
                currentItemCount += 1
            }
            
            // -- Reload --
            // self.myCollectionView.reloadSections(IndexSet(integer: 0))
            
            // finally update the collection view
            self.myCollectionView.performBatchUpdates({
                self.myCollectionView.insertItems(at: indexPaths)
            }, completion: { (finished) in
                print("scroll to index path: \(indexPaths.count)")
                print("indexPaths.last! = \(String(describing: indexPaths.last!))")
                self.myCollectionView.scrollToItem(at: indexPaths.last!, at: .right , animated: true)
            })
            
        }
        
        pickerController.didCancel = { () -> Void in
            print("didCancel")
        }
        
        Db.rootViewController().present(pickerController, animated: true, completion: nil)
    }
    
//    func fetchOriginalImage(Asset asset: DbAsset?, completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void) -> Void
//    {
//        guard let imgAsset = asset else {
//            print("Asset not found")
//            return
//        }
//
//        let imgWidth = imgAsset.originalAsset?.pixelWidth
//        let imgHeight = imgAsset.originalAsset?.pixelHeight
//        var imgSize: CGSize = CGSize(UPLOAD_PHOTO_WIDTH, UPLOAD_PHOTO_HEIGHT)
//        if imgHeight! > imgWidth! {
//            imgSize = CGSize(UPLOAD_PHOTO_HEIGHT, UPLOAD_PHOTO_WIDTH)
//        }
//
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.resizeMode = .fast
//        requestOptions.deliveryMode = .highQualityFormat
//        // Anh huong den performance
//        requestOptions.isSynchronous = false //true // User synchronous
//
//        imgAsset.fetchImageWithSize(imgSize, options: requestOptions) { (image, dict) in
//            completeBlock(image, dict)
//            //            print("image?.size = \(String(describing: image?.size))")
//            //            let data = UIImageJPEGRepresentation(image!, 1)
//            //            // let imageSize = data?.count
//            //            //                    let data: Data = UIImageJPEGRepresentation(image!, 1.0) as? Data
//            //            print("Size of your image is \(data!.count/1024) KB")
//        }
//
//    }
    

}

extension DemoLazyUploadViewController_V1: UICollectionViewDataSource, UICollectionViewDelegate
{
    //MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let asset = self.arrPhotoAsset[indexPath.row]

        asset.getThumbPhoto { (image) in
            (cell as! ImageRowCollectionCell).imageView.image = image
        }
        
//        if asset.uploadDone {
//            return
//        }
        
        // -- Bat dau upload photo --
        PhotoUploadManager.shared.upload(asset, complete: { (asset, error) in

//             if let indexPathNew = asset.indexPath, indexPathNew == indexPath {
                DispatchQueue.main.async {
                    // asset.uploadDone = true // Xu ly ben trong upload manager                    
                    print("asset.uploadDone = \(String(describing: asset.uploadDone))")
                    print("asset.fullImageUrl = \(String(describing: asset.fullImageUrl))")
                    print("asset.indexPath = \(String(describing: asset.indexPath))")
                    // -- Cap nhat cell, khi da upload thanh cong --
                    // (cell as! ImageRowCollectionCell).reloadUploadStatusDone(done: asset.uploadDone)
                    
                    if let indexPath = asset.indexPath {
                        // self.myCollectionView.reloadItems(at: [indexPath])
                        // -- Day la nhung cell bi hidden khi di chuyen, se khong tim thay --
                        if let cell = self.myCollectionView.cellForItem(at: indexPath) as? ImageRowCollectionCell {
                            cell.reloadUploadStatusDone(done: true)
                        }
                        
                    }
                }
//             }

        }) { (asset, progress, error) in

            // if let indexPathNew = asset.indexPath, indexPathNew == indexPath {
                
//                print("IndexPath = " + String(asset.indexPath?.row ?? -1) + " - progress - " + String(Float(progress.fractionCompleted)))
            
                // -- Upload cell progress --
                DispatchQueue.main.async {
                    // -- Xu ly progress nay bao gom ca lan xuat hien lan dau --
                    // -- Cap nhat cell, khi uploading --
                    (cell as! ImageRowCollectionCell).reloadUploadStatusDone(done: asset.uploadDone)
                }
            // }

        }
        
//        ImageDownloadManager.shared.downloadImage(flickrPhoto, indexPath: indexPath) { (image, url, indexPathh, error) in
//            if let indexPathNew = indexPathh, indexPathNew == indexPath {
//                DispatchQueue.main.async {
//                    (cell as! FlickrPhotoCell).imageView.image = image
//                }
//            }
//        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        /* Reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
        // let asset = self.arrPhotoAsset[indexPath.row]
        // Save get item, when delete item from Array
        if let asset = self.arrPhotoAsset.db_item(at: indexPath.row) {
            PhotoUploadManager.shared.slowDownPhotoUploadTaskfor(asset)
        }
        
    }
    
    
    //MARK: UICollectionViewDataSource
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // TODO:- Required Method
        return self.arrPhotoAsset.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ImageRowCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageRowCollectionCell", for: indexPath) as! ImageRowCollectionCell
        
        let asset = self.arrPhotoAsset[indexPath.row]
        cell.reloadUploadStatusDone(done: asset.uploadDone)
//        asset.getThumbPhoto { (image) in
//            cell.imageView.image = image
//        }
        
        cell.imageView.isUserInteractionEnabled = true
        cell.indexPath = indexPath
        
        cell.deleteAction = { indexPath in
            guard let removeIndex = indexPath else {
                return
            }
            self.arrPhotoAsset.remove(at: removeIndex.row)
            // -- Reload --
            self.myCollectionView.reloadSections(IndexSet(integer: 0))
        }
        
//        let asset = self.arrPhotoAsset[indexPath.row]
//        cell.reloadUploadStatusDone(done: asset.uploadDone)
        
        return cell
    }
    
}
