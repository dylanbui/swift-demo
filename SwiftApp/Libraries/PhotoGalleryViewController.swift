//
//  PhotoGalleryViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import DKImagePickerController

// -- Khong su dung --

class PhotoGalleryViewController: UIViewController {
    
    var assetType: DKImagePickerControllerAssetType = .allPhotos
    var sourceType: DKImagePickerControllerSourceType = .both
    
    var singleSelect: Bool! = false
    var maxSelected: Int! = 5
    
    var didSelectAssets: (([DKAsset]) -> Void)?
    var didCancel: (() -> Void)?
    
    static let sharedInstance = PhotoGalleryViewController()
    
    private let pickerController = DKImagePickerController()
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initPrivate() // Tao bang code chay vao day
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
//        self.pickerController?.didSelectAssets = { (assets: [DKAsset]) in
//            print("didSelectAssets")
//            print(assets)
//        }

        
        self.pickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            print("didSelectAssets")
            
            if assets.count <= 0 {
                return
            }
            
            guard let didSelectAssets = self.didSelectAssets else {
                return
            }
            didSelectAssets(assets)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }

        self.pickerController.didCancel = { () -> Void in
            
            print("didCancel")
            
            guard let didCancel = self.didCancel else {
                return
            }
            didCancel()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }

        self.pickerController.view.translatesAutoresizingMaskIntoConstraints = true
        self.view.frame = self.pickerController.view.frame
        self.view.addSubview(self.pickerController.view)
        

        
//        self.present(self.pickerController!, animated: false) {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pickerController.maxSelectableCount = (self.maxSelected <= 0) ? 5 : self.maxSelected
        self.pickerController.sourceType = self.sourceType
        self.pickerController.singleSelect = self.singleSelect

        // -- Remove old select --
        self.pickerController.deselectAllAssets()
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

