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

    
    @IBAction func btnUploadFiles_Click(_ sender: Any) {
        
        let image_1 = UIImage(named: "demo_5.png")!
        var uploadData_1 = DbUploadData()
        uploadData_1.fileId = "upload_file"
        
        // -- Use for PHP Server --
        uploadData_1.fileName = "avatar.jpg"
        uploadData_1.mimeType = "image/jpeg"
        uploadData_1.fileData = UIImageJPEGRepresentation(image_1, 1.0);
        
        let image_2 = UIImage(named: "demo_6_line.png")!
        var uploadData_2 = DbUploadData()
        uploadData_2.fileId = "upload_file"
        
        // -- Use for PHP Server --
        uploadData_2.fileName = "avatar.jpg"
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

        
//        [service upload:@"http://localhost/i-test/db-upload.php"
//            withParameters:@{@"type": @"avatar"}
//            andUploadData:uploadData
//            progress:^(NSProgress *uploadProgress) {
//
//            }
//            completionHandler:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
//            if (error) {
//            NSLog(@"[error description] = %@", [error description]);
//            return;
//            }
//
//            NSLog(@"[responseDict description] = %@", [responseDict description]);
//
//            // -- Convert data to ResponseObject --
//            //      DbResponseObject *responseObject = [[DbResponseObject alloc] initWithDictionary_om:responseDict];
//            //      completion(response, responseObject, error);
//            }];
        
        
    }
}
