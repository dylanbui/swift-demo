//
//  DemoUploadCollectionViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoUploadCollectionViewController: UIViewController
{
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var btnChoosePhoto: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var lblStatus: UILabel!

    var arrPhotoAsset: [PhotoAsset] = []
    var isScrolling: Bool = false
    
    private var countUploadDone: Int = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Upload Photos"
        
        self.edgesForExtendedLayout = []
        
        self.setupCollection()
        
        // Do any additional setup after loading the view.
        PhotoUploadManager.shared.uploadUrl = URL.init(string: "http://45.117.162.49:8080/file/api/upload")!
    }
    
    func setupCollection()
    {
        let spacing: CGFloat = 5
        let itemHeight: CGFloat = 90
        let layout = UICollectionViewFlowLayout.init()
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
    }
    
    @IBAction func btnChoosePhoto_Click(_ sender: AnyObject)
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
                // print("scroll to index path: \(indexPaths.count)")
                // print("indexPaths.last! = \(String(describing: indexPaths.last!))")
                // self.myCollectionView.scrollToItem(at: indexPaths.last!, at: .right , animated: true)
            })
            // -- Allow add more photo when uploading --
            // -- Scroll to bottom --
//            self.myCollectionView.scrollToItem(at: indexPaths.last!, at: .right , animated: true)
//            DbUtils.performAfter(delay: 1.5, dispatch_block: {
//                self.startOperationForOnscreenRows()
//            })
        }
        
        pickerController.didCancel = { () -> Void in
            print("didCancel")
        }
        
        Db.rootViewController().present(pickerController, animated: true, completion: nil)
    }

    @IBAction func btnUpload_Click(_ sender: AnyObject)
    {
        self.lblStatus.text = "Uploading ...."
        
        self.startOperationForOnscreenRows()
    }
    
    private func startOperationForOnscreenRows()
    {
        if self.arrPhotoAsset.count <= 0 {
            return
        }
        // -- Chi lay nhung visible cell --
        let indexPaths = self.myCollectionView.indexPathsForVisibleItems
        print("indexPathsForVisibleItems = \(String(describing: indexPaths))")
        for indexPath in indexPaths {
            
            let asset = self.arrPhotoAsset[indexPath.row]
            
            // -- Bat dau upload photo --
            // PhotoUploadManager.shared.upload se tu tao cac operator dua vao asset
            // Neu nhung asset nao da co operator thi priority cua operator do se duoc set la high (do la visible cell)
            PhotoUploadManager.shared.upload(asset, complete: { (asset, error) in
                
                if let indexPath = asset.indexPath, self.isScrolling == false {
                    DispatchQueue.main.async {
                        // -- Cap nhat cell, khi da upload thanh cong --
                        // -- Chi chay 1 lan ham complete upload --
                        if asset.uploadState == .Done || asset.uploadState == .Failed {
                            return
                        }
                        asset.uploadState = .Done
                        
                        self.countUploadDone += 1
                        self.lblStatus.text = "Đã upload \(self.countUploadDone)/\(self.arrPhotoAsset.count)"
                        
                        print("asset.uploadDone = \(String(describing: asset.uploadDone))")
                        print("asset.fullImageUrl = \(String(describing: asset.fullImageUrl))")
                        print("asset.indexPath = \(String(describing: asset.indexPath))")
                        if let cell = self.myCollectionView.cellForItem(at: indexPath) as? ImageRowCollectionCell {
                            cell.reloadCellFor(asset: asset)
                        }
                    }
                }
                
            }) { (asset, progress, error) in
                
                // print("IndexPath = " + String(asset.indexPath?.row ?? -1) + " - progress - " + String(Float(progress.fractionCompleted)))
                asset.uploadProgress = progress
                asset.uploadState = .Uploading
                
                if let indexPath = asset.indexPath, self.isScrolling == false {
                    // -- Upload cell progress --
                    DispatchQueue.main.async {
                        // -- Xu ly progress nay bao gom ca lan xuat hien lan dau --
                        // -- Cap nhat cell, khi uploading --
                        // -- Day la nhung cell bi hidden khi di chuyen, se khong tim thay --
                        if let cell = self.myCollectionView.cellForItem(at: indexPath) as? ImageRowCollectionCell {
                            cell.reloadCellFor(asset: asset)
                        }
                    }
                }
            }
            
        }
        
    }

    private func suspendedUpload(status: Bool)
    {
        // -- true => stop upload --
        // -- false => resume upload --
        self.isScrolling = status
        // -- Khong can suspended vi se tao moi --
        // Chi can chuyen trang thai cac queuePriority = .low
        // PhotoUploadManager.shared.suspendedAll(self.isScrolling)
    }
}


extension DemoUploadCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    //MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        /* Reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
        // Nhung cell nao sap hidden se duoc set priority low
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
        cell.reloadCellFor(asset: asset)
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
        
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        // -- Stop het moi operator --
        self.suspendedUpload(status: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            // -- Active when only drag --
            print("==> -- scrollViewDidEndDragging")
            
            self.suspendedUpload(status: false)
            
            // -- Start het moi operator --
            self.startOperationForOnscreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        // -- Active when drag to end and drop --
        print("==> ++ scrollViewDidEndDecelerating")
        
        self.suspendedUpload(status: false)
        
        // -- Start het moi operator --
        self.startOperationForOnscreenRows()
    }
}
