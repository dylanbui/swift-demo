//
//  DemoDecimalTextFieldViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DemoDecimalTextFieldViewController: UIViewController
{
    @IBOutlet weak var txtInt: DecimalTextField!
    @IBOutlet weak var txtDecimal: DecimalTextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.txtInt.reloadDataWithType(.Integer)
        self.txtDecimal.reloadDataWithType(.Decimal)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.txtInt.setDecimalValue(2500000)
        self.txtDecimal.setDecimalValue(1700000.23)
        
        // -- Config IQKeyboardManager only this controller --
        // -- Conflicts with txtAutoCompletePlace when you choose row --
        // -- Hide keyboard toolbar --
//        IQKeyboardManager.shared.enableAutoToolbar = false
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
//        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        // -- Remove Conflicts with txtAutoCompletePlace when you choose row --
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }

    @IBAction func click(_ sender: AnyObject)
    {
        print("self.txtInt = \(self.txtInt.getDecimalValue())")
        print("self.txtDecimal = \(self.txtDecimal.getDecimalValue())")
    }
    
}
