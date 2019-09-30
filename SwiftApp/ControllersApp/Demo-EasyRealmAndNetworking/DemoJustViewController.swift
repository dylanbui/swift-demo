//
//  DemoJustViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/27/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoJustViewController: BaseViewController
{
    @IBOutlet weak var imgTest: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func btnPost_Click(_ sender: AnyObject)
    {
        // Post with "Content-Type" = "application/x-www-form-urlencoded";
        DbHTTP.post("http://httpbin.org/post", data:["firstName":"Barry","lastName":"Allen"]
            , asyncProgressHandler: { (progress) in
                print("progress.type = \(progress.type) ==  progress.percent = \(progress.percent)")
        }) { (result) in

            if let jsonData = result.json as? [String: Any] {
                print("jsonData.description = \(jsonData.description)")
            }
        }
        
        // Post with "Content-Type" = "application/json"
//        DbHTTP.post("http://httpbin.org/post", json:["firstName":"Barry","lastName":"Allen"]
//            , asyncProgressHandler: { (progress) in
//                print("progress.type = \(progress.type) ==  progress.percent = \(progress.percent)")
//        }) { (result) in
//
//            if let jsonData = result.json as? [String: Any] {
//                print("jsonData.description = \(jsonData.description)")
//            }
//        }
    }

    @IBAction func btnGet_Click(_ sender: AnyObject)
    {
        // Post with "Content-Type" = "application/x-www-form-urlencoded";
        // Get method chi duoc se dung 1 trong 2 loai : params hay url params
//        DbHTTP.get("http://httpbin.org/get?page=3", params:["mycontent": 1000]
//        //DbHTTP.get("http://httpbin.org/get", params:["page": 3]
//            , headers: ["Content-Type": "application/json"]
//            , asyncProgressHandler: { (progress) in
//                print("progress.type = \(progress.type) ==  progress.percent = \(progress.percent)")
//        }) { (result) in
//
//            if let jsonData = result.json as? [String: Any] {
//                print("jsonData.description = \(jsonData.description)")
//            }
//
//        }
        
        self.imgTest.db_download(from: URL.init(string: "https://via.placeholder.com/300/09f/fff.png")!,
                                 placeholder: UIImage(named: "Georgia1")
        ) { (image) in
            print("Da load xong anh")
        }
        
//        // https://via.placeholder.com/300/09f/fff.png
//        // Hinh 16mb
//        //http://www.effigis.com/wp-content/uploads/2015/02/Infoterra_Terrasar-X_1_75_m_Radar_2007DEC15_Toronto_EEC-RE_8bits_sub_r_12.jpg
//        DbHTTP.get("http://www.effigis.com/wp-content/uploads/2015/02/Infoterra_Terrasar-X_1_75_m_Radar_2007DEC15_Toronto_EEC-RE_8bits_sub_r_12.jpg"
//            , asyncProgressHandler: { (progress) in
//                // -- Khong chay xu ly nhung mong muon, chi tra ve 1 lan --
//                print("progress.type = \(progress.type) ==  progress.percent = \(progress.percent)")
//                print("progress.bytesProcessed = \(progress.bytesProcessed) ==  progress.bytesExpectedToProcess = \(progress.bytesExpectedToProcess)")
//                print(" ------------------------------ ")
//
//        }) { (result) in
//
//            if let imageData = result.content {
//                DbUtils.dispatchToMainQueue {
//                    self.imgTest.image = UIImage(data:imageData, scale:1.0)
//                }
//            }
//
//        }
        
        
    }

    @IBAction func btnUpload_Click(_ sender: AnyObject)
    {
//        DbHTTP.post(
//            "http://httpbin.org/post",
//            files:["large_file_1":DbHTTPFile.text("or", "pretend this is a large file", nil),
//                   "large_file_2":DbHTTPFile.data("test data", UIImagePNGRepresentation(self.imgTest.image!)!, "image/png")],
//            asyncProgressHandler: { progress in
//                if progress.type == .upload {
//                    print("progress.type = \(progress.type) ==  progress.percent = \(progress.percent)")
//                    print("progress.bytesProcessed = \(progress.bytesProcessed) ==  progress.bytesExpectedToProcess = \(progress.bytesExpectedToProcess)")
//                    print(" ------------------------------ ")
//                }
//        }
//        ) { result in
//            // finished
//            if let jsonData = result.json as? [String: Any] {
//                print("jsonData.headers = \(jsonData["headers"] ?? "")")
//
//            }
//        }
        
        let url = "http://cdn.propzy.vn:9090/file/api/upload"
        let uploadData = ["file": DbHTTPFile.data("survey.png", UIImagePNGRepresentation(self.imgTest.image!)!, "image/png")]
        
//        let url = "http://45.117.162.49:8080/file/api/upload"
//        let uploadData = ["large_file_2":DbHTTPFile.data("image", UIImagePNGRepresentation(self.imgTest.image!)!, "image/png")]
        
        DbHTTP.jsonUploadFor(SimpleResponse.self,
                             url: url,
                             data: ["type": "survey"], // Post with Dictionary Data
                             files: uploadData,
                             asyncProgressHandler: { (progress) in
                                print("progress.percent = \(String(format:"%.0f%%", (progress.percent*100)))")
                                
        }) { (simpleResponse) in
            // finished
            if simpleResponse.httpResult.ok {
                // finished
                if let jsonData = simpleResponse.httpResult.json as? [String: Any] {
                    print("jsonData = \(jsonData)")
                    /*
                     jsonData = ["result": 1, "code": 200, "message": Thao tác thành công, "data": {
                     "file_name" = "survey/large/2019/08/15/survey_2f591c24d046de8644816658af4913d5b683c855585f1880b9f188e08c0d9f27.jpg";
                     link = "https://cdn.propzy.vn/survey/large/2019/08/15/survey_2f591c24d046de8644816658af4913d5b683c855585f1880b9f188e08c0d9f27.jpg";
                     }]
                     */
                }
            }
            
        }
        
    }
    
    @IBAction func btnGetGoogleData_Click(_ sender: Any)
    {
        // -- Goi dong bo - synchronous --
//        let httpResult = DbHTTP.get("https://maps.googleapis.com/maps/api/geocode/json?latlng=10.795785,106.675309&sensor=true&key=AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg")
//
//        let ggResponse = MyGoogleResponse.init(result: httpResult)
//        ggResponse.parseResult()
//
//        if !ggResponse.httpResult.ok {
//            print("Loi roi ban \(ggResponse.httpResult.reason)")
//            return
//        }
//
//        print("addressComponents = \(String(describing: ggResponse.addressComponents))")
//        print("formattedAddress = \(String(describing: ggResponse.formattedAddress))")
//        print("geometry = \(String(describing: ggResponse.geometry))")
        
        // -- Goi bat dong bo - asynchronous --
        DbHTTP.jsonGetFor(MyGoogleResponse.self, url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=10.795785,106.675309&sensor=true&key=AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg") { (ggResponse) in

            if !ggResponse.httpResult.ok {
                print("Loi roi ban \(ggResponse.httpResult.reason)")
                return
            }

            print("addressComponents = \(String(describing: ggResponse.addressComponents))")
            print("formattedAddress = \(String(describing: ggResponse.formattedAddress))")
            print("geometry = \(String(describing: ggResponse.geometry))")
        }
        
        // -- Code cu --
//        let _: GoogleResponse? = DbHttp.get(Url: "https://maps.googleapis.com/maps/api/geocode/json?latlng=10.795785,106.675309&sensor=true&key=AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg") { (response) in
//
//            if let err = response.error {
//                print("Loi roi ban \(err)")
//                return
//            }
//
//            guard let googleRes = response as? GoogleResponse else {
//                print("GoogleResponse = nil")
//                return
//            }
//
//            print("addressComponents = \(String(describing: googleRes.addressComponents))")
//            print("formattedAddress = \(String(describing: googleRes.formattedAddress))")
//            print("geometry = \(String(describing: googleRes.geometry))")
//        }
    }
    
    

}
