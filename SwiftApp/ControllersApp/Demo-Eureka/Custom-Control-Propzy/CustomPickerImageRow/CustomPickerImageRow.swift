
//
//  CustomPickerImageRow.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 2/22/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Photos

public class CustomPickerImageCell : Cell<Array<UIImage>>, CellType, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet var lblTitle: UILabel!    
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var myCollectionView: UICollectionView!
    
    open override func setup()
    {
        height = { 57 }
        self.lblTitle.text = row.title
        super.setup()
        selectionStyle = .none
        self.row.value = Array<UIImage>()
        
        let spacing: CGFloat = 2
        let itemHeight: CGFloat = 47
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        // Apply flow layout
        self.myCollectionView.collectionViewLayout = layout
        
        self.myCollectionView.register(ImageRowCollectionCell.self, forCellWithReuseIdentifier: "imageRowCollectionCell")
        let nib = UINib(nibName: "ImageRowCollectionCell", bundle: nil)
        self.myCollectionView.register(nib, forCellWithReuseIdentifier: "imageRowCollectionCell")
        
        self.myCollectionView.isPagingEnabled = false
    }
    
    open override func update()
    {
        row.title = nil
        super.update()
    }
    
    @IBAction func btnAddPhoto_Click(_ sender: UIButton)
    {
        guard let arrImage = self.row.value else {
            return
        }
        
        if arrImage.count >= 4 {
            PzAlert.showWarningAlert("Cho phép chọn tối đa \(4) ảnh.")
            return
        }
        
        let pickerController = PzImagePickerController.initMultiSelectPhoto()
        pickerController.maxSelectableCount = 4 - arrImage.count // Limit
        
        pickerController.didSelectAssets = { (assets: [PzAsset]) -> Void in
            for asset: PzAsset in assets {
                self.fetchOriginalImage(Asset: asset, completeBlock: { (image, dict) in
                    if image == nil { return }
                    // -- Add to array --
                    self.row.value!.append(image!)
                    // -- Reload --
                    self.myCollectionView.reloadSections(IndexSet(integer: 0))
                })
            }
        }
        
        pickerController.didCancel = { () -> Void in
            print("didCancel")
        }
                
        Db.rootViewController().present(pickerController, animated: true, completion: nil)
    }
    
    func fetchOriginalImage(Asset asset: PzAsset?, completeBlock: @escaping (_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void) -> Void
    {
        guard let imgAsset = asset else {
            print("Asset not found")
            return
        }
        
        let imgWidth = imgAsset.originalAsset?.pixelWidth
        let imgHeight = imgAsset.originalAsset?.pixelHeight
        var imgSize: CGSize = CGSize(UPLOAD_PHOTO_WIDTH, UPLOAD_PHOTO_HEIGHT)
        if imgHeight! > imgWidth! {
            imgSize = CGSize(UPLOAD_PHOTO_HEIGHT, UPLOAD_PHOTO_WIDTH)
        }
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .fast
        requestOptions.deliveryMode = .highQualityFormat
        // Anh huong den performance
        requestOptions.isSynchronous = false //true // User synchronous
        
        imgAsset.fetchImageWithSize(imgSize, options: requestOptions) { (image, dict) in
            completeBlock(image, dict)
            //            print("image?.size = \(String(describing: image?.size))")
            //            let data = UIImageJPEGRepresentation(image!, 1)
            //            // let imageSize = data?.count
            //            //                    let data: Data = UIImageJPEGRepresentation(image!, 1.0) as? Data
            //            print("Size of your image is \(data!.count/1024) KB")
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
        return row.value?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageRowCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageRowCollectionCell", for: indexPath) as! ImageRowCollectionCell
        
        if let arrImage = row.value {
            cell.imageView.image = arrImage[indexPath.row]
            cell.indexImage = indexPath.row
            
            cell.deleteAction = { indexImage in
                guard let removeIndex = indexImage else {
                    return
                }
                self.row.value?.remove(at: removeIndex)
                // -- Reload --
                self.myCollectionView.reloadSections(IndexSet(integer: 0))

            }
        }
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
}


public final class CustomPickerImageRow: Row<CustomPickerImageCell>, RowType
{
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<CustomPickerImageCell>(nibName: "CustomPickerImageCell")
    }
}
