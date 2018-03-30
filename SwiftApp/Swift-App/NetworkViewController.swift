//
//  NetworkViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/22/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class NetworkViewController: BaseViewController {
    
    @IBOutlet weak var btnUploadFiles: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let img_0 = self.view.viewWithTag(5555) as! UIImageView
        img_0.imageFontAwesomeIcon("calendar-alt")
        
        let img_1 = self.view.viewWithTag(1111) as! UIImageView
        img_1.imageFontAwesomeIcon("smile-o")
        
        let img_2 = self.view.viewWithTag(2222) as! UIImageView
        img_2.image = UIImage.fontAwesomeIcon("trash", iconColor: UIColor.blue)
        print("\(String(describing: img_2.image?.size))")
        //img_2.imageFontAwesomeIcon("trash", iconColor: UIColor.yellow)
        
        let img_3 = self.view.viewWithTag(3333) as! UIImageView
        img_3.imageFontAwesomeIcon("tree", iconColor: UIColor.blue)
        
        let img_4 = self.view.viewWithTag(4444) as! UIImageView
        img_4.imageFontAwesomeIcon("suitcase", iconColor: UIColor.green)
        
        let button_1 = self.view.viewWithTag(6666) as! UIButton
        button_1.set(image: UIImage.fontAwesomeIcon("eject"), title: "Shout", titlePosition: .left, additionalSpacing: 40.0, state: .normal)
        
        let txt_1 = self.view.viewWithTag(123456) as! DbTextField
        txt_1.leftImage = UIImage.fontAwesomeIcon("trash", iconColor: UIColor.blue)
        
        
        
//        button.set(image: #imageLiteral(resourceName: "shout"), title: "Shout", titlePosition: .top, additionalSpacing: 30.0, state: .normal)
//        thirdButton.set(image: #imageLiteral(resourceName: "shout"), title: "This is an XIB button", titlePosition: .bottom, additionalSpacing: 10.0, state: .normal)
//
//        let secondButton = UIButton(type: .system)
//        secondButton.frame = CGRect(x: 0, y: 50, width: 100, height: 400)
//        secondButton.center = CGPoint(x: view.frame.size.width/2, y: 50)
//        let attr = [
//            NSAttributedStringKey.font:UIFont(name:"Helvetica", size: 14)!,
//            NSAttributedStringKey.foregroundColor: UIColor.green
//        ]
//        let title = NSAttributedString(string: "Settings", attributes: attr)
//        secondButton.tintColor = UIColor.red
//        secondButton.set(image: UIImage(named: "settings"), attributedTitle: title, at: .left, width: 0.0, state: .normal)
//        view.addSubview(secondButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func btnUploadFiles_Click(_ sender: Any)
    {
        let image_1 = UIImage(named: "demo_5.png")!
        var uploadData_1 = DbUploadData()
        uploadData_1.fileId = "upload_file"
        
        // -- Use for PHP Server --
        uploadData_1.fileName = "avatar_1.jpg"
        uploadData_1.mimeType = "image/jpeg"
        uploadData_1.fileData = UIImageJPEGRepresentation(image_1, 1.0);
        
        let image_2 = UIImage(named: "demo_6_line.png")!
        var uploadData_2 = DbUploadData()
        uploadData_2.fileId = "upload_file"
        
        // -- Use for PHP Server --
        uploadData_2.fileName = "avatar_2.jpg"
        uploadData_2.mimeType = "image/jpeg"
        uploadData_2.fileData = UIImageJPEGRepresentation(image_2, 1.0);
        
//        let requestUpload = DbUploadRequest(requestUrl: "http://localhost/i-test/db-upload.php", uploadData: uploadData)
//        requestUpload.query = ["type": "avatar"]

//        let requestUpload = DbUploadRequestFor<PropzyResponse>(requestUrl: "http://localhost/i-test/db-upload.php", uploadData: uploadData)
        let requestUpload = DbUploadRequestFor<PropzyResponse>()
        requestUpload.requestUrl = "http://localhost/i-test/db-upload.php"
        requestUpload.arrUploadData = [uploadData_1, uploadData_2]
        requestUpload.query = ["type": "avatar"]
        
        DbHttp.upload(UploadRequest: requestUpload, processHandler: { (progress) in
            print("progress.fractionCompleted" + String(Float(progress.fractionCompleted)))
        }) { (response) in
            print("Upload => successHandler")
            print("responseData = \(String(describing: response.rawData))")
            // debugPrint(response)
            if let res: PropzyResponse = response as? PropzyResponse {
                print("PropzyResponse = \(String(describing: res.dictData))")
            }
        }
        
    }
    
    @IBAction func btnPostDataSync_Click(_ sender: Any)
    {
        //let request = DbRequest.init(method: .POST, requestUrl: "http://localhost/i-test/db-post.php")
        let request = DbRequestFor<PropzyResponse>.init(method: .POST, requestUrl: "http://localhost/i-test/db-post.php")
        
        let params: [String: String]! = ["buildingId" : "12345", "buildingName" : "194 Toa nha LON Building"]
        request.query = params
        
        print("bat dau goi : dispatchSync")
        //DbHttp.dispatchSync(Request: request)
        let response:PropzyResponse = DbHttp.dispatchSync(Request: request) as! PropzyResponse
        print("response.message = \(response.message!)")
        print("responseData = \(String(describing: response.dictData!))")
        print("DA GOI XONG : dispatchSync")
        
    }
    
    
    @IBAction func btnPostData_Click(_ sender: Any)
    {
        let request = DbRequestFor<PropzyResponse>.init(method: .POST, requestUrl: "http://localhost/i-test/db-post.php")
        //        request.method = DbHttpMethod.POST
        //        request.contentType = DbHttpContentType.JSON
        //
        //        var arrHeaders: [DbHttpHeader] = []
        //        arrHeaders.append(DbHttpHeader.Custom("Accept-Encoding", "gzip"))
        //        arrHeaders.append(DbHttpHeader.Custom("Accept-Language", "vi-VN"))
        //        request.headers = arrHeaders
        
        let params: [String: String]! = ["buildingId" : "2", "buildingName" : "194 Golden Building"]
        request.query = params
        
        DbHttp.dispatch(Request: request) { (response) in
            if let res: PropzyResponse = response as? PropzyResponse {
                print("Goi thu successHandler")
                print("responseData = \(String(describing: res.dictData))")
            }
        }
    }
    
    @IBAction func btnGetGoogleData_Click(_ sender: Any)
    {
        let _: GoogleResponse? = DbHttp.get(Url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=10.795785,106.675309&sensor=true&key=AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg") { (response) in
            
            if let err = response.error {
                print("Loi roi ban \(err)")
                return
            }
            
            guard let googleRes = response as? GoogleResponse else {
                print("GoogleResponse = nil")
                return
            }

            print("addressComponents = \(String(describing: googleRes.addressComponents))")
            print("formattedAddress = \(String(describing: googleRes.formattedAddress))")
            print("geometry = \(String(describing: googleRes.geometry))")
        }
    }
}
