//
//  UITextField+PasswordField.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

extension UITextField {
    
    func addPasswordField() {
        self.rightViewMode = .whileEditing
        self.isSecureTextEntry = true
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(named: "ic_hide_password.png") , for: .normal)
        button.addTarget(self, action: #selector(self.touchUpInside), for: .touchUpInside)
        self.rightView = button
    }
    
    @objc func touchUpInside() {
        
        let hideShow = self.rightView as? UIButton
        if self.isSecureTextEntry {
            self.isSecureTextEntry = false
            hideShow?.setImage(UIImage(named: "ic_show_password.png") , for: .normal)
        } else {
            self.isSecureTextEntry = true
            hideShow?.setImage(UIImage(named: "ic_hide_password.png") , for: .normal)
        }
        self.becomeFirstResponder()
    }
    
}
