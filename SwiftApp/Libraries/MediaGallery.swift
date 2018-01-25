//
//  MediaGallery.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/24/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import DKImagePickerController
import CropViewController

//var didSelectAssets: (([DKAsset]) -> Void)?
//var didCancel: (() -> Void)?

// -- Khong su dung --

//typealias DbAsset = DKAsset

protocol MediaGalleryDelegate {
    func didSelectAssets(_ asset: DbAsset)
    func didCancel()
}

class MediaGallery : NSObject, CropViewControllerDelegate {
    
    var assetType: DKImagePickerControllerAssetType = .allPhotos
    var sourceType: DKImagePickerControllerSourceType = .both
    
    var singleSelect: Bool! = false
    var maxSelected: Int! = 5
    
    var didSelectAvatarAssets: ((DbAsset) -> Void)?
    var didSelectAssets: (([DbAsset]) -> Void)?
    var didCancel: (() -> Void)?
    
    var didCropToCircularImage: ((UIImage, CGRect, Int) -> Void)?
    var didCropToImage: ((UIImage, CGRect, Int) -> Void)?
    
    
//    @property (nonatomic, copy) void (^ _Nullable didCropToCircularImage)(UIImage * _Nonnull image, CGRect cropRect, NSInteger angle);
//    @property (nonatomic, copy) void (^ _Nullable didCropToImage)(UIImage * _Nonnull image, CGRect cropRect, NSInteger angle);
//    @property (nonatomic, copy) void (^ _Nullable didCancel)(void);

    
    
    
    static let sharedInstance = MediaGallery()
    private let pickerController = DKImagePickerController()
    
    private var cropViewController: CropViewController?
    
    private var ownerViewController: UIViewController?
    
    private override init() {
        super.init()
        initPrivate()
    }
    
    private func initPrivate() -> Void {
        //self.pickerController = DKImagePickerController()
        //self.pickerController.autoDismissViewController = NO;
        self.pickerController.showsCancelButton = true
        self.pickerController.showsEmptyAlbums = true
        self.pickerController.allowMultipleTypes = false
        self.pickerController.singleSelect = false;
        self.pickerController.assetType = .allPhotos
        self.pickerController.sourceType = .both;
        // -- Init variable --
        self.maxSelected = 5;
        self.sourceType = .both;
        self.singleSelect = false;
    }
    
    func show() -> Void {
        self.show(with: DbUtils.getTopViewController())
    }
    
    func show(with viewController: UIViewController?) -> Void {
        
        self.ownerViewController = viewController
        
//        if viewController == nil {
//            viewController = DbUtils.getTopViewController() as? UIViewController
//        }
        
//        viewController = nil
//        if let controller = viewController {
//            viewController = DbUtils.getTopViewController()
//        }
        
        //viewController = DbUtils.getTopViewController() as! UIViewController
        
//        _ = viewController ?? DbUtils.getTopViewController()
        
        self.pickerController.didSelectAssets = { (assets: [DbAsset]) in
            
            if assets.count <= 0 {
                return
            }
            
            guard let didSelectAssets = self.didSelectAssets else {
                return
            }
            didSelectAssets(assets)
            self.ownerViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        self.pickerController.didCancel = { () -> Void in
            
            guard let didCancel = self.didCancel else {
                return
            }
            didCancel()
            self.ownerViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        self.pickerController.maxSelectableCount = (self.maxSelected <= 0) ? 5 : self.maxSelected
        self.pickerController.sourceType = self.sourceType
        self.pickerController.singleSelect = self.singleSelect
        
        // -- Remove old select --
        self.pickerController.deselectAllAssets()
        
        self.ownerViewController?.present(self.pickerController, animated: true, completion: { })
    }
    
    func showAvatar(with viewController: UIViewController?) -> Void {
        
        self.ownerViewController = viewController
        
        self.pickerController.didSelectAssets = { (assets: [DbAsset]) in
            
            if assets.count <= 0 {
                return
            }
            self.processChoosePhoto(assets.first!)
        }
        
        self.pickerController.didCancel = { () -> Void in
            
            guard let didCancel = self.didCancel else {
                return
            }
            didCancel()
            self.ownerViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        self.pickerController.singleSelect = true;
        self.pickerController.autoCloseOnSingleSelect = false;
        self.pickerController.assetType = .allPhotos
        self.pickerController.sourceType = .both;

        // -- Remove old select --
        self.pickerController.deselectAllAssets()
        
        self.ownerViewController?.present(self.pickerController, animated: true, completion: { })

    }
    
    func processChoosePhoto(_ asset: DbAsset) -> Void {
        asset.fetchOriginalImage(false) { (image, info) in
            
            guard let image = image else {
                return
            }
            
            print("Lay duoc hinh, tao man hinh cat")
            self.cropViewController = CropViewController(image: image)
            self.cropViewController?.resetAspectRatioEnabled = false
            self.cropViewController?.rotateClockwiseButtonHidden = true
            self.cropViewController?.rotateButtonsHidden = true
            self.cropViewController?.aspectRatioPickerButtonHidden = true
            self.cropViewController?.delegate = self;

            self.pickerController.pushViewController(self.cropViewController!, animated: true)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.pickerController.presentingViewController?.dismiss(animated: true, completion: {
            guard let didCropToImage = self.didCropToImage else {
                return
            }
            didCropToImage(image, cropRect, angle)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.pickerController.presentingViewController?.dismiss(animated: true, completion: {
            guard let didCropToCircularImage = self.didCropToCircularImage else {
                return
            }
            didCropToCircularImage(image, cropRect, angle)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.pickerController.navigationController?.popViewController(animated: true)
    }
    
}
