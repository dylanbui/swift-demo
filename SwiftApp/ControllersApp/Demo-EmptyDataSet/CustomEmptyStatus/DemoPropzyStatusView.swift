//
//  DemoPropzyStatusView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/24/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

open class DemoPropzyStatusView: UIView, DbEmptyStatusView {
    
    public var view: UIView {
        return self
    }
    
    public var status: DbEmptyStatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            imageView.image = status.image
            titleLabel.text = status.title
            descriptionLabel.text = status.description
            
            activityIndicatorView.color = status.spinnerColor
            if status.isLoading {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            let actionButtonHidden: Bool = status.actionButton == nil
            
            verticalStackView.isHidden = imageView.isHidden && descriptionLabel.isHidden && actionButtonHidden
        }
    }
    
    public var titleLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    public var descriptionLabel: UILabel = {
        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        
        return $0
    }(UILabel())
    
    public let activityIndicatorView: UIActivityIndicatorView = {
        $0.isHidden = true
        $0.hidesWhenStopped = true
        $0.activityIndicatorViewStyle = .gray
        $0.color = UIColor.lightGray
        return $0
    }(UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge))
    
    public let imageView: UIImageView = {
        $0.contentMode = .center
        
        return $0
    }(UIImageView())
    
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
        
        if let btn = self.status?.actionButton {
            verticalStackView.addArrangedSubview(btn)
        }
        
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
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
