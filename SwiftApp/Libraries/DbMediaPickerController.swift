//
//  DbMediaPickerController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/25/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import DKImagePickerController
import CropViewController

typealias DbAsset = DKAsset

public enum DbMediaPickerControllerType : Int {
    case all, avatar
}


class DbMediaPickerController: DKImagePickerController, CropViewControllerDelegate {
    
    var pickerType: DbMediaPickerControllerType! = .all

    private var cropViewController: CropViewController?
    var didCropToCircularImage: ((UIImage, CGRect, Int) -> Void)?
    var didCropToImage: ((UIImage, CGRect, Int) -> Void)?
    
    private func initParams() -> Void {
        self.showsCancelButton = true
        self.showsEmptyAlbums = true
        self.allowMultipleTypes = false
        self.assetType = .allPhotos
        self.sourceType = .both;
        // -- Init variable --
        self.maxSelectableCount = 5
        self.sourceType = .both
        self.singleSelect = false
    }
    
//    override func viewDidLoad() {
//
//        self.initParams()
//
//        if self.pickerType == .avatar {
//            self.singleSelect = true;
//            self.autoCloseOnSingleSelect = false;
//            self.assetType = .allPhotos
//            self.sourceType = .both;
//        }
//        super.viewDidLoad()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.initParams()
        
        if self.pickerType == .avatar {
            self.singleSelect = true;
            self.autoCloseOnSingleSelect = false;
            self.assetType = .allPhotos
            self.sourceType = .both;
        }

        super.viewWillAppear(animated)
    }
    
    override func done() {
        if pickerType == .all {
            super.done()
            return
        }
        // -- self.selectedAssets is choose image array --
        guard let asset = self.selectedAssets.first else {
            print("Chua chon du lieu")
            return
        }

        self.processChoosePhoto(asset)
        
//        self.presentingViewController?.dismiss(animated: true, completion: {
//            self.didSelectAssets?(self.selectedAssets)
//        })
        
    }
    
    func processChoosePhoto(_ asset: DbAsset) -> Void {
        asset.fetchOriginalImage(false) { (image, info) in
            self.cropViewController = CropViewController(image: image!)
            self.cropViewController?.resetAspectRatioEnabled = false
            self.cropViewController?.rotateClockwiseButtonHidden = true
            self.cropViewController?.rotateButtonsHidden = true
            self.cropViewController?.aspectRatioPickerButtonHidden = true
            self.cropViewController?.delegate = self;
            
            self.pushViewController(self.cropViewController!, animated: true)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.didCropToImage?(image, cropRect, angle)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.didCropToCircularImage?(image, cropRect, angle)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        //self.presentingViewController?.navigationController?.popViewController(animated: true)
        cropViewController.navigationController?.popViewController(animated: true)
    }
    
    
}
