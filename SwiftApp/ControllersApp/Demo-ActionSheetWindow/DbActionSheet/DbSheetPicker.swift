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
    
    var doneBlock: DbSheetPickerDoneBlock?
    var cancelBlock: DbSheetPickerCancelBlock?
    var didSelectRowBlock: DbSheetPickerDidSelectRowBlock?
    
    override init()
    {
        super.init()
        
        self.pickerFieldDelegate = self
        self.cancelWhenTouchUpOutside = true
    }
    
    override func setupContentView() -> UIView?
    {
        self.pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
 
        // -- Setup selection item --
        if let selectedItem = self.selectedItem {
            var objectIndex = 0
            if let index = self.arrSource?.index(where: { (city) -> Bool in
                return city.dbItemId == selectedItem.dbItemId
            }) {
                objectIndex = index
            }
            self.pickerView.selectRow(objectIndex, inComponent: 0, animated: false)
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
