//
//  DbKeyboardHandler.swift
//  PropzySam
//
//  Created by Dylan Bui on 11/15/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import Foundation
import UIKit

public enum DbKeyboardStatus {
    case KeyboardStatusDidShow
    case KeyboardStatusWillShow
    case KeyboardStatusDidHide
    case KeyboardStatusWillHide
}

class DbKeyboardInfo
{
    private(set) var animationDuration: TimeInterval = 0.0
    private(set) var keyboardFrame: CGRect = CGRect.zero
    private(set) var animationCurve: UIViewAnimationCurve = UIViewAnimationCurve.easeInOut
    private(set) var status: DbKeyboardStatus = DbKeyboardStatus.KeyboardStatusDidHide
    
    convenience init(WithDictionary dictionary: DictionaryType, status: DbKeyboardStatus)
    {
        self.init()
        
        self.keyboardFrame = dictionary[UIKeyboardFrameEndUserInfoKey] as! CGRect
        self.animationDuration = dictionary[UIKeyboardAnimationDurationUserInfoKey] as! Double
        self.animationCurve = UIViewAnimationCurve(rawValue: dictionary[UIKeyboardAnimationCurveUserInfoKey] as! Int)!
        self.status = status
    }
    
}

protocol DbKeyboardHandlerDelegate
{
    func currentKeyboardInfo(info: DbKeyboardInfo) -> Void
}

class DbKeyboardHandler: NSObject
{
    private var delegate: DbKeyboardHandlerDelegate?
    private var block: ((DbKeyboardInfo) -> Void)?
    
    convenience init(WithDelegate delegate: DbKeyboardHandlerDelegate)
    {
        self.init()
        
        self.registerForKeyboardNotification()
        self.delegate = delegate
    }
    
    func listen(block: @escaping ((DbKeyboardInfo) -> Void))
    {
        self.registerForKeyboardNotification()
        self.block = block
    }
    
    deinit {
        self.block = nil
        Notification.remove(self)
    }
    
    private func registerForKeyboardNotification()
    {
        Notification.add(NSNotification.Name.UIKeyboardWillShow, observer: self,
                         selector: #selector(self.keyboardWillShow(_:)), object: nil)
        Notification.add(NSNotification.Name.UIKeyboardDidShow, observer: self,
                         selector: #selector(self.keyboardDidShow(_:)), object: nil)
        Notification.add(NSNotification.Name.UIKeyboardWillHide, observer: self,
                         selector: #selector(self.keyboardWillHide(_:)), object: nil)
        Notification.add(NSNotification.Name.UIKeyboardDidHide, observer: self,
                         selector: #selector(self.keyboardDidHide(_:)), object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification)
    {
        self.provideKeyboardFrameFromNotification(notification, visibility: .KeyboardStatusWillShow)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        self.provideKeyboardFrameFromNotification(notification, visibility: .KeyboardStatusDidShow)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.provideKeyboardFrameFromNotification(notification, visibility: .KeyboardStatusWillHide)
    }
    
    @objc func keyboardDidHide(_ notification: NSNotification)
    {
        self.provideKeyboardFrameFromNotification(notification, visibility: .KeyboardStatusDidHide)
    }
    
    func provideKeyboardFrameFromNotification(_ notification: NSNotification, visibility: DbKeyboardStatus) -> Void
    {
        let model = DbKeyboardInfo.init(WithDictionary: notification.userInfo as! DictionaryType, status: visibility)
        // -- Call Delegate --
        self.delegate?.currentKeyboardInfo(info: model)
        // -- Call Block --
        self.block?(model)
    }
    
}

