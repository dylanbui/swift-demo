//
//  DbSheetMonthYearLimitPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/17/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbMYLPickerDoneBlock = (_ picker: DbSheetMonthYearLimitPicker, _ fromDate: Date, _ toDate: Date) -> Void
typealias DbMYLPickerCancelBlock = (_ picker: DbSheetMonthYearLimitPicker) -> Void
// typealias MYLPickerDidSelectRowBlock = (_ picker: ActionSheetCustomPicker, _ didSelectRow: Int) -> Void

class DbSheetMonthYearLimitPicker: DbSheetCustomPicker
{
    private var arrMonth: [String] = []
    private var arrYear: [String] = []
    
    var selFromDate: Date = Date()
    var selFromRow: (month: Int, year: Int) = (0, 0)
    
    var selToDate: Date = Date().db_adding(.month, value: 1)
    var selToRow: (month: Int, year: Int) = (0, 0)
    
    var sheetDoneBlock: DbMYLPickerDoneBlock?
    var sheetCancelBlock: DbMYLPickerCancelBlock?
    
    override init()
    {
        super.init()
        
        for i in 1...12 {
            self.arrMonth.append("\(i)")
        }
        
        let start = Date().db_year - 5
        let end = Date().db_year
        for i in start...end {
            self.arrYear.append("\(i)")
        }
        
        self.customPickerDelegate = self
        self.pickerFieldDelegate = self
        self.cancelWhenTouchUpOutside = true
    }
    
    override func show()
    {
        super.show()
        
        let fromMonth = self.selFromDate.db_month
        let fromYear = self.selFromDate.db_year
        
        self.selFromRow.month = fromMonth - 1
        if let index = self.arrYear.index(where: { (year) -> Bool in
            return Int(year)! == fromYear
        }) {
            self.selFromRow.year = index
        }
        
        let toMonth = self.selToDate.db_month
        let toYear = self.selToDate.db_year
        
        self.selToRow.month = toMonth - 1
        if let index = self.arrYear.index(where: { (year) -> Bool in
            return Int(year)! == toYear
        }) {
            self.selToRow.year = index
        }
        
        pickerView.selectRow(self.selFromRow.month, inComponent: 0, animated: true)
        pickerView.selectRow(self.selFromRow.year, inComponent: 1, animated: true)
        pickerView.selectRow(self.selToRow.month, inComponent: 3, animated: true)
        pickerView.selectRow(self.selToRow.year, inComponent: 4, animated: true)
    }
    
    static func initWithTitle(title: String,
                              okTitle: String, cancelTitle: String) -> DbSheetMonthYearLimitPicker
    {
        let picker = DbSheetMonthYearLimitPicker()
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        return picker
    }
    
    
//    class func showPicker(withTitle title: String,
//                          withFromDate: Date?,
//                          withToDate: Date?,
//                          done doneBlock: @escaping MYLPickerDoneBlock,
//                          cancel cancelBlock: @escaping MYLPickerCancelBlock, origin originObj:Any) -> Void
//    {
//        let picker: MonthYearLimitPicker = MonthYearLimitPicker()
//
//        let today = Date()
//        picker.selFromDate = withFromDate ?? today
//        picker.selToDate = withToDate ?? today
//
//        picker.title = title
//        picker.titleDone = "Xong"
//        picker.titleCancel = "Hủy"
//
//        picker.doneBlock = doneBlock
//        picker.cancelBlock = cancelBlock
//
//        picker.showPicker(WithOrigin: originObj)
//    }
    
}

//Mark:- PickerFieldDelegate
extension DbSheetMonthYearLimitPicker: DbAbstractSheetDelegate
{
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet)
    {
        let fromM = self.arrMonth[self.selFromRow.month].db_int!
        let fromY = self.arrYear[self.selFromRow.year].db_int!

        let toM = self.arrMonth[self.selToRow.month].db_int!
        let toY = self.arrYear[self.selToRow.year].db_int!

        let fromDate = Date(year: fromY, month: fromM, day: 1)
        let toDate = Date(year: toY, month: toM, day: 1)

        self.sheetDoneBlock?(self, fromDate!, toDate!)
    }
    
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
        self.sheetCancelBlock?(self)
    }
}

// Mark:- UIPicker

extension DbSheetMonthYearLimitPicker: DbSheetCustomPickerDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch component {
        case 0:
            return self.arrMonth.count
        case 1:
            return self.arrYear.count
        case 2:
            return 1
        case 3:
            return self.arrMonth.count
        case 4:
            return self.arrYear.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        switch component {
        case 0:
            return 40
        case 1:
            return 70
        case 2:
            return 80
        case 3:
            return 40
        case 4:
            return 70
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch component {
        case 0:
            let strMonth = "0" + self.arrMonth[row]
            return strMonth.db_substring(from: (strMonth.count - 2)) // tu cuoi lay 2 ky tu
        case 1:
            return self.arrYear[row]
        case 2:
            return "đến"
        case 3:
            let strMonth = "0" + self.arrMonth[row]
            return strMonth.db_substring(from: (strMonth.count - 2)) // tu cuoi lay 2 ky tu
        case 4:
            return self.arrYear[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var scrollBack: Bool = false
        var oldVal: Int = 0
        
        if (component == 0) {
            oldVal = self.selFromRow.month
            self.selFromRow.month = row
            if !self.validateRangeDate() {
                self.selFromRow.month = oldVal
                scrollBack = true
            }
        } else if (component == 1) {
            oldVal = self.selFromRow.year
            self.selFromRow.year = row
            if !self.validateRangeDate() {
                self.selFromRow.year = oldVal
                scrollBack = true
            }
        } else if (component == 3) {
            oldVal = self.selToRow.month
            self.selToRow.month = row
            if !self.validateRangeDate() {
                self.selToRow.month = oldVal
                scrollBack = true
            }
        } else if (component == 4) {
            oldVal = self.selToRow.year
            self.selToRow.year = row
            if !self.validateRangeDate() {
                self.selToRow.year = oldVal
                scrollBack = true
            }
        }
        
        if scrollBack {
            pickerView.selectRow(oldVal, inComponent: component, animated: true)
        }
    }
    
//    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
//    {
//        let fromM = self.arrMonth[self.selFromRow.month].db_int!
//        let fromY = self.arrYear[self.selFromRow.year].db_int!
//
//        let toM = self.arrMonth[self.selToRow.month].db_int!
//        let toY = self.arrYear[self.selToRow.year].db_int!
//
//        let fromDate = Date(year: fromY, month: fromM, day: 1)
//        let toDate = Date(year: toY, month: toM, day: 1)
//
//        self.doneBlock?(self.customPicker!, fromDate!, toDate!)
//    }
//
//    func actionSheetPickerDidCancel(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!)
//    {
//        self.cancelBlock?(self.customPicker!)
//    }
    
    private func validateRangeDate() -> Bool
    {
        let fromM = self.arrMonth[self.selFromRow.month].db_int!
        let fromY = self.arrYear[self.selFromRow.year].db_int!
        
        let toM = self.arrMonth[self.selToRow.month].db_int!
        let toY = self.arrYear[self.selToRow.year].db_int!
        
        if toY > fromY {
            return true
        } else if toY < fromY {
            return false
        }
        
        if toM <= fromM {
            return false
        }
        
        return true
    }
    
}
