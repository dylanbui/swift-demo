//
//  DbSheetMonthYearPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/25/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

typealias DbMonthYearDoneBlock = (_ picker: DbSheetMonthYearPicker, _ selectedDate: Date) -> Void
typealias DbMonthYearCancelBlock = (_ picker: DbSheetMonthYearPicker) -> Void

enum DbSheetMonthYearPickerMode {
    case MonthAndYear    // Display month and year
    case Year            // Display month and year
}

class DbSheetMonthYearPicker: DbAbstractSheet
{
    internal var pickerView: UIPickerView!
    
    var datePickerMode: DbSheetMonthYearPickerMode = .MonthAndYear
    
    var selectedDate: Date = Date()
    
    // Important: willSet and didSet observers are not called when a property is first initialized. They are only called when the property’s value is set outside of an initialization context.
    
    var minimumDate: Date? {
        didSet {
            if let minimumDate = self.minimumDate {
                self.minDate = (month: minimumDate.db_month, year: minimumDate.db_year)
            } else {
                self.minDate = (month: 1, year: Date().db_year)
            }
        }
    }
    var maximumDate: Date? {
        didSet {
            if let maximumDate = self.maximumDate {
                self.maxDate = (month: maximumDate.db_month, year: maximumDate.db_year)
            } else {
                self.maxDate = (month: 1, year: Date().db_year + 10)
            }
        }
    }
    
    private var minDate = (month: 1, year: Date().db_year)
    private var maxDate = (month: 1, year: Date().db_year + 10)
    
    var doneBlock: DbMonthYearDoneBlock?
    var cancelBlock: DbMonthYearCancelBlock?
    
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
    }
    
    private func commonSetup()
    {
        // population years
        var years: [Int] = []
        // Validate data
        if self.maxDate.year > self.minDate.year {
            for i: Int in self.minDate.year...self.maxDate.year {
                years.append(i)
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
    }
    
    private func reloadSelectionData(_ date: Date, animated: Bool = false)
    {
        // -- Setup selection item --
        if self.datePickerMode == .Year {
            self.pickerView.selectRow(self.years.index(of: date.db_year)!, inComponent: 0, animated: animated)
        } else {
            self.pickerView.selectRow(date.db_month-1, inComponent: 0, animated: true)
            self.pickerView.selectRow(self.years.index(of: date.db_year)!, inComponent: 1, animated: animated)
        }
    }
    
    private func compareMonthYear(_ fromDate: Date, _ toDate: Date) -> ComparisonResult
    {
        var comps = Calendar.current.dateComponents([.year, .month], from: fromDate)
        let date_1 = Calendar.current.date(from: comps)
        
        comps = Calendar.current.dateComponents([.year, .month], from: toDate)
        let date_2 = Calendar.current.date(from: comps)
        
        return date_1!.compare(date_2!)
    }
    
    @discardableResult
    override func setupContentView() -> UIView?
    {
        // -- Setup --
        self.commonSetup()
        
        // -- Selection --
        self.reloadSelectionData(self.selectedDate)
        
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
        
        // -- Default choose range --
        picker.minimumDate = Date().db_adding( .year, value: -5)
        picker.maximumDate = Date().db_adding( .year, value: 5)
        
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        picker.doneBlock = doneBlock
        return picker
    }
}

// Mark:- PickerFieldDelegate
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
        var month = 1
        var year = 2019 // Only Default

        if self.datePickerMode == .Year {
            year = self.years[self.pickerView.selectedRow(inComponent: 0)]
        } else {
            month = self.pickerView.selectedRow(inComponent: 0) + 1
            year = self.years[self.pickerView.selectedRow(inComponent: 1)]
        }

        let selectedDate = Date.init(year: year, month: month, day: 1)!
        
        if self.datePickerMode == .MonthAndYear {
            if self.compareMonthYear(selectedDate, self.minimumDate!) == .orderedAscending { // Giam dan
                // -- Selection --
                self.reloadSelectionData(self.selectedDate, animated: true)
                return
            }
        }
        
        self.selectedDate = selectedDate
    }
}

