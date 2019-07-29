//
//  DemoGgApiViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoGgApiViewController: DbViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let services: DbGoogleServices = DbGoogleServices.init(apiKey: "AIzaSyCXphR-i-FBqqtpR2t-2AYEAmLlY6w2GSE")
        
        services.requestPlaces("50 nhat tao") { (arrPlace) in
            print("arrPlace.count = \(arrPlace.count)")
            
        }

    }



}
