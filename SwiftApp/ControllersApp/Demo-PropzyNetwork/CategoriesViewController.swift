//
//  CategoriesViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/3/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController
{
    
    @IBOutlet weak var textView: UITextView!
    
    override init() {
        super.init()
        
        let demo:DbNotificationDemo = DbNotificationDemo()        
        DbEventNotification.shared.subscribeEvent(demo)
        print("demo.eventID = \(demo.eventID)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        TestAddNotification("AddNotification")
//        
//        TestAddNotification("aaa")
        // Db.something();
        
    }
    
//    func TestAddNotification() {
//
//        print("CategoriesViewController --- ")
//    }
    

    @IBAction func btn_Click(_ sender: UIButton)
    {
        if (sender.tag == 1) {
            CategoriesApi.getCategories { (arrCat, error) in
                if error != nil {
                    print("Error = \(String(describing: error))")
                    return
                }
                
                for cat: Category in arrCat! {
                    print("\(String(describing: cat.description))")
                }
                
//                print("getCategories: ")
//                print("\(String(describing: arrCat))")
//                self.textView.text = String(describing: arrCat)
            }
        } else {
            CategoriesApi.getCategoriesObject { (category, error) in
                if error != nil {
                    print("Error = \(String(describing: error))")
                    return
                }
                print("category: ")
                print("\(String(describing: category!.description))")
                self.textView.text = String(describing: category?.description)
            }
        }
        
        
//        if (sender.tag == 1) {
//            CategoriesApi.getCategories(completionHandler: { (response, error) in
//                if error != nil {
//                    print("Error = \(String(describing: error))")
//                    return
//                }
//                print("getCategories: ")
////                print("\(String(describing: response?.data))")
//            })
//        } else {
//            CategoriesApi.getCategoriesWithDelegate(delegate: self, callerId: 123)
//        }
    }
    
}


extension CategoriesViewController: IDbWebConnectionDelegate
{
    func onRequestComplete(_ response: DbPropzyResponse, andCallerId callerId: Int) {
        print("Data oday")
//        print("\(String(describing: response.data))")
    }
    
    func onRequestError(_ error: Error, andCallerId callerId: Int) {
        print("Error Delegate : \(error)")
    }
    
}

