//
//  DbSheetDatePicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/18/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

// selectedDate is NSDate or NSNumber for "UIDatePickerModeCountDownTimer"
typealias DbActionDateDoneBlock = (_ picker: DbSheetDatePicker, _ selectedDate: Date) -> Void
typealias DbActionDateCancelBlock = (_ picker: DbSheetDatePicker) -> Void
typealias DbActionDateChangeValueBlock = (_ picker: DbSheetDatePicker, _ selectedDate: Date) -> Void
typealias DbActionCountDownDurationDoneBlock = (_ picker: DbSheetDatePicker, _ countDownDuration: TimeInterval) -> Void

class DbSheetDatePicker: DbAbstractSheet
{
    internal var datePicker: UIDatePicker!
    
    var doneBlock: DbActionDateDoneBlock?
    var cancelBlock: DbActionDateCancelBlock?
    var changeValueBlock: DbActionDateChangeValueBlock?
    var countDownDurationBlock: DbActionCountDownDurationDoneBlock?
    
    var selectedDate: Date?
    
    var datePickerMode: UIDatePickerMode = .date
    
    // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
    var minimumDate: Date?
    var maximumDate: Date? // default is nil
    // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30
    var minuteInterval: Int?
    // default is [NSLocale currentLocale]. setting nil returns to default
    var locale: Locale?
    // default is [NSCalendar currentCalendar]. setting nil returns to default
    var calendar : Calendar?
    // default is nil. use current time zone or time zone from calendar
    var timeZone: TimeZone?
    // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).
    var countDownDuration: TimeInterval = 0.0
    
    override init()
    {
        super.init()
        
        self.pickerFieldDelegate = self
    }
    
    override func setupContentView() -> UIView?
    {
        self.datePicker = UIDatePicker()
        
        self.datePicker.datePickerMode = self.datePickerMode
        self.datePicker.maximumDate = self.maximumDate
        self.datePicker.minimumDate = self.minimumDate
        self.datePicker.minuteInterval = self.minuteInterval ?? 1

        self.datePicker.locale = self.locale
        self.datePicker.calendar = self.calendar
        self.datePicker.timeZone = self.timeZone
        
        // if datepicker is set with a date in countDownMode then
        // 1h is added to the initial countdown
        if self.datePickerMode == .countDownTimer {
            self.datePicker.countDownDuration = self.countDownDuration
            // Due to a bug in UIDatePicker, countDownDuration needs to be set asynchronously
            // more info: http://stackoverflow.com/a/20204317/1161723
            DispatchQueue.main.async {
                self.datePicker.countDownDuration = self.countDownDuration
            }
        } else {
            self.datePicker.setDate(self.selectedDate ?? Date(), animated: false)
        }
        
        self.datePicker.addTarget(self, action: #selector(eventForDatePicker), for: .valueChanged)
        
        return self.datePicker
    }
    
    @objc fileprivate func eventForDatePicker(sender: Any)
    {
        self.selectedDate = self.datePicker.date
        self.countDownDuration = self.datePicker.countDownDuration

        //print("Just change :=> \(String(describing: self.selectedDate?.description))")
        //self.titleLabel?.text = self.selectedDate?.db_string(withFormat: VN_FORMAT_DATE_FULL)
        
        self.changeValueBlock?(self, self.selectedDate!)
    }
    
    static func initWithTitle(title: String,
                              datePickerMode: UIDatePickerMode = .date,
                              selectedDate: Date = Date(),
                              okTitle: String, cancelTitle: String,
                              doneBlock: @escaping DbActionDateDoneBlock) -> DbSheetDatePicker
    {
        let picker = DbSheetDatePicker()
        picker.titleLabel?.text = title
        picker.datePickerMode = datePickerMode
        picker.selectedDate = selectedDate
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        picker.doneBlock = doneBlock
        return picker
    }
    
}

//Mark:- PickerFieldDelegate
extension DbSheetDatePicker: DbAbstractSheetDelegate
{
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
        self.cancelBlock?(self)
    }
    
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet)
    {
        if self.datePickerMode == .countDownTimer {
            self.countDownDurationBlock?(self, self.countDownDuration)
        } else {
            self.doneBlock?(self, self.selectedDate ?? Date())
        }
    }
}
