//
//  DbCustomButtonSheetPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/22/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

/* Demo add more button to contentView, use UIStackView */


class DbCustomButtonSheetPicker: DbSheetPicker
{
    override init()
    {
        super.init()
        //self.hideButtons = true
    }
    
    
    override func setupContentView() -> UIView?
    {
        guard let pickerView = super.setupContentView() else {
            return nil
        }
        
        let parentView = UIView()
        parentView.addSubview(pickerView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical // .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(stackView)
        
        // -- pickerView Constraint --
        addConstraint(pickerView, toView: parentView, top: nil, leading: 0, bottom: nil, trailing: 0)
        pickerView.topAnchor.constraint(equalTo: parentView.topAnchor,constant: 0).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: stackView.topAnchor,constant: 0).isActive = true

        // -- stackView Constraint --
        addConstraint(stackView, toView: parentView, top: nil, leading: 0, bottom: nil, trailing: 0)
        stackView.topAnchor.constraint(equalTo: pickerView.bottomAnchor,constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,constant: 0).isActive = true
        
        let viewButton_1 = self.createButtonItem("My Button 1")
        let viewButton_2 = self.createButtonItem("My Button 2")
        viewButton_2.backgroundColor = UIColor.blue
        let viewButton_3 = self.createButtonItem("My Button 3")
        stackView.addArrangedSubview(viewButton_1)
        stackView.addArrangedSubview(viewButton_2)
        stackView.addArrangedSubview(viewButton_3)

        // -- For stack vertical --
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40*3).isActive = true
        self.fieldHeight = self.fieldHeight + (40*3)
        // -- For stack horizontal --
//        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
//        self.fieldHeight = self.fieldHeight + 40
        
        // -- Set contentInsets again--
        self.contentInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        
        return parentView
    }
    
    
    private func createButtonItem(_ title: String) -> UIView
    {
        // BottomView buttons
        let buttonView = UIView()
        // buttonView.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        // -- Add button --
        let button = UIButton(type: .system)
        buttonView.addSubview(button)
        button.setTitle(title, for: .normal)
        addConstraint(button, toView: buttonView, top: nil, leading: 0, bottom: nil, trailing: 0)
        button.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        
        // Seperator line
        let seperater = UIView()
        buttonView.addSubview(seperater)
        addConstraint(seperater, toView: buttonView, top: 0, leading: 0, bottom: nil, trailing: 0)
        seperater.topAnchor.constraint(equalTo: buttonView.topAnchor).isActive=true
        seperater.heightAnchor.constraint(equalToConstant: 1).isActive=true
        seperater.backgroundColor = UIColor.groupTableViewBackground
        
        return buttonView
    }
}
