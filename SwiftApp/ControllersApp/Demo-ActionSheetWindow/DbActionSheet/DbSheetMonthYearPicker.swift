//
//  DbSheetMonthYearPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/25/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

//typealias DbSheetPickerDoneBlock = (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) -> Void
//typealias DbSheetPickerCancelBlock = (_ picker: DbSheetPicker) -> Void
//typealias DbSheetPickerDidSelectRowBlock = (_ picker: DbSheetPicker, _ didSelectRow: Int) -> Void

typealias DbMonthYearDoneBlock = (_ picker: DbSheetMonthYearPicker, _ selectedDate: Date) -> Void
typealias DbMonthYearCancelBlock = (_ picker: DbSheetMonthYearPicker) -> Void
//typealias DbMonthYearDateChangeValueBlock = (_ picker: DbSheetMonthYearPicker, _ selectedDate: Date) -> Void

//typedef enum {
//    NTMonthYearPickerModeMonthAndYear,  // Display month and year
//    NTMonthYearPickerModeYear           // Display just the year
//} NTMonthYearPickerMode;

enum DbSheetMonthYearPickerMode {
    case MonthAndYear    // Display month and year
    case Year            // Display month and year
}

class DbSheetMonthYearPicker: DbAbstractSheet
{
    internal var pickerView: UIPickerView!
    
    var datePickerMode: DbSheetMonthYearPickerMode = .MonthAndYear
    
    var selectedDate: Date = Date()
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            self.pickerView.selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            self.pickerView.selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var doneBlock: DbMonthYearDoneBlock?
    var cancelBlock: DbMonthYearCancelBlock?
//    var didSelectRowBlock: DbMonthYearDateChangeValueBlock?
    
    private var months: [String]!
    private var years: [Int]!

    
    override init()
    {
        super.init()
        
        self.pickerView = UIPickerView()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.pickerFieldDelegate = self
        self.cancelWhenTouchUpOutside = true
        
        self.commonSetup()
    }
    
    private func commonSetup()
    {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...15 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
//        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
//        self.pickerView.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    @discardableResult
    override func setupContentView() -> UIView?
    {
        // -- Setup selection item --
        if self.datePickerMode == .Year {
            self.pickerView.selectRow(years.index(of: self.selectedDate.db_year)!, inComponent: 0, animated: true)
        } else {
            self.pickerView.selectRow(self.selectedDate.db_month-1, inComponent: 0, animated: false)
            self.pickerView.selectRow(years.index(of: self.selectedDate.db_year)!, inComponent: 1, animated: true)
        }
        
        return self.pickerView
    }
    
    static func initWithTitle(title: String,
                              datePickerMode: DbSheetMonthYearPickerMode = .MonthAndYear,
                              selectedDate: Date = Date(),
                              okTitle: String, cancelTitle: String,
                              doneBlock: @escaping DbMonthYearDoneBlock) -> DbSheetMonthYearPicker
    {
        let picker = DbSheetMonthYearPicker()
        picker.datePickerMode = datePickerMode
        picker.selectedDate = selectedDate
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        picker.doneBlock = doneBlock
        return picker
    }
}

//Mark:- PickerFieldDelegate
extension DbSheetMonthYearPicker: DbAbstractSheetDelegate
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
//        let month = self.pickerView.selectedRow(inComponent: 0) + 1
//        let year = self.years[self.pickerView.selectedRow(inComponent: 1)]
//
//        let chooseDate = Date.init(year: year, month: month, day: 1)
        
        var month = 1
        var year = 2019 // Only Default
        
        if self.datePickerMode == .Year {
            year = self.years[self.pickerView.selectedRow(inComponent: 0)]
        } else {
            month = self.pickerView.selectedRow(inComponent: 0) + 1
            year = self.years[self.pickerView.selectedRow(inComponent: 1)]
        }
        
        self.selectedDate = Date.init(year: year, month: month, day: 1)!
        
        self.doneBlock?(self, self.selectedDate)
    }
    
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
        self.cancelBlock?(self)
    }
}

// Mark:- UIPicker
extension DbSheetMonthYearPicker: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        if self.datePickerMode == .Year {
            return 1
        }
        // MonthAndYear Mode
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if self.datePickerMode == .Year {
            return years.count
        }
        // MonthAndYear Mode
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if self.datePickerMode == .Year {
            return "\(years[row])"
        }

        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // -- Day la xu ly khi vua chon --
//        var month = 1
//        var year = 2019 // Only Default
//
//        if self.datePickerMode == .Year {
//            year = self.years[self.pickerView.selectedRow(inComponent: 0)]
//        } else {
//            month = self.pickerView.selectedRow(inComponent: 0) + 1
//            year = self.years[self.pickerView.selectedRow(inComponent: 1)]
//        }
//
//        self.selectedDate = Date.init(year: year, month: month, day: 1)!
        
//        self.month = month
//        self.year = year
    }
}

