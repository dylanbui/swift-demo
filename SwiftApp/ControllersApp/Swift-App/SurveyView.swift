//
//  SurveyView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/6/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  demo : https://blog.usejournal.com/custom-uiview-in-swift-done-right-ddfe2c3080a

import UIKit

class SurveyView: UIView
{
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var headerTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.backgroundColor = UIColor.blue
        headerTitle.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        headerTitle.text = "Custom View"
        headerTitle.textAlignment = .center
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        return headerTitle
    }()
    
    convenience init()
    {
        self.init(frame: .zero)
        
    }
    
    convenience init(WithString string: String)
    {
        self.init(frame: .zero)
        
    }
    
    override init (frame: CGRect)
    {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    func initCommon()
    {
        self.stackView.backgroundColor = UIColor.yellow
        
        // Your custom initialization code
        self.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.headerTitle)
        
        
        // -- Add subview before call setupLayout --
        self.setupConstraintLayout()
    }
    
    private func setupConstraintLayout()
    {
        self.stackView.db_fillToSuperview()
        
        self.headerTitle.db_fillToSuperview(UIEdgeInsetsMake(0, 15, 0, 0))
        
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        // Set frame view size and position
        // -- Chieu cao chi co 60 --
        //self.height = 60
        
    }

}



