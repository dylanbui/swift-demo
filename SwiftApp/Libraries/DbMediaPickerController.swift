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

//public enum DbMediaPickerControllerType : Int {
//    case all, avatar, avatarCircle
//}
//var pickerType: DbMediaPickerControllerType! = .all


class DbMediaPickerController: DKImagePickerController
{
    private var cropViewController: CropViewController?
    var didCropToCircularImage: ((DbAsset, UIImage, CGRect, Int) -> Void)?
    var didCropToImage: ((DbAsset, UIImage, CGRect, Int) -> Void)?
    
    private var imgAvatar: UIImage?
    private var singleAsset: DbAsset!
    
    public class func initForSnapPhoto() -> DbMediaPickerController
    {
        let pickerController = DbMediaPickerController()
        self.pickerConfig(pickerController)
        
        pickerController.sourceType = .camera
        pickerController.singleSelect = true
        
        return pickerController
    }
    
    public class func initMultiSelectPhoto() -> DbMediaPickerController
    {
        let pickerController = DbMediaPickerController()
        self.pickerConfig(pickerController)
        return pickerController
    }
    
    public class func initSelectAvatar(_ avatar: UIImage? = nil) -> DbMediaPickerController
    {
        let pickerController = DbMediaPickerController()
        self.pickerConfig(pickerController)
        
        pickerController.singleSelect = true
        pickerController.autoCloseOnSingleSelect = false
        pickerController.imgAvatar = avatar
        
        return pickerController
    }
    
    private class func pickerConfig(_ pickerController: DbMediaPickerController) -> Void
    {
        pickerController.sourceType = .both
        pickerController.assetType = .allPhotos
        pickerController.showsCancelButton = true
        pickerController.showsEmptyAlbums = true
        
        // -- Default value --
        // -- Config NavigationBar Background --
        // pickerController.UIDelegate = CustomUIDelegate()
        
        // -- Thay doi mau chu cho group camera --
        //        UINavigationBar.appearance().titleTextAttributes = [
        //            .font: UIFont.fHelveticaNeue(size: 16.0, type: UIFont.HelveticaNeueType.Medium),
        //            .foregroundColor: UIColor.white
        //        ]
        
        // -- Config NavigationBar Background --
        // pickerController.navigationBar.makeNavStyleOrange()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // -- Hien tho cropt controller truoc --
        if self.singleSelect == true {
            if let img = self.imgAvatar {
                self.showCropViewController(img, false)
            }
        }
    }
    
    override func done()
    {
        if self.singleSelect == false {
            super.done()
            return
        }
        // -- self.selectedAssets is choose image array --
        guard let asset = self.selectedAssets.first else {
            print("Chua chon du lieu")
            return
        }
        
        asset.fetchOriginalImage() { (image, info) in
            self.showCropViewController(image!, true)
        }
        
        self.singleAsset = asset
        
        // self.processChoosePhoto(asset)
    }
    
    //    private func processChoosePhoto(_ asset: DbAsset) -> Void
    //    {
    //        asset.fetchOriginalImage(false) { (image, info) in
    //            self.showCropViewController(image!, true)
    //        }
    //    }
    
    private func showCropViewController(_ image: UIImage, _ animated:Bool)
    {
        // -- Create CropViewController --
        self.cropViewController = CropViewController(image: image)
        self.cropViewController?.resetAspectRatioEnabled = false
        self.cropViewController?.rotateClockwiseButtonHidden = true
        self.cropViewController?.rotateButtonsHidden = true
        self.cropViewController?.aspectRatioPickerButtonHidden = true
        self.cropViewController?.delegate = self
        
        self.pushViewController(self.cropViewController!, animated: true)
    }
    
    
}

extension DbMediaPickerController: CropViewControllerDelegate
{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int)
    {
        // 'image' is the newly cropped version of the original image
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.didCropToImage?(self.singleAsset, image, cropRect, angle)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int)
    {
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.didCropToCircularImage?(self.singleAsset, image, cropRect, angle)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool)
    {
        cropViewController.navigationController?.popViewController(animated: true)
    }
    
}


//typealias DbAsset = DKAsset
//
//public enum DbMediaPickerControllerType : Int {
//    case all, avatar, avatarCircle
//}
//
//
//class DbMediaPickerController: DKImagePickerController, CropViewControllerDelegate {
//
//    var pickerType: DbMediaPickerControllerType! = .all
//
//    private var cropViewController: CropViewController?
//    var didCropAvatarToCircularImage: ((UIImage, CGRect, Int) -> Void)?
//    var didCropAvatarToImage: ((UIImage, CGRect, Int) -> Void)?
//    var didCancelledCropImage: (() -> Void)?
//
//    private func initParams() -> Void {
//        self.showsCancelButton = true
//        self.showsEmptyAlbums = true
//        self.allowMultipleTypes = false
//        self.assetType = .allPhotos
//        self.sourceType = .both;
//        // -- Init variable --
//        self.maxSelectableCount = 5
//        self.sourceType = .both
//        self.singleSelect = false
//    }
//
//    func present(withController vc: UIViewController) {
//        vc.present(self, animated: true)
//    }
//
//    func present(withController vc: UIViewController, imageAvatar image:UIImage) {
////        vc.present(self, animated: true)
//
//        self.cropViewController = CropViewController(croppingStyle: (self.pickerType == .avatar ? .default : .circular), image: image)
//        self.cropViewController?.resetAspectRatioEnabled = false
//        self.cropViewController?.rotateClockwiseButtonHidden = true
//        self.cropViewController?.rotateButtonsHidden = true
//        self.cropViewController?.aspectRatioPickerButtonHidden = true
//        self.cropViewController?.delegate = self;
//
//        vc.present(self, animated: false) {
//            self.pushViewController(self.cropViewController!, animated: true)
//        }
//
////        DbUtils.performAfter(delay: 0.5) {
////            vc.present(self, animated: true)
////        }
//
////        self.db_pushViewController(self.cropViewController!) {
////            vc.present(self, animated: true)
////        }
//    }
//
//
////    override func viewDidLoad() {
////
////        self.initParams()
////
////        if self.pickerType == .avatar {
////            self.singleSelect = true;
////            self.autoCloseOnSingleSelect = false;
////            self.assetType = .allPhotos
////            self.sourceType = .both;
////        }
////        super.viewDidLoad()
////    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        self.initParams()
//
//        if self.pickerType != .all {
//            self.singleSelect = true;
//            self.autoCloseOnSingleSelect = false;
//            self.assetType = .allPhotos
//            self.sourceType = .both;
//        }
//
//        super.viewWillAppear(animated)
//    }
//
//    override func done() {
//        if pickerType == .all {
//            super.done()
//            return
//        }
//        // -- self.selectedAssets is choose image array --
//        guard let asset = self.selectedAssets.first else {
//            print("Chua chon du lieu")
//            return
//        }
//
//        self.processChoosePhoto(asset)
//
////        self.presentingViewController?.dismiss(animated: true, completion: {
////            self.didSelectAssets?(self.selectedAssets)
////        })
//
//    }
//
//    func processChoosePhoto(_ asset: DbAsset) -> Void {
//        asset.fetchOriginalImage(false) { (image, info) in
//            //self.cropViewController = CropViewController(image: image!)
//            self.cropViewController = CropViewController(croppingStyle: (self.pickerType == .avatar ? .default : .circular), image: image!)
//            self.cropViewController?.resetAspectRatioEnabled = false
//            self.cropViewController?.rotateClockwiseButtonHidden = true
//            self.cropViewController?.rotateButtonsHidden = true
//            self.cropViewController?.aspectRatioPickerButtonHidden = true
//            self.cropViewController?.delegate = self;
//
//            self.pushViewController(self.cropViewController!, animated: true)
//        }
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        // 'image' is the newly cropped version of the original image
//        self.presentingViewController?.dismiss(animated: true, completion: {
//            self.didCropAvatarToImage?(image, cropRect, angle)
//        })
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.presentingViewController?.dismiss(animated: true, completion: {
//            self.didCropAvatarToCircularImage?(image, cropRect, angle)
//        })
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
//        cropViewController.navigationController?.popViewController(animated: true)
//        self.didCancelledCropImage?()
//    }
//
//
//}
