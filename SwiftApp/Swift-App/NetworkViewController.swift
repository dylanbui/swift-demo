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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
}
