//
//  DbEmptyDefaultStatusView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/13/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

open class DbEmptyDefaultStatusView: UIView, DbEmptyStatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: DbEmptyStatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
//            #if swift(>=4.2)
//            actionButton.setTitle(status.actionTitle, for: UIControl.State())
//            #else
//            actionButton.setTitle(status.actionTitle, for: UIControlState())
//            #endif
            
            
            
            activityIndicatorView.color = status.spinnerColor
            if status.isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            
            actionButton.isHidden = true
            //self.actionButton = status.actionButton
            //var actionButtonHidden: Bool = true //Bool = status.actionButton == nil
            if let btn = status.actionButton {
                // actionButtonHidden = false
                //self.actionButton = btn
                self.actionButton.setTitle("actionTitle1", for: UIControl.State())
                self.actionButton.isHidden = false
                
                verticalStackView.addArrangedSubview(btn)
            }
            
//            actionButton.isHidden = status.actionButton  == nil
//            self.actionButton.setTitle("actionTitle1", for: UIControl.State())
            
            //self.actionButton.isHidden = status.action == nil
            
            verticalStackView.isHidden = imageView.isHidden && descriptionLabel.isHidden && actionButton.isHidden
        }
    }
    
    public let titleLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    public let descriptionLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    #if swift(>=4.2)
    public let activityIndicatorView: UIActivityIndicatorView = {
    $0.isHidden = true
    $0.hidesWhenStopped = true
    $0.style = .gray
    return $0
    }(UIActivityIndicatorView(style: .whiteLarge))
    #else
    public let activityIndicatorView: UIActivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        $0.activityIndicatorViewStyle = .gray
        $0.color = UIColor.lightGray
        return $0
    }(UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge))
    #endif
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
    public var actionButton: UIButton = {
        
        return $0
    }(UIButton(type: .system))
    
    public let verticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    public let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        // actionButton.addTarget(self, action: #selector(DbEmptyDefaultStatusView.actionButtonAction), for: .touchUpInside)
        
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(activityIndicatorView)
        // -- Add Constraint for custom IndicatorView Size --
//        NSLayoutConstraint.activate([
//            activityIndicatorView.widthAnchor.constraint(equalToConstant: activityIndicatorView.frame.size.width),
//            activityIndicatorView.heightAnchor.constraint(equalToConstant: activityIndicatorView.frame.size.height)
//            ])
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        //verticalStackView.addArrangedSubview(actionButton)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
//    @objc func actionButtonAction() {
//        status?.action?()
//    }
    
    open override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            descriptionLabel.textColor = tintColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
