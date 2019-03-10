//
//  EditRealmViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class EditRealmViewController: UIViewController
{
    @IBOutlet weak var lblAutoId: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    
    var autoId: String!
    
    @IBAction func btnSave_Click(_ sender: AnyObject)
    {
        
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
