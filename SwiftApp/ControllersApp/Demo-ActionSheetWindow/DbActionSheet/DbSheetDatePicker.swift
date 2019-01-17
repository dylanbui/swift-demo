//
//  DbSheetDatePicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/18/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbSheetDatePickerDoneBlock = (_ picker: DbSheetDatePicker, _ selectedIndex: Int, _ selectedValue: DbPickerProtocol) -> Void
typealias DbSheetDatePickerCancelBlock = (_ picker: DbSheetDatePicker) -> Void
typealias DbSheetDatePickerDidSelectRowBlock = (_ picker: DbSheetDatePicker, _ didSelectRow: Int) -> Void

class DbSheetDatePicker: DbAbstractSheet
{
    private var datePicker: UIDatePicker!
    
    var arrSource: [DbPickerProtocol]?
    var selectedItem: DbPickerProtocol?
    
    var doneBlock: DbSheetDatePickerDoneBlock?
    var cancelBlock: DbSheetDatePickerCancelBlock?
    var didSelectRowBlock: DbSheetDatePickerDidSelectRowBlock?
    
    var datePickerMode: UIDatePickerMode = .date
    // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
    var minimumDate: Date?
    var maximumDate: Date? = nil // default is nil
    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30
    var minuteInterval: Int? = nil
    // default is [NSLocale currentLocale]. setting nil returns to default
    var locale: Locale?
    // default is [NSCalendar currentCalendar]. setting nil returns to default
    var calendar : Calendar?
    // default is nil. use current time zone or time zone from calendar
    var timeZone: TimeZone?
    // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).
    var countDownDuration: TimeInterval?
    
    override init()
    {
        super.init()
        
        self.pickerFieldDelegate = self
    }
    
    override func setupContentView()
    {
        self.datePicker = UIDatePicker()
        
        self.datePicker.datePickerMode = self.datePickerMode
        self.datePicker.maximumDate = Date()
        
        contentView?.addSubview(datePicker)
        addConstraint(datePicker!, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    static func initWithTitle(title: String,
                              rows: [DbPickerProtocol],
                              initialSelections: DbPickerProtocol?,
                              okTitle: String, cancelTitle: String) -> DbSheetDatePicker
    {
        let picker = DbSheetDatePicker()
        picker.arrSource = rows
        picker.selectedItem = initialSelections
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        return picker
    }
}

//Mark:- PickerFieldDelegate
extension DbSheetDatePicker: DbAbstractSheetDelegate
{
    func pickerField(didHidePicker pickerField: DbAbstractSheet)
    {
        // print("didHidePicker")
    }
    
    func pickerField(didCancelClick pickerField: DbAbstractSheet)
    {
        // print("pickerField")
        self.cancelBlock?(self)
    }
    
    func pickerField(didOKClick pickerField: DbAbstractSheet)
    {
//        if let row = self.pickerView?.selectedRow(inComponent: 0) {
//            self.doneBlock?(self, row, self.arrSource![row])
//        }
    }
}
