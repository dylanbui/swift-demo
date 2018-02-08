//
//  FirstViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import Alamofire
import INTULocationManager

public class PropzyResponse: DbResponse {
    
//    public var httpResponse: HTTPURLResponse?
//    public var data: AnyObject?
//    public var originalRequest: NSURLRequest?
//    public var contentType: DbHttpContentType?
//    public var error: Error?
    //    internal(set) public var result: ResultType?
    
    var message: String?
    var result: Bool?
    var code: Int?
    var dictData: [String: AnyObject]?
    
    public required init() {
        super.init()
        self.contentType = DbHttpContentType.JSON
    }
    
    public override func parse(_ responseData: AnyObject?, error: Error?) -> Void {
        super.parse(responseData, error: error)
        if let err = error {
            print("Co loi xay ra \(err)")
            return
        }
        
        guard let responseData = responseData as? [String: AnyObject] else {
            // -- responseData la nil , khong lam gi ca --
            print("responseData == nil")
            return
        }
        
        print("responseData = \(responseData)")
        
        self.message = responseData["message"] as? String
        self.result = responseData["result"] as? Bool
        self.code = responseData["code"] as? Int
        self.dictData = responseData["data"] as? [String: AnyObject]
    }
    
}

class FirstViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationBarHiddenForThisController()
        
        let dictionary = [
            "A" : [1, 2],
            "Z" : [3, 4],
            "D" : [5, 6]
        ]
        
        // let sortedKeys = Array(dictionary.keys).sorted(by: { $0.0 < $1.0 })
        let sortedDict = dictionary.sorted(by: { $0.0 < $1.0 })
        print("sortedDict = \(sortedDict)")
        
        // -- Sort arr with var --
        var sortedKeys = Array(dictionary.keys)
        // sortedKeys.sort()
        sortedKeys.sort(by: >)
        print("sortedKeys = \(sortedKeys)")
        
        let service = ServiceUrl.shared
        service.addChangeModeControl(self.view, selectHandle: { (serviceMode) in
            print("serviceMode after = \(serviceMode.name)")
            print("serviceMode.configData = \(serviceMode.configData)")
            
            print("service.serverMode = \(service.getServiceUrl(ServerKey.API_BASE_URL_KEY))")
            print("service.serverMode = \(service.serverMode.name)")
        })

        
//        let location = LocationManager.sharedInstance()
//
//        // Do any additional setup after loading the view.
//        let locationManager = INTULocationManager.sharedInstance()
//        locationManager.requestLocation(withDesiredAccuracy: .city,
//                                        timeout: 10.0,
//                                        delayUntilAuthorized: true) { (currentLocation, achievedAccuracy, status) in
//                                            if (status == INTULocationStatus.success) {
//                                                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
//                                                // currentLocation contains the device's current location
//                                            }
//                                            else if (status == INTULocationStatus.timedOut) {
//                                                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
//                                                // However, currentLocation contains the best location available (if any) as of right now,
//                                                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
//                                            }
//                                            else {
//                                                // An error occurred, more info is available by looking at the specific status returned.
//                                            }
//        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testNetworking() -> Void {
        
        
        // Alamofire 4
        Alamofire.request("http://vnexpress.net").response { response in // method defaults to `.get`
            debugPrint(response)
        }
        
        let datarequest: DataRequest = Alamofire.request("http://vnexpress.net")
        datarequest.responseJSON { (response) in
            
        }
        
//        https://medium.com/theappspace/alamofire-4-multipart-file-upload-with-swift-3-174df1ef84c1
        
        // User "authentication":
        let parameters = ["user":"Sol", "password":"secret1234"]
        // Image to upload:
        let imageToUploadURL = Bundle.main.url(forResource: "tree", withExtension: "png")
        
        // Server address (replace this with the address of your own server):
        let url = "http://localhost:8888/upload_image.php"
        
        // Use Alamofire to upload the image
             Alamofire.upload(
                     multipartFormData: { multipartFormData in
                             // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                             multipartFormData.append(imageToUploadURL!, withName: "image")
                             for (key, val) in parameters {
                                     multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
                                 }
                     },
                     to: url,
                     encodingCompletion: { encodingResult in
                         switch encodingResult {
                         case .success(let upload, _, _):
                             upload.responseJSON { response in
                                 if let jsonResponse = response.result.value as? [String: Any] {
                                     print(jsonResponse)
                                 }
                             }
                         case .failure(let encodingError):
                             print(encodingError)
                         }
                 }
                 )
        
        // -- su dung MultipartFormData de append du lieu vao --
//        Alamofire.upload(MultipartFormData)
//
//        Alamofire.upload(nil, to: "", withMethod: .post)
//            .uploadProgress { progress in
//                // Called on main dispatch queue by default
//                print("Upload progress: \(progress.fractionCompleted)")
//            }
//            .downloadProgress { progress in
//                // Called on main dispatch queue by default
//                print("Download progress: \(progress.fractionCompleted)")
//            }
//            .responseData { response in
//                debugPrint(response)
//        }
        
        
        let conn = DbWebConnection.sharedInstance()
        
        //let request = DbRequest.init(method: .POST, requestUrl: "http://localhost/i-test/db-post.php")
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
        
        //let response = PropzyResponse.init()
        //response.contentType = DbHttpContentType.JSON
        
        // -- old code --
//        conn.dispatch(Request: request, withResponse: response,
//                      progressHandler: { (process) in
//                        print("Goi thu process")
//        },
//                      successHandler: { (response) in
//                        if let res: PropzyResponse = response as? PropzyResponse {
//                            print("Goi thu successHandler")
//                            print("responseData = \(String(describing: res.dictData))")
//                            self.textView.text = String(describing: res.dictData)
//                        }
//        }) { (res, err) in
//            print("Goi thu loi ne")
//        }
        
        
        conn.dispatch(Request: request) { (response) in
            if let res: PropzyResponse = response as? PropzyResponse {
                print("Goi thu successHandler")
                print("responseData = \(String(describing: res.dictData))")
                self.textView.text = String(describing: res.dictData)
            }
        }
        
//        conn.dispatch(Request: request, successHandler: { (response) in
//                        if let res: PropzyResponse = response as? PropzyResponse {
//                            print("Goi thu successHandler")
//                            print("responseData = \(String(describing: res.dictData))")
//                            self.textView.text = String(describing: res.dictData)
//                        }
//        }) { (res, err) in
//            print("Goi thu loi ne")
//        }
        
        
    }
    
    @IBAction func btnButton_Click(_ sender: UIButton) {
        
        if sender.tag == 5 {
            self.testNetworking()
            return
        }
        
        if sender.tag == 4 {
            let sas = DbSelectorActionSheet(title: "Chon server", dismissButtonTitle: "Chon print", otherButtonTitles: ["Server Dev", "Server Test", "Server Prodution"])

            sas.showIn(self, selectorActionSheetBlock: { (selectedIndex, show) in
                print("da chon : \(selectedIndex)")
            })
            
        }
        
        
        if sender.tag == 1 {
            DbAlertController.alert("Title string", message: "Alert message")
        } else if sender.tag == 2 {
            
            // With individual UIAlertAction objects
            let firstAction = UIAlertAction(title: "First Button", style: .cancel, handler: { (UIAlertAction) -> Void in
                print("firstAction pressed")
            })
//            firstAction.setValue(UIColor.blue, forKey: "titleTextColor")
            
            let secondAction = UIAlertAction(title: "Second Button", style: .destructive, handler: { (UIAlertAction) -> Void in
                print("secondAction pressed")
            })
//            secondAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            DbAlertController.alert("Title", message: "Message", buttons: [firstAction, secondAction], tapBlock: { (alertAction, indexAction) in
                print("DbAlertController === indexAction = \(indexAction)")
            })
            
//            DbAlertController.alert("Title", message: "Message", buttons: ["First", "Second"], tapBlock: { (alertAction, indexAction) in
//                print("indexAction = \(indexAction)")
//            })
        } else if sender.tag == 3 {
            
            // With individual UIAlertAction objects
            let firstButtonAction = UIAlertAction(title: "First Button", style: .default, handler: { (UIAlertAction) -> Void in
                print("First Button pressed")
            })
            firstButtonAction.setValue(UIColor.blue, forKey: "titleTextColor")
            
            let secondButtonAction = UIAlertAction(title: "Second Button", style: .default, handler: { (UIAlertAction) -> Void in
                print("Second Button pressed")
            })
            secondButtonAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            DbAlertController.actionSheet("Title", message: "message", sourceView: self.view, actions: [firstButtonAction, secondButtonAction])
            
            
        }
    }



}
