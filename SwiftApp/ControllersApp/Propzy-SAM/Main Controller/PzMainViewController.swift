//
//  PzMainViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/8/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class PzMainViewController: DbViewController
{
    @IBOutlet weak var btnLeftMenu: UIButton!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "PzMainViewController"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLeftMenu_Click(_ sender: Any)
    {
        self.mm_drawerController.toggle(.left, animated: true) { (success) in
            print("da mo left menu")
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
