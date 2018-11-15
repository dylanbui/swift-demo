//
//  TaskUpdateViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/20/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class TaskUpdateViewController: BaseViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDatetime: UITextField!
    @IBOutlet weak var txtvDesc: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        self.txtName.text = self.transferParams["name"] as? String
        self.txtDatetime.text = self.transferParams["datetime"] as? String
        self.txtvDesc.text = self.transferParams["title"] as? String
    }


    @IBAction func btnSave_Click(_ sender: UIButton)
    {
        let params: DictionaryType = ["name": self.txtName.text ?? "",
                                      "datetime": self.txtDatetime.text ?? "",
                                      "title": self.txtvDesc.text ?? ""]
        self.returnParamsDelegate.onReturn(Owner: self, callerId: 1, params: params, error: nil)
        self.btnCance_Click(nil)
    }
    
    @IBAction func btnCance_Click(_ sender: UIButton!)
    {
        //self.navigationController?.popViewController(animated: true)
        self.navigationController!.popViewController(animated: true)
    }
}
