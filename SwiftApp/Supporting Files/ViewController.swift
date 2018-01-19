//
//  ViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let configuration : URLSessionConfiguration = URLSessionConfiguration.default;
        
        let manager : AFURLSessionManager =
            AFURLSessionManager.init(sessionConfiguration: configuration);
        
        let url : URL = URL.init(fileURLWithPath: "http://headers.jsontest.com");
        
        let request :URLRequest = URLRequest.init(url: url);
        
        let _ = URLSessionDataTask.init();
        
        let dataTask : URLSessionDataTask = manager.dataTask(with: request) { (response, responseObj, error) in
            
            if (error != nil) {
                print("Loi la cai gi : \(error.debugDescription)")
                
            } else {
                print("Khong co loi : \(String(describing: response)) - \(String(describing: responseObj))")
            }
        }
        
        dataTask.resume()
        
//        let manager = AFHTTPRequestOperationManager()
//        manager.GET(
//            "http://headers.jsontest.com",
//            parameters: nil,
//            success: { (operation: AFHTTPRequestOperation!,
//                responseObject: AnyObject!) in
//                println("JSON: " + responseObject.description)
//        },
//            failure: { (operation: AFHTTPRequestOperation!,
//                error: NSError!) in
//                println("Error: " + error.localizedDescription)
//        }
//        )
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func dispatchToMainQueue(_ block: dispatch_block_t) -> Void {
//        dispatch_async(dispatch_get_main_queue(), block);
//    }


//    + (void)dispatchToMainQueue:(dispatch_block_t)block
//    {
//    dispatch_async(dispatch_get_main_queue(), block);
//    }

    
}

