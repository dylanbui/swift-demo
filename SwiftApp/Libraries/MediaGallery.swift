//
//  MediaGallery.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/24/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import DKImagePickerController

//var didSelectAssets: (([DKAsset]) -> Void)?
//var didCancel: (() -> Void)?


typealias DbAsset = DKAsset

protocol MediaGalleryDelegate {
    func didSelectAssets(_ asset: DbAsset)
    func didCancel()
}

class MediaGallery {
    
    var assetType: DKImagePickerControllerAssetType = .allPhotos
    var sourceType: DKImagePickerControllerSourceType = .both
    
    var singleSelect: Bool! = false
    var maxSelected: Int! = 5
    
    var didSelectAssets: (([DbAsset]) -> Void)?
    var didCancel: (() -> Void)?
    
    static let sharedInstance = MediaGallery()
    private let pickerController = DKImagePickerController()
    
    private var ownerViewController: UIViewController?
    
    private init() {
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
        
        self.pickerController.maxSelectableCount = (self.maxSelected <= 0) ? 5 : self.maxSelected
        self.pickerController.sourceType = self.sourceType
        self.pickerController.singleSelect = self.singleSelect
        
        // -- Remove old select --
        self.pickerController.deselectAllAssets()
        
        self.ownerViewController?.present(self.pickerController, animated: true, completion: { })
        

    }
    
}
