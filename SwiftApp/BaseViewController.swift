//
//  BaseViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/20/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

protocol IReturnParamsDelegate {
    func onReturn(params: [String:AnyObject], callerId: Int);
}

class BaseViewController: UIViewController, IReturnParamsDelegate
{
    
    var stranferParams: [String:AnyObject]!
    var returnParamsDelegate: IReturnParamsDelegate!

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
    
    // MARK: - IReturnParamsDelegate
    // MARK: -
    func onReturn(params: [String : AnyObject], callerId: Int) {
        
    }

}
