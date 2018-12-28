//
//  KBScrollViewViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 11/16/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class KBScrollViewViewController: BaseViewController {
    
    @IBOutlet weak var viewBottom: UIView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // self.viewBottom.db_anchorViewToBottomViewWithKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 59
        
        self.viewBottom.db_anchorViewToBottomViewWithKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
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
