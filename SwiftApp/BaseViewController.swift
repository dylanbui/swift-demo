//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/20/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit


class BaseViewController: DbViewController
{
    

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
    
//    override func onReturn(params: [String : AnyObject], callerId: Int) {
//        
//        
//    }


}

//extension BaseViewController: DbIReturnDelegate {
//
//    func onReturn(params: [String : AnyObject], callerId: Int) {
//
//
//    }
//
//}

// MARK: - IReturnDelegate
// MARK: -
//extension DbIReturnDelegate where Self: BaseViewController {
//
//    func onReturn(params: [String : AnyObject], callerId: Int) {
//
//
//
//    }
//
//}

