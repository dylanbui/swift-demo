//
//  PhotoGalleryViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import DKImagePickerController

class PhotoGalleryViewController: UIViewController {
    
    var assetType: DKImagePickerControllerAssetType = .allPhotos
    var sourceType: DKImagePickerControllerSourceType = .both
    
    var singleSelect: Bool! = false
    var maxSelected: Int! = 5
    
    var didSelectAssets: (([DKAsset]) -> Void)?
    var didCancel: (() -> Void)?
    
    static let sharedInstance = PhotoGalleryViewController()
    
    private var pickerController: DKImagePickerController?
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initPrivate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPrivate()
    }
    
    private func initPrivate() -> Void {
        self.pickerController = DKImagePickerController()
        //self.pickerController.autoDismissViewController = NO;
        self.pickerController?.showsCancelButton = true
        self.pickerController?.showsEmptyAlbums = true
        self.pickerController?.allowMultipleTypes = false
        self.pickerController?.singleSelect = false;
        self.pickerController?.assetType = .allPhotos
        self.pickerController?.sourceType = .both;
        // -- Init variable --
        self.maxSelected = 5;
        self.sourceType = .both;
        self.singleSelect = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerController?.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.updateAssets(assets: assets)
            guard let didSelectAssets = self.didSelectAssets, assets.count <= 0 else {
                return
            }
            didSelectAssets(assets)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }

        self.pickerController?.didCancel = { () -> Void in
            guard let didCancel = self.didCancel else {
                return
            }
            didCancel()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        self.view.frame = (self.pickerController?.view!.frame)!
        self.view.addSubview((self.pickerController?.view!)!)
    }
    
    func updateAssets(assets: [DKAsset]) {
        print("didSelectAssets")
//        self.assets = assets
//        self.previewView?.reloadData()
//
//        if pickerController.exportsWhenCompleted {
//            for asset in assets {
//                if let error = asset.error {
//                    print("exporterDidEndExporting with error:\(error.localizedDescription)")
//                } else {
//                    print("exporterDidEndExporting:\(asset.localTemporaryPath!)")
//                }
//            }
//        }
//
//        if self.exportManually {
//            DKImageAssetExporter.sharedInstance.exportAssetsAsynchronously(assets: assets, completion: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pickerController?.maxSelectableCount = (self.maxSelected <= 0) ? 5 : self.maxSelected
        self.pickerController?.sourceType = self.sourceType
        self.pickerController?.singleSelect = self.singleSelect

        // -- Remove old select --
        self.pickerController?.deselectAllAssets()
    }
    
//    private init() {
//        super.init()
////        super.init(coder: nil)
//    }

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    
    
//    @property (nonatomic) enum DKImagePickerControllerAssetType assetType;
//    @property (nonatomic) enum DKImagePickerControllerSourceType sourceType;
//    
//    @property (nonatomic) BOOL singleSelect;
//    @property (nonatomic) int maxSelected;
//    @property (nonatomic, copy) void (^ _Nullable didSelectAssets)(NSArray<DKAsset *> * _Nonnull);
//    @property (nonatomic, copy) void (^ _Nullable didCancel)(void);
//    
//    + (instancetype _Nonnull)sharedInstance;

    
    
}

