//
//  DbSheetPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/16/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbSheetPickerDoneBlock = (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbPickerProtocol) -> Void
typealias DbSheetPickerCancelBlock = (_ picker: DbSheetPicker) -> Void
typealias DbSheetPickerDidSelectRowBlock = (_ picker: DbSheetPicker, _ didSelectRow: Int) -> Void


//- (instancetype)initWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin
//{
//    return [self initWithTitle:title delegate:delegate
//        showCancelButton:showCancelButton origin:origin
//        initialSelections:nil];
//    }
//
//    + (instancetype)showPickerWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin
//{
//    return [self showPickerWithTitle:title delegate:delegate showCancelButton:showCancelButton origin:origin
//        initialSelections:nil ];
//    }
//
//    - (instancetype)initWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin initialSelections:(NSArray *)initialSelections
//{
//    if ( self = [self initWithTarget:nil successAction:nil cancelAction:nil origin:origin] )
//    {
//
//        self.title = title;
//        self.hideCancel = !showCancelButton;
//        NSAssert(delegate, @"Delegate can't be nil");
//        _delegate = delegate;
//        if (initialSelections)
//        self.initialSelections = [[NSArray alloc] initWithArray:initialSelections];
//    }
//    return self;
//    }
//
//    /////////////////////////////////////////////////////////////////////////
//
//    + (instancetype)showPickerWithTitle:(NSString *)title delegate:(id <ActionSheetCustomPickerDelegate>)delegate showCancelButton:(BOOL)showCancelButton origin:(id)origin initialSelections:(NSArray *)initialSelections
//{
//    ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:title delegate:delegate
//        showCancelButton:showCancelButton origin:origin
//        initialSelections:initialSelections];
//    [picker showActionSheetPicker];
//    return picker;
//}

class DbSheetPicker: DbAbstractPicker
{
    var arrItem: [DbPickerProtocol]?
    var selectedItem: DbPickerProtocol?
    
    var doneBlock: DbSheetPickerDoneBlock?
    var cancelBlock: DbSheetPickerCancelBlock?
    var didSelectRowBlock: DbSheetPickerDidSelectRowBlock?
    
    
    override init()
    {
        super.init()
        
        let item_1 = DbPickerItem(iId: 1, desc: "Giá từ thấp đến cao")
        let item_2 = DbPickerItem(iId: 2, desc: "Giá từ cao xuống thấp")
        let item_3 = DbPickerItem(iId: 3, desc: "Diện tích từ nhỏ đến lớn")
        let item_4 = DbPickerItem(iId: 4, desc: "Diện tích từ lớn đến nhỏ")
        let item_5 = DbPickerItem(iId: 5, desc: "Ngày tạo mới nhất")
        let arrSortItem = [item_1, item_2, item_3, item_4, item_5]
        self.arrItem = arrSortItem
        
        self.type = .pickerView
        self.pickerView?.dataSource = self
        self.pickerView?.delegate = self
        self.pickerFieldDelegate = self
        // self.cancelWhenTouchUpOutside = true
        
        self.pickerView?.showsSelectionIndicator = true
        self.pickerView?.isUserInteractionEnabled = true
    }
    
    static func initWithTitle(title: String,
                              rows: [DbPickerProtocol],
                              initialSelections: [DbPickerProtocol]?,
                              okTitle: String, cancelTitle: String) -> DbSheetPicker
    {
        let picker = DbSheetPicker()
        picker.arrItem = rows
        picker.titleLabel?.text = title
        picker.okTitle = okTitle
        picker.cancelTitle = cancelTitle
        picker.pickerView?.reloadAllComponents()
        return picker
    }
    
//    convenience init(WithTitle title: String, okTitle: String, cancelTitle: String, initialSelections: [DbPickerProtocol])
//    {
//        self.init()
//
//        self.titleLabel?.text = title
//        self.okTitle = okTitle
//        self.cancelTitle = cancelTitle
//    }
    
}

//Mark:- PickerFieldDelegate
extension DbSheetPicker: DbPickerFieldDelegate
{
    func pickerField(didHidePicker pickerField: DbAbstractPicker)
    {
        print("didHidePicker")
    }
    
    func pickerField(didCancelClick pickerField: DbAbstractPicker)
    {
        self.cancelBlock?(self)
    }
    
    func pickerField(didOKClick pickerField: DbAbstractPicker)
    {
        if pickerField.type == .pickerView {
            if let row = pickerField.pickerView?.selectedRow(inComponent: 0) {
                self.doneBlock?(self, row, self.arrItem![row])
            }
        }
    }
}

//Mark:- PickerView
extension DbSheetPicker: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "OKKKKKKK"
    }
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int
//    {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
//    {
//        return self.arrItem?.count ?? 0
//    }
//
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
//    {
//        return 280.0
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
//    {
//        let item = self.arrItem![row]
//        return item.dbPickerItemTitle
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
//    {
//        // -- Day la xu ly khi vua chon --
//         self.didSelectRowBlock?(self, row)
//    }
    
//    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
//    {
////        guard let pickerView = actionSheetPicker.pickerView as? UIPickerView else { return }
////        let row = pickerView.selectedRow(inComponent: 0)
////        self.doneBlock?(self.customPicker!, row, self.arrItem![row])
//    }
//
//    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
//    {
//        //self.cancelBlock?(self.customPicker!)
//    }
    
    
}
