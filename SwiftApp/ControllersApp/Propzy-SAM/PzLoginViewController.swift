//
//  PzLoginViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class PzLoginViewController: DbViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin_Click(_ sender: Any)
    {
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
//        }
        
        // -- Run good --
        CategoryApi.getCategory { (arrCat, pzResponse) in
            for cat: Category in arrCat ?? [] {
                print("Cat description \(cat.description)")
            }
        }
    }
    
    @IBAction func btnRegister_Click(_ sender: Any)
    {
        
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
