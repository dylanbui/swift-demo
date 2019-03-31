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
    @IBOutlet weak var txtDetail: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var autoId: String!
    
    private var itemTask: TaskItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "View & Edit"

        // Do any additional setup after loading the view.
//        let itemTask = TaskItem.er.db_fromRealm(with: self.autoId)
//        if itemTask == nil {
//            print("Khong tim thay du lieu")
//        }
        
        guard let item = TaskItem.er.db_fromRealm(with: self.autoId) else {
            self.lblAutoId.text = "Khong tim thay du lieu"
            print("autoId = \(String(describing: self.autoId))")
            return
        }
        
        self.itemTask = item
        self.lblAutoId.text = self.itemTask.autoId
        self.txtTitle.text = self.itemTask.title
        self.txtDetail.text = self.itemTask.detail
    }


    @IBAction func btnSave_Click(_ sender: AnyObject)
    {
        do {
            try self.itemTask.er.edit { (task) in
                task.title = self.txtTitle.text ?? "Luu title"
                task.detail = self.txtDetail.text ?? "Luu detail"
            }
        } catch {
            print("Co loi khi luu")
            return
        }
        
        self.navigationController?.popViewController(animated: true)
        
//        self.itemTask.er.db_edit { (task) in
//            task.title = self.txtTitle.text ?? "Luu title"
//            task.detail = self.txtDetail.text ?? "Luu detail"
//        }
    }
    
    

}
