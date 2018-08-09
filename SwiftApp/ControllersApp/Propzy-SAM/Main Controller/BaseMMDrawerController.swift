//
//  BaseMMDrawerController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/9/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class BaseMMDrawerController: MMDrawerController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    


}
