//
//  DbActionSheetPicker.swift
//  PropzySam
//
//  Created by Dylan Bui on 12/18/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Custom from ActionSheetCustomPicker

import Foundation
import ActionSheetPicker_3_0

/*
 
 let item_1 = DbPickerItem(iId: 1, desc: "Giá từ thấp đến cao")
 let item_2 = DbPickerItem(iId: 2, desc: "Giá từ cao xuống thấp")
 let item_3 = DbPickerItem(iId: 3, desc: "Diện tích từ nhỏ đến lớn")
 let item_4 = DbPickerItem(iId: 4, desc: "Diện tích từ lớn đến nhỏ")
 let item_5 = DbPickerItem(iId: 5, desc: "Ngày tạo mới nhất")
 let arrSortItem = [item_1, item_2, item_3, item_4, item_5]
 
 DbActionSheetPicker.showPicker(withTitle: "Nguồn khách hàng", collections: arrSortItem, withInitialSelection: nil,
 done: { (owner, selected, row) in
 print("Da chon cai gi")
 }, cancel: { (owner) in }, origin: sender)
 
 */

protocol DbPickerProtocol {
    
    var dbPickerItemId: Int { get }
    var dbPickerItemTitle: String { get }
    var dbPickerItemDesc: String { get }
    
}

class DbPickerItem: DbPickerProtocol, CustomStringConvertible
{
    var dbPickerItemId: Int
    var dbPickerItemTitle: String
    var dbPickerItemDesc: String
    
    // Extension CustomStringConvertible
    var description: String {
        return "ItemId: \(dbPickerItemId) - Desc: \(dbPickerItemDesc)"
    }
    
    init() {
        self.dbPickerItemId = 0
        self.dbPickerItemTitle = ""
        self.dbPickerItemDesc = ""
    }
    
    convenience init(iId: Int, desc: String) {
        self.init()
        self.dbPickerItemId = iId
        self.dbPickerItemTitle = desc
        self.dbPickerItemDesc = desc
    }
    
}

typealias DbPickerDoneBlock = (_ picker: ActionSheetCustomPicker, _ selectedIndex: Int, _ selectedValue: DbPickerProtocol) -> Void
typealias DbPickerCancelBlock = (_ picker: ActionSheetCustomPicker) -> Void
typealias DbPickerDidSelectRowBlock = (_ picker: ActionSheetCustomPicker, _ didSelectRow: Int) -> Void

class DbActionSheetPicker: NSObject
{
    var arrItem: [DbPickerProtocol]?
    var selectedItem: DbPickerProtocol?
    
    var title: String = ""
    var titleDone: String = "Xong"
    var titleCancel: String? = nil
    
    var doneBlock: DbPickerDoneBlock?
    var cancelBlock: DbPickerCancelBlock?
    var didSelectRowBlock: DbPickerDidSelectRowBlock?
    
    private var customPicker: ActionSheetCustomPicker?
    
    override init() {
        
    }
    
    func showPicker(WithOrigin originObj:Any) -> Void
    {
        if self.arrItem == nil {
            // -- Bao loi ngay tai cho --
            fatalError("arrItem not nil")
        }
        
        var objectIndex = 0
        if self.selectedItem != nil {
            if let index = self.arrItem?.index(where: { (city) -> Bool in
                return city.dbPickerItemId == self.selectedItem!.dbPickerItemId
            }) {
                objectIndex = index
            }
        }
        
        self.customPicker = ActionSheetCustomPicker.init(title: title,
                                                         delegate: self,
                                                         showCancelButton: true,
                                                         origin: originObj, initialSelections: [objectIndex])
        // -- Done --
        let btnDone = UIBarButtonItem(title: titleDone, style: .done, target: self, action: nil)
        self.customPicker?.setDoneButton(btnDone)
        // -- Cancel --
        if let cancel = self.titleCancel {
            let btnCancel = UIBarButtonItem(title: cancel, style: .done, target: self, action: nil)
            self.customPicker?.setCancelButton(btnCancel)
        } else {
            // -- Hide cancel button --
            self.customPicker?.setCancelButton(nil)
        }
        
        // -- Dismis when tap out --
        self.customPicker?.tapDismissAction = .cancel
        
        self.customPicker?.show()
    }
    
    class func showPicker(withTitle title: String,
                          collections arrItem: [DbPickerProtocol],
                          withInitialSelection selectedItem: DbPickerProtocol?,
                          done doneBlock: @escaping DbPickerDoneBlock,
                          cancel cancelBlock: @escaping DbPickerCancelBlock, origin originObj:Any) -> Void
    {
        let picker: DbActionSheetPicker = DbActionSheetPicker()
        
        picker.arrItem = arrItem
        picker.selectedItem = selectedItem
        
        picker.title = title
        picker.titleDone = "Xong"
        picker.titleCancel = "Hủy"
        
        picker.doneBlock = doneBlock
        picker.cancelBlock = cancelBlock
        
        picker.showPicker(WithOrigin: originObj)
    }
    
}

extension DbActionSheetPicker: ActionSheetCustomPickerDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.arrItem?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return 300.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        let item = self.arrItem![row]
        return item.dbPickerItemDesc
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // -- Day la xu ly khi vua chon --
        self.didSelectRowBlock?(self.customPicker!, row)
    }
    
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
    {
        guard let pickerView = actionSheetPicker.pickerView as? UIPickerView else { return }
        let row = pickerView.selectedRow(inComponent: 0)
        self.doneBlock?(self.customPicker!, row, self.arrItem![row])
    }
    
    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
    {
        self.cancelBlock?(self.customPicker!)
    }
    
    
    
    
}


