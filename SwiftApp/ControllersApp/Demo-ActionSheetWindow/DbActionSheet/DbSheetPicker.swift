//
//  PickerField.swift
//  mtpPickerField
//
//  Created by Mostafa Taghipour on 12/12/17.
//  Copyright © 2017 RainyDay. All rights reserved.
//

import UIKit

typealias DbSheetPickerDoneBlock = (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) -> Void
typealias DbSheetPickerCancelBlock = (_ picker: DbSheetPicker) -> Void
typealias DbSheetPickerDidSelectRowBlock = (_ picker: DbSheetPicker, _ didSelectRow: Int) -> Void

class DbSheetPicker: DbAbstractSheet
{
    internal var pickerView: UIPickerView!
    
    var arrSource: [DbItemProtocol]?
    var selectedItem: DbItemProtocol?
    
    var customButtons: [UIButton]?
    var customButtonsAxis: NSLayoutConstraint.Axis = .vertical
    
    var doneBlock: DbSheetPickerDoneBlock?
    var cancelBlock: DbSheetPickerCancelBlock?
    var didSelectRowBlock: DbSheetPickerDidSelectRowBlock?
    
    override init()
    {
        super.init()
        
        self.pickerFieldDelegate = self
        self.cancelWhenTouchUpOutside = true
    }
    
    @discardableResult
    override func setupContentView() -> UIView?
    {
        self.pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
 
        // -- Setup selection item --
        if let selectedItem = self.selectedItem {
            var objectIndex = 0
            if let index = self.arrSource?.index(where: { (dbItem) -> Bool in
                return dbItem.dbItemId == selectedItem.dbItemId
            }) {
                objectIndex = index
            }
            self.pickerView.selectRow(objectIndex, inComponent: 0, animated: false)
        }
        
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
    
    static func initWithTitle(title: String,
                              rows: [DbItemProtocol],
                              initialSelections: DbItemProtocol?,
                              okTitle: String, cancelTitle: String) -> DbSheetPicker
    {
        let picker = DbSheetPicker()
        picker.arrSource = rows
        picker.selectedItem = initialSelections
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        return picker
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

//Mark:- PickerFieldDelegate
extension DbSheetPicker: DbAbstractSheetDelegate
{
    func sheetPicker(didHidePicker sheetPicker: DbAbstractSheet)
    {
        // print("didHidePicker")
    }
    
    func sheetPicker(didShowPicker sheetPicker: DbAbstractSheet)
    {
        // print("didShowPicker")
    }
    
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet)
    {
        if let row = self.pickerView?.selectedRow(inComponent: 0) {
            self.doneBlock?(self, row, self.arrSource![row])
        }
    }
    
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
        self.cancelBlock?(self)
    }
}

// Mark:- UIPicker
extension DbSheetPicker: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.arrSource?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return 280.0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let item = self.arrSource![row]
        return item.dbItemTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // -- Day la xu ly khi vua chon --
         self.didSelectRowBlock?(self, row)
    }
}
