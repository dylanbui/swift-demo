//
//  RootViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //let vcl = DemoTableViewController()
        let vcl = TaskListViewController()
        
        self.navigationController?.pushViewController(vcl, animated: false)
        
        // weak var weakSelf = self
        Utils.dispatchToBgQueue {
            print("Bg : Say helooo delay")
            self.delayWithSeconds(5, completion: {
                for index in 1...100 {
                    if index % 10 == 0 {
                        print("index = \(index)")
                    }
                }
            })
        }
        
        Utils.dispatchToMainQueue { 
            print("Main : Say helooo")
            for index in 1...100 {
                if index % 10 == 0 {
                    print("Main = index = \(index)")
                }
            }

        }
        
        
        
    }

    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }



    
}
