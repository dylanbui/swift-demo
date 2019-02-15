//
//  DbEmptyCustomStatusView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/14/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

open class DbEmptyCustomStatusView: UIView, DbEmptyStatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: DbEmptyStatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
            actionButton.setTitle(status.actionTitle, for: UIControlState())
            
            activityIndicatorView.circleLayer.strokeColor = status.spinnerColor.cgColor
            if status.isLoading {
                activityIndicatorView.isHidden = false
                activityIndicatorView.beginRefreshing() //startAnimating()
            } else {
                activityIndicatorView.isHidden = true
                activityIndicatorView.endRefreshing() //stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            actionButton.isHidden = status.action == nil
            
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
    
    public let activityIndicatorView: JTMaterialSpinner = {
        $0.isHidden = true
        $0.circleLayer.lineWidth = 2.0
        $0.circleLayer.strokeColor = UIColor.orange.cgColor
        
        return $0
    }(JTMaterialSpinner(frame: CGRect(0, 0, 25, 25)))
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
    public let actionButton: UIButton = {
        
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
        
        actionButton.addTarget(self, action: #selector(DbEmptyDefaultStatusView.actionButtonAction), for: .touchUpInside)
        
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.widthAnchor.constraint(equalToConstant: activityIndicatorView.frame.size.width),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: activityIndicatorView.frame.size.height)
            ])
        
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(actionButton)
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    @objc func actionButtonAction() {
        status?.action?()
    }
    
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
