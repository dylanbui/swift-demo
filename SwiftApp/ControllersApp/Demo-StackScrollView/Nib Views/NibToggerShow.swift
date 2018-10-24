//
//  NibToggerShow.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/25/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

@IBDesignable
class NibToggerShow: DbLoadableView, DbStackCellType
{
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var viewLabel: UIView!
    
    var highlightedBackgroundColor: UIColor = .init(white: 0.95, alpha: 1)
    var normalBackgroundColor: UIColor = .white
    
    var isShow = true
    
    convenience init() {
        self.init(frame: .zero)
        
//        backgroundColor = .white
//        addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    convenience init(withDefault isDefault: Bool)
    {
        self.init()
    }
    
    
//    override init()
//    {
//        super.init()
//        backgroundColor = .white
//        addTarget(self, action: #selector(tap), for: .touchUpInside)
//    }
    
    @IBAction func tap(_ sender: AnyObject)
    {
        if isShow {
            // -- Hide --
            _hide()
        } else {
            // -- Show --
            _show()
        }
    }
    
//    @objc func tap() {
//
//    }
    
    func _hide() {
        
        isShow = false
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [
                .beginFromCurrentState,
                .allowUserInteraction
            ],
            animations: {
                
                self.viewLabel.snp.updateConstraints({ (update) in
                    update.height.equalTo(0)
                })
                
                //        self.pickerContainerView.easy.layout([
                //          Height(0),
                //        ])
                
//                self.invalidateIntrinsicContentSize()
//                self.layoutIfNeeded()
                self.updateLayout(animated: true)
                self.scrollToSelf(animated: true)
                
        }) { (finish) in
            
        }
        
    }
    
    func _show() {
        
        isShow = true
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [
                .beginFromCurrentState,
                .allowUserInteraction
            ],
            animations: {
                
                self.viewLabel.snp.updateConstraints({ (update) in
//                    update.height.equalToSuperview().offset(-self.viewButton.height)
                    update.height.equalTo(213)
                })
                
                //        NSLayoutConstraint.deactivate(
                //          self.pickerContainerView.easy.layout([
                //            Height(),
                //          ])
                //        )
                
                
//                self.invalidateIntrinsicContentSize()
//                self.layoutIfNeeded()
                self.updateLayout(animated: true)
                self.scrollToSelf(animated: true)
                
        }) { (finish) in
            
        }
        
    }
    
    
}
