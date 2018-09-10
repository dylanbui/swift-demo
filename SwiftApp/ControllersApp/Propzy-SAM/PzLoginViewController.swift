//
//  PzLoginViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

//class PzLoginViewController: DbViewController {
class PzLoginViewController: UIViewController
{

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // -- mac dinh an bar --
        //self.navigationBarHiddenForThisController()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin_Click(_ sender: Any)
    {
        let pickerController = DbMediaPickerController()
        pickerController.pickerType = .avatarCircle
//        pickerController.pickerType = .all
        
        pickerController.didSelectAssets = { (assets: [DbAsset]) in
            print("didSelectAssets")
            print(assets)
        }
        
        pickerController.didCropAvatarToImage = { (image: UIImage, cropRect: CGRect, angle: Int) -> Void in
//            self.imgvAvatar.image = image
            print("\(cropRect)")
        }
        
        pickerController.didCropAvatarToCircularImage = { (image: UIImage, cropRect: CGRect, angle: Int) -> Void in
            //            self.imgvAvatar.image = image
            print("\(cropRect)")
        }

        
        pickerController.didCancel = { () -> Void in
            print("didCancel")
        }
        
//        self.present(pickerController, animated: true)
        
        pickerController.present(withController: self)
        
        
//        MediaGallery.sharedInstance.showAvatar(with: self)
        
//        let request = DbRequestFor<PropzyResponse>.init(method: .POST, requestUrl: "http://45.117.162.49:8080/diy/api/user/signIn")
//
//        let params: [String: String]! = ["osName": "iOs",
//                                         "versionName": "9.0",
//                                         "deviceToken": "notuser659ef7634ff919e6a866aab41b7bc60039339ac8cd85b90c888fb",
//                                         "email": "0901019992",
//                                         "deviceName": "Simulator",
//                                         "password": "123", "type": "normal"]
//        request.query = params
//
//        DbHttp.dispatch(Request: request) { (response) in
//            if let res: PropzyResponse = response as? PropzyResponse {
//                print("Goi thu successHandler")
//                print("responseData = \(String(describing: res.dictData))")
//            }
//        }
                
        // -- Run good --
//        let phone = "0901019992"
//        let pass = "123"
//        UserApi.doLogin(["email" : phone, "password" : pass, "type" : "normal", "deviceToken" : UserSession.shared.getDevicePushNotificationToken()]) { (response) in
//
//            print("DA_LOGIN_THANH_CONG")
//            Notification.post("DA_LOGIN_THANH_CONG", object: self)
//
//        }
        
        // -- Run good --
//        CategoryApi.getCategory { (arrCat, pzResponse) in
//            for cat: Category in arrCat ?? [] {
//                print("Cat description \(cat.description)")
//            }
//        }
    }
    
    @IBAction func btnRegister_Click(_ sender: Any)
    {
        let pickerController = DbMediaPickerController()
        pickerController.pickerType = .avatarCircle
        
        pickerController.didSelectAssets = { (assets: [DbAsset]) in
            print("didSelectAssets")
            print(assets)
        }
        
        pickerController.didCropAvatarToImage = { (image: UIImage, cropRect: CGRect, angle: Int) -> Void in
            //            self.imgvAvatar.image = image
            print("\(cropRect)")
        }
        
        pickerController.didCropAvatarToCircularImage = { (image: UIImage, cropRect: CGRect, angle: Int) -> Void in
            //            self.imgvAvatar.image = image
            print("\(cropRect)")
        }
        
        
        pickerController.didCancel = { () -> Void in
            print("didCancel")
        }

        pickerController.present(withController: self, imageAvatar: UIImage.init(named: "main_gate")!)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnRealm_Click(_ sender: AnyObject)
    {
//        DbScreenLoading.show()
//        CountryUnitApi.synchronizeUnitDataWithServer {
//            DbScreenLoading.hide()
//        }
        
        // Cach 1
//        let obj: CityUnit = CityUnit().getObjectById(1) as! CityUnit
//        print("obj.cityName = \(obj.cityName)")
        // Cach 2
//        guard let obj: CityUnit = CityUnit().getObjectById(1) as? CityUnit else {
//            print("Khong tim thay du lieu")
//            return
//        }

        guard let obj: CityUnit = CityUnit().getObjectByCondition("cityId = 1") else {
            print("Khong tim thay du lieu")
            return
        }
        print("obj.cityName = \(obj.description)")
        

        print("-----------------------------")
        let arrObj = DistrictUnit().getAll(fromClass: DistrictUnit.self)
        for district: DistrictUnit in arrObj {
            print("districtName = \(district.districtName)")
        }
        
        
        
        
    }
    
    
    

}
