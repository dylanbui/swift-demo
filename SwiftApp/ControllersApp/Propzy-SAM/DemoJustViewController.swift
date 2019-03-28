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
        
        // https://via.placeholder.com/300/09f/fff.png
        // Hinh 16mb
        //http://www.effigis.com/wp-content/uploads/2015/02/Infoterra_Terrasar-X_1_75_m_Radar_2007DEC15_Toronto_EEC-RE_8bits_sub_r_12.jpg
        DbHTTP.get("http://www.effigis.com/wp-content/uploads/2015/02/Infoterra_Terrasar-X_1_75_m_Radar_2007DEC15_Toronto_EEC-RE_8bits_sub_r_12.jpg"
            , asyncProgressHandler: { (progress) in
                // -- Khong chay xu ly nhung mong muon, chi tra ve 1 lan --
                print("progress.type = \(progress.type) ==  progress.percent = \(progress.percent)")
                print("progress.bytesProcessed = \(progress.bytesProcessed) ==  progress.bytesExpectedToProcess = \(progress.bytesExpectedToProcess)")
                print(" ------------------------------ ")
                
        }) { (result) in
            
            if let imageData = result.content {
                DbUtils.dispatchToMainQueue {
                    self.imgTest.image = UIImage(data:imageData, scale:1.0)
                }
            }

        }
        
        
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
        
        DbHTTP.jsonUploadFor(SimpleResponse.self,
                             url: "http://45.117.162.49:8080/file/api/upload",
                             files: ["large_file_2":DbHTTPFile.data("image", UIImagePNGRepresentation(self.imgTest.image!)!, "image/png")],
                             asyncProgressHandler: { (progress) in
                                
        }) { (simpleResponse) in
            // finished
            if simpleResponse.httpResult.ok {
                // finished
                if let jsonData = simpleResponse.httpResult.json as? [String: Any] {
                    print("jsonData.headers = \(jsonData["headers"] ?? "")")
                }
            }
            
        }
        
    }

}
