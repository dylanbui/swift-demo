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
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func initDbControllerData() {
        //self.userSession = [UserSession instance];
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // MARK: - ViewController Circle Live
    // MARK: -

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.appDelegate = (UIApplication.shared.delegate as! AppDelegate)

        // Do any additional setup after loading the view.
        self.verticalOffsetForEmptyDataSet = -150;
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        DbUtils.removeNotification(self)
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

