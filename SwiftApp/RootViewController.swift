//
//  RootViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //let vcl = DemoTableViewController()
        let vcl = TaskListViewController()
        
        self.navigationController?.pushViewController(vcl, animated: false)        
    }

    


}
