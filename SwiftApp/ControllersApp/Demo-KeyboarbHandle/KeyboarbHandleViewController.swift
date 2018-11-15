//
//  KeyboarbHandleViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 11/15/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

//private var DbKeyboardHandlerParams: Void?

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct DbKeyboardHandlerParams {
        static var keyboardHandler = "UIView_keyboardHandler"
    }

    
    private var keyboardHandler: DbKeyboardHandler {
        get {
            var keyboardHandler = objc_getAssociatedObject(self, &DbKeyboardHandlerParams.keyboardHandler) as? DbKeyboardHandler
            if keyboardHandler == nil {
                keyboardHandler = DbKeyboardHandler()
                objc_setAssociatedObject(self, &DbKeyboardHandlerParams.keyboardHandler, keyboardHandler, .OBJC_ASSOCIATION_RETAIN)
            }
            return keyboardHandler!
        }
    }
    
    func db_anchorViewToBottomViewWithKeyboard() -> Void
    {
        self.y = CGFloat(Db.screenHeight()) - self.height - DbUtils.safeAreaBottomPadding()
        
        // -- Co the define bien o day --
//        var keyboardHandler = objc_getAssociatedObject(self, &DbKeyboardHandlerParams) as? DbKeyboardHandler
//        if keyboardHandler == nil {
//            keyboardHandler = DbKeyboardHandler()
//            objc_setAssociatedObject(self, &DbKeyboardHandlerParams, keyboardHandler, .OBJC_ASSOCIATION_RETAIN)
//        }
        
        keyboardHandler.listen { (keyboardInfo) in
            print("keyboardInfo.keyboardFrame = \(String(describing: keyboardInfo.keyboardFrame))")
            print("keyboardInfo.keyboardFrame = \(String(describing: keyboardInfo.status))")
            
            // -- Move view control --
            //var inputViewFrame: CGRect = self.viewButtonControl.frame
            if keyboardInfo.status == .KeyboardStatusWillShow {
                if self.tag == 0 {
                    self.y = keyboardInfo.keyboardFrame.origin.y - self.height
                    self.tag = 1010
                }
            } else if keyboardInfo.status == .KeyboardStatusWillHide {
                if self.tag == 1010 {
                    self.y = keyboardInfo.keyboardFrame.size.height + self.y - DbUtils.safeAreaBottomPadding()
                    self.tag = 0
                }
            }
            
        }
    }
}

class KeyboarbHandleViewController: UIViewController
{

    @IBOutlet weak var txtTest: UITextField!
    
    let keyboardHandler = DbKeyboardHandler()
    let viewBar = KBBottomBarView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        viewBar.frame = CGRect(0, self.view.height - 100, self.view.width, 100)
        print("viewBar.frame = \(String(describing: viewBar.frame))")
        self.view.addSubview(viewBar)
        //viewBar.frame = CGRect(0, Db.screenHeight() - 100 - Int(DbUtils.safeAreaBottomPadding()), Db.screenWidth(), 100)
        // viewBar.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        viewBar.frame = CGRect(0, 0, Db.screenWidth(), 100)
        viewBar.db_anchorViewToBottomViewWithKeyboard()
        
//        keyboardHandler.listen { (keyboardInfo) in
//            print("keyboardInfo.keyboardFrame = \(String(describing: keyboardInfo.keyboardFrame))")
//            print("keyboardInfo.keyboardFrame = \(String(describing: keyboardInfo.status))")
//
//            // -- Move view control --
//            //var inputViewFrame: CGRect = self.viewButtonControl.frame
//            if keyboardInfo.status == .KeyboardStatusWillShow {
//                if self.viewBar.tag == 0 {
//                    //inputViewFrame.origin.y -= keyboardInfo.keyboardFrame.size.height
//                    //                inputViewFrame.origin.y = keyboardInfo.keyboardFrame.origin.y - inputViewFrame.size.height
//                    //self.viewButtonControl.frame = inputViewFrame;
//                    self.viewBar.y = keyboardInfo.keyboardFrame.origin.y - self.viewBar.height
//                    self.viewBar.tag = 100
//                }
//            } else if keyboardInfo.status == .KeyboardStatusWillHide {
//                if self.viewBar.tag == 100 {
//                    //inputViewFrame.origin.y += keyboardInfo.keyboardFrame.size.height
//
//                    //self.viewButtonControl.frame = inputViewFrame;
//                    self.viewBar.y = keyboardInfo.keyboardFrame.size.height + self.viewBar.y - DbUtils.safeAreaBottomPadding()
//                    self.viewBar.tag = 0
//                }
//            }
//
//        }
        
        
        
        
    }



}
