//
//  DbSheetCustomPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/17/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbSheetCustomPickerDelegate = UIPickerViewDelegate & UIPickerViewDataSource

class DbSheetCustomPicker: DbAbstractSheet
{
    internal var pickerView: UIPickerView!
    
    var customPickerDelegate: DbSheetCustomPickerDelegate?
    
    var customButtons: [UIButton]?
    var customButtonsAxis: NSLayoutConstraint.Axis = .vertical
    
    override init()
    {
        super.init()
    }
    
    @discardableResult
    override func setupContentView() -> UIView?
    {
        self.pickerView = UIPickerView()
        self.pickerView.dataSource = self.customPickerDelegate
        self.pickerView.delegate = customPickerDelegate
        
        // -- Create custom buttons view --
        if let arrButtons = self.customButtons {
            // -- Create UIStackView with customs button --
            let stackView = self.makeCustomButtons(arrButtons: arrButtons)
            
            let parentView = UIView()
            parentView.addSubview(self.pickerView)
            parentView.addSubview(stackView)
            
            // -- pickerView Constraint --
            addConstraint(pickerView, toView: parentView, top: nil, leading: 0, bottom: nil, trailing: 0)
            pickerView.topAnchor.constraint(equalTo: parentView.topAnchor,constant: 0).isActive = true
            pickerView.bottomAnchor.constraint(equalTo: stackView.topAnchor,constant: 0).isActive = true
            
            // -- stackView Constraint --
            addConstraint(stackView, toView: parentView, top: nil, leading: 0, bottom: nil, trailing: 0)
            stackView.topAnchor.constraint(equalTo: pickerView.bottomAnchor,constant: 0).isActive = true
            stackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,constant: 0).isActive = true
            
            // -- Calculate UIStackView Height --
            let defaultButtonHeight = 45
            if self.customButtonsAxis == .vertical {
                // -- For stack vertical --
                stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(defaultButtonHeight*arrButtons.count)).isActive = true
                self.fieldHeight = self.fieldHeight + CGFloat(defaultButtonHeight*arrButtons.count)
                
            } else {
                // -- For stack horizontal --
                stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(defaultButtonHeight)).isActive = true
                self.fieldHeight = self.fieldHeight + CGFloat(defaultButtonHeight)
            }
            
            // -- Set contentInsets again--
            self.contentInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
            return parentView
        }
        
        return self.pickerView
    }
    
    private func makeCustomButtons(arrButtons: [UIButton]) -> UIView
    {
        let stackView = UIStackView()
        stackView.axis = self.customButtonsAxis //.vertical // .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for button: UIButton in arrButtons {
            // BottomView buttons
            let buttonView = UIView()
            
            // -- Add button --
            // let button = UIButton(type: .system)
            buttonView.addSubview(button)
            // button.setTitle(title, for: .normal)
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
            
            stackView.addArrangedSubview(buttonView)
        }
        
        return stackView
    }
}
