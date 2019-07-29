//
//  ShowMoreLabelStackCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/10/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

final class ShowMoreLabelStackCell: StackCellBase
{
    private let defaultHeight: CGFloat = 80
    var viewMore: Bool = false
    
    private let viewContent: UIView = {
        let view = UIView()
        view.clipsToBounds = true // Remove content outsite uiview
        return view
    }()

    
    private let lblContent: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.yellow
        lbl.textColor = UIColor.gray
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let btnShowMore: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle(".. more ..", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()

    private let btnMore: UIButton = {
        let btn = UIButton.init(type: .system)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("View More", for: .normal)
        return btn
    }()
    
    override init()
    {
        super.init()
        
        backgroundColor = UIColor.lightGray
        
        self.viewContent.addSubview(self.lblContent)
        self.viewContent.addSubview(self.btnShowMore)
        addSubview(viewContent)
        addSubview(btnMore)
        
//        self.viewContent.db_addShadow(withLocation: .bottom, color: UIColor.lightGray,
//                                      length: 10,
//                                      radius: 5,
//                                      opacity: 0.5)
//        self.viewContent.clipsToBounds = true
        // -- Lop bao noi dung hien thi --
        self.viewContent.snp.makeConstraints { (make) in
            // make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 6))
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(16)
            make.right.equalTo(-6)
            // -- Xac dinh chieu cao theo noi dung --
            make.height.equalTo(defaultHeight)
        }

        // -- Day la noi dung hien thi --
        self.lblContent.snp.makeConstraints { (make) in
            // make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 6))
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            // -- Xac dinh chieu cao theo noi dung --
            make.height.greaterThanOrEqualTo(defaultHeight)
        }
        
        self.btnShowMore.alpha = 1.0
        self.btnShowMore.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            // -- Xac dinh chieu cao theo noi dung --
            make.height.greaterThanOrEqualTo(30)
        }

        
        // -- Xac dinh chieu cao theo noi dung --
//        lblContent.snp.makeConstraints { (make) in
//            // make.height.greaterThanOrEqualTo(80)
//            make.height.equalTo(80)
//        }
        
        self.btnMore.onTap { (gesture) in
            self.tap()
        }
        self.btnMore.snp.makeConstraints { (make) in
            make.top.equalTo(viewContent.snp.bottom).offset(5)
            make.left.equalTo(16)
            make.right.equalTo(-6)
            make.bottom.equalToSuperview().offset(-12)
            // -- Xac dinh chieu cao theo noi dung --
            make.height.equalTo(40)
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        // -- Add gradien color for Show more button --
        // Apply Gradient Color
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = CGSize.init(self.viewContent.width, 30)
            //self.btnShowMore.intrinsicContentSize //self.btnShowMore.frame.size
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor,
                                UIColor.gray.withAlphaComponent(1).cgColor]
        
        // replace gradient as needed
        if let oldGradient = self.btnShowMore.layer.sublayers?[0] as? CAGradientLayer {
            self.btnShowMore.layer.replaceSublayer(oldGradient, with: gradientLayer)
        } else {
            self.btnShowMore.layer.insertSublayer(gradientLayer, below: nil)
        }
    }
    
    func set(value: String)
    {
        lblContent.text = value
    }
    
    private func tap()
    {
        if viewMore {
            _close()
        } else {
            _open()
        }
    }
    
    private func _close() {
        
        guard viewMore == true else { return }
        
        viewMore = false
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            
            animations: {
                
                self.btnShowMore.alpha = 1.0
                
                self.viewContent.snp.updateConstraints({ (update) in
                    update.height.equalTo(self.defaultHeight)
                })
                
                self.viewContent.layoutIfNeeded()
                self.updateLayout(animated: true)
                self.scrollToSelf(animated: true)
                
        }) { (finish) in
            
        }
        
    }
    
    func _open() {
        
        guard viewMore == false else { return }
        
        viewMore = true
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            
            animations: {
                
                self.btnShowMore.alpha = 1.0
                
                self.viewContent.snp.updateConstraints({ (update) in
                    update.height.equalTo(self.lblContent.db_requiredHeight)
                })
                
                self.viewContent.layoutIfNeeded()
                self.updateLayout(animated: true)
                self.scrollToSelf(animated: true)
                
        }) { (finish) in
            
        }
        
    }
    
}
