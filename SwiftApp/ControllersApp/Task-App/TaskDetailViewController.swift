//
//  TaskDetailViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/20/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class TaskDetailViewController: BaseViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var btnTest: DbActionView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblName.text = self.transferParams["name"] as? String
        self.lblDate.text = self.transferParams["datetime"] as? String
        self.lblDesc.text = self.transferParams["title"] as? String
        
        self.btnTest.isEnabled = false
        
    }
    
    @IBAction func btnDone_Click(_ sender: UIButton)
    {
        self.navigationController!.popViewController(animated: true)
        
    }
    
    @IBAction func btnTest_Click(_ sender: DbActionView)
    {
        print("btnTest_Click")
    }
}
