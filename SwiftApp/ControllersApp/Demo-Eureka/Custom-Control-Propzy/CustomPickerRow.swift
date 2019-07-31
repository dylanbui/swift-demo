//
//  CustomPickerRow.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/14/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import Eureka
//import ActionSheetPicker_3_0

public struct CustomPickerItem: Equatable {
    var id: Int
    var title: String
    var desc: String
    
    init(id: Int, title: String, desc: String) {
        self.id = id
        self.title = title
        self.desc = desc
    }
}

public func ==(lhs: CustomPickerItem, rhs: CustomPickerItem) -> Bool {
    return lhs.id == rhs.id
}

class CustomPickerCell: _FieldCell<String>, CellType //, ActionSheetCustomPickerDelegate
{
    public var arrSources: [CustomPickerItem] = []
    public var itemSelected: CustomPickerItem?
    
//    private var customPicker: ActionSheetCustomPicker?
    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    open override func setup()
    {
        super.setup()
        
        // -- Tap on uitextfield action : Error--
//        textField.onTap { (tapGestureRecognizer) in
//            self.showPickerView()
//        }

        let btn: UIButton = UIButton(type: .custom)
        textField.addSubview(btn)
        // -- Phai dung Constraint moi co the xu ly duoc --
        // btn.db_fillToSuperview(UIEdgeInsetsMake(2, 4, 3, 10))
        btn.db_fillToSuperview()
        btn.onTap { (tapGestureRecognizer) in
            self.showPickerView()
        }
        
        // -- Add icon to right --
//        self.textField.rightViewMode = UITextFieldViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        let image = UIImage.arrowDown(UIColor.init(95, 95, 95, 0.8))
//        imageView.image = image
//        self.textField.rightView = imageView
    }
    
    override func update()
    {
        super.update()
        
    }

    // -- Select row action --
    override func didSelect()
    {
        super.didSelect()
    }

    // -- Disable textField editing --
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return false
    }
    
    private func showPickerView()
    {
        // -- Return if == 0 --
        if self.arrSources.count <= 0 { return }
        
//        // -- Cach khac --
//        var selectedIndex = 0
//        if let item = self.itemSelected {
//            if let index = self.arrSources.index(where: { (tuple) -> Bool in
//                return tuple.id == item.id
//            }) {
//                selectedIndex = index
//            }
//        }
//
//        self.customPicker = nil
//        self.customPicker = ActionSheetCustomPicker.init(title: self.row.title,
//                                                         delegate: self,
//                                                         showCancelButton: true,
//                                                         origin: self, initialSelections: [selectedIndex])
//        // self.customPicker?.changeTitleOfButton()
//        self.customPicker?.tag = 1
//        self.customPicker?.tapDismissAction = .cancel
//
//        // -- Show picker --
//        self.customPicker?.show()
        // -- Scroll to middle when active --
        self.row.select(animated: true, scrollPosition: .middle)
    }
    
    func reloadData(_ source: [CustomPickerItem] = []) -> Void
    {
        self.arrSources = source
        // -- reset data --
        self.itemSelected = nil
        self.row.value = nil
        self.textField.text = nil
    }
    
    // MARK: ActionSheetCustomPickerDelegate
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.arrSources.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return 260.0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let item = self.arrSources[row]
        return item.title
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // -- Day la xu ly khi vua chon --
    }
    
//    public func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
//    {
//        //        if let pickerView =  actionSheetPicker.pickerView as? UIPickerView {
//        //            let row = pickerView.selectedRow(inComponent: 0)
//        //        }
//        
//        guard let pickerView =  actionSheetPicker.pickerView as? UIPickerView else { return }
//        let rowIndex = pickerView.selectedRow(inComponent: 0)
//        let item = self.arrSources[rowIndex]
//        
//        // -- Choose value --
//        self.itemSelected = item
//        self.textField.text = item.title
//        
//        // -- Scroll to middle after choose --
//        // self.row.select(animated: true, scrollPosition: .middle)
//    }
//    
//    public func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
//    {
//        // self.cancelBlock?(self.customPicker!)
//    }
    
    
    
}

/// A String valued row where the user can enter arbitrary text.
final class CustomPickerRow: FieldRow<CustomPickerCell>, RowType
{
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
