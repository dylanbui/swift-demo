//
//  SecondViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import DKImagePickerController

class SecondViewController: BaseViewController {

    @IBOutlet weak var imgvAvatar: UIImageView!
    @IBOutlet weak var txtNumberPad: DecimalTextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        self.txtPassword.addPasswordField()
        
        txtNumberPad.reloadDataWithType(.Decimal)
        txtNumberPad.setDecimalValue(1221253.14)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPhoto_Click(_ sender: Any) {
        
//        let pickerController = DKImagePickerController()
//
//        pickerController.showsCancelButton = true
//        pickerController.showsEmptyAlbums = true
//        pickerController.allowMultipleTypes = false
//        pickerController.singleSelect = false;
//        pickerController.assetType = .allPhotos
//        pickerController.sourceType = .both;
//
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            print("didSelectAssets")
//            print(assets)
//        }
//
//        self.present(pickerController, animated: true) {}

        
        let vclPhoto: PhotoGalleryViewController = PhotoGalleryViewController.sharedInstance
        vclPhoto.sourceType = .photo

        vclPhoto.didSelectAssets = { (assets: [DKAsset]) -> Void in
            print("didSelectAssets")
            print(assets)
        }

        vclPhoto.didCancel = { () -> Void in
            print("didCancel")
        }
        
        DbUtils.getTopViewController()?.present(vclPhoto, animated: true
            , completion: {
                
        })

//        self.present(vclPhoto, animated: true) {
//
//        }
        
//        PhotoGalleryViewController *vclGallery = [PhotoGalleryViewController sharedInstance];
//        vclGallery.sourceType = DKImagePickerControllerSourceTypePhoto;
//        [vclGallery setDidSelectAssets:^(NSArray<DKAsset *> * _Nonnull assets) {
//            for(DKAsset *asset in assets) {
//            [self addImageToTableCcell:asset];
//            }
//            }];
//        [self presentViewController:vclGallery animated:YES completion:nil];
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
