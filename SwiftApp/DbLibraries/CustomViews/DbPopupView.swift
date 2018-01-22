//
//  DbPopupView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/22/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

class DbPopupView: DbLoadablePopupView {
    
    @IBOutlet weak var vwContent: UIView!
    var isModal: Bool = true
    
    private var containerViewController: UIViewController?
    private var vwBg: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBgViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBgViews()
    }
    
//    convenience init(withHandleViewAction handle: @escaping DbHandleViewAction) {
////        self.init(coder: nil)
//        self.handleViewAction = handle
//    }
    
    private func setupBgViews() {
        let screen = UIScreen.main
        let frame = CGRect(x: screen.bounds.origin.x,
                           y: screen.bounds.origin.y,
                           width: screen.bounds.size.width,
                           height: screen.bounds.size.height + 50)
        
        self.vwBg = UIView.init(frame: frame)
        
        let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .dark))
        visualEffectView.frame = self.vwBg!.bounds
        visualEffectView.alpha = 1.0
        
        self.vwBg?.addSubview(visualEffectView)
        self.vwBg?.alpha = 1.0
        
        let view = self.vwContent.superview!
        view.addSubview(self.vwBg!)
        view.sendSubview(toBack: self.vwBg!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.vwContent.layer.masksToBounds = true
        self.vwContent.layer.cornerRadius = 6.0
        
        if self.isModal {
            let tap = UITapGestureRecognizer.init(target: self,
                                                  action: #selector(self.dismissPopup))
            self.vwBg?.removeGestureRecognizer(tap)
            self.vwBg?.addGestureRecognizer(tap)
        }

    }
    
    func showPopup() {
        showPopupWithCompletion(nil)
    }
    
    func showPopupWithCompletion(_ completion: ((Bool) -> Void)?) {
        showPopupWithCompletion(completion, onController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    func showPopupWithCompletion(_ completion: ((Bool) -> Void)?, onController viewController: UIViewController?) {
        guard let toView = viewController?.view else {
            print("Error: Popup viewController not found")
            return
        }
        
        self.frame = CGRect(x: 0, y: -20, width: toView.frame.size.width, height: toView.frame.size.height)
        self.alpha = 0.0
        toView.addSubview(self)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 1.0
            self.frame = CGRect(x: 0, y: 0, width: toView.frame.size.width, height: toView.frame.size.height)
        }) { (finished) in
            if let completion = completion {
                completion(finished)
            }
        }
    }
    
    @objc func dismissPopup() {
        self.dismissPopupWithCompletion(nil)
    }

    func dismissPopupWithCompletion(_ completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 0.0
        }) { (finished) in
            self.removeFromSuperview()
            if let completion = completion {
                completion(finished)
            }
        }
    }

    
    
}
