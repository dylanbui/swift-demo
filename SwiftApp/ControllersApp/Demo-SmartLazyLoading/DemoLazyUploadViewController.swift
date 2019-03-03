//
//  DemoLazyUploadViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/3/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoLazyUploadViewController: UIViewController
{
    @IBOutlet var myCollectionView: UICollectionView!
    
    var arrPhotoAsset: [PhotoAsset] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PhotoUploadManager.shared.uploadUrl = URL.init(string: "")!
    }

    func setupCollection()
    {
        let spacing: CGFloat = 2
        let itemHeight: CGFloat = 47
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
    
    @IBAction func btnAddPhoto_Click(_ sender: UIButton)
    {
        let pickerController = DbMediaPickerController.initMultiSelectPhoto()
        
        pickerController.didSelectAssets = { (assets: [DbAsset]) -> Void in
            for asset: DbAsset in assets {
//                self.fetchOriginalImage(Asset: asset, completeBlock: { (image, dict) in
//                    if image == nil { return }
//                    // -- Add to array --
//                    //self.row.value!.append(image!)
//                    // -- Reload --
//                    self.myCollectionView.reloadSections(IndexSet(integer: 0))
//                })
            }
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

extension DemoLazyUploadViewController: UICollectionViewDataSource, UICollectionViewDelegate
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
            
            if let indexPathNew = asset.indexPath, indexPathNew == indexPath {
                DispatchQueue.main.async {
                    // asset.uploadDone = true // Xu ly ben trong upload manager
                    // -- Cap nhat cell, khi da upload thanh cong --
                    (cell as! ImageRowCollectionCell).reloadUploadStatusDone(done: asset.uploadDone)
                }
            }
            
        }) { (asset, progress, error) in
            
            if let indexPathNew = asset.indexPath, indexPathNew == indexPath {
                // -- Upload cell progress --
                DispatchQueue.main.async {
                    // -- Xu ly progress nay bao gom ca lan xuat hien lan dau --
                }
            }
            
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
        let asset = self.arrPhotoAsset[indexPath.row]
        PhotoUploadManager.shared.slowDownPhotoUploadTaskfor(asset)
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
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageRowCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageRowCollectionCell", for: indexPath) as! ImageRowCollectionCell
        
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
