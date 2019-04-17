//
//  DbSheetTimeFromToPicker.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/17/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbTFTPickerDoneBlock = (_ picker: DbSheetTimeFromToPicker, _ fromTime: Date, _ toTime: Date) -> Void
typealias DbTFTPickerCancelBlock = (_ picker: DbSheetTimeFromToPicker) -> Void


class DbSheetTimeFromToPicker: DbSheetCustomPicker
{
    
    private var arrHour: [String] = []
    private var arrMinutes: [String] = []
    
    var selFromTime: Date = Date()
    var selFromRow: (hour: Int, minutes: Int) = (0, 0)
    
    var selToTime: Date = Date().db_adding(.minute, value: 60)
    var selToRow: (hour: Int, minutes: Int) = (0, 0)

    var sheetDoneBlock: DbTFTPickerDoneBlock?
    var sheetCancelBlock: DbTFTPickerCancelBlock?
    
    override init()
    {
        super.init()
        
        for i in 0..<24 {
            self.arrHour.append("\(i)")
        }
        
        for i in 0..<60 {
            self.arrMinutes.append("\(i)")
        }

        self.customPickerDelegate = self
        self.pickerFieldDelegate = self
        self.cancelWhenTouchUpOutside = true
    }
    
    @discardableResult
    override func setupContentView() -> UIView?
    {
        return super.setupContentView()
    }
    
    static func initWithTitle(title: String,
                              fromTime: Date = Date(),
                              toTime: Date = Date().db_adding(.minute, value: 60),
                              okTitle: String, cancelTitle: String) -> DbSheetTimeFromToPicker
    {
        let picker = DbSheetTimeFromToPicker()
        picker.selFromTime = fromTime
        picker.selToTime = toTime
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        return picker
    }
    
    
    override func show()
    {
        super.show()
        
        let fromHour = self.selFromTime.db_hour
        let fromMin = self.selFromTime.db_minute
        let toHour = self.selToTime.db_hour
        let toMin = self.selToTime.db_minute
        
        self.selFromRow = (fromHour, fromMin)
        self.selToRow = (toHour, toMin)
        
        self.pickerView.selectRow(fromHour, inComponent: 0, animated: true)
        self.pickerView.selectRow(fromMin, inComponent: 2, animated: true)
        self.pickerView.selectRow(toHour, inComponent: 4, animated: true)
        self.pickerView.selectRow(toMin, inComponent: 6, animated: true)
    }
    
}

//Mark:- PickerFieldDelegate
extension DbSheetTimeFromToPicker: DbAbstractSheetDelegate
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
//        if let row = self.pickerView?.selectedRow(inComponent: 0) {
//            self.doneBlock?(self, row, self.arrSource![row])
//        }
        
        self.sheetDoneBlock?(self, self.selFromTime, self.selToTime)
    }
    
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
//        self.cancelBlock?(self)
        self.sheetCancelBlock?(self)
    }
}

// Mark:- UIPicker

extension DbSheetTimeFromToPicker: DbSheetCustomPickerDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 7
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch component {
        case 0:
            return self.arrHour.count
        case 1:
            return 1
        case 2:
            return self.arrMinutes.count
        case 3:
            return 1
        case 4:
            return self.arrHour.count
        case 5:
            return 1
        case 6:
            return self.arrMinutes.count
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
            return 20
        case 2:
            return 40
        case 3:
            return 60
        case 4:
            return 40
        case 5:
            return 20
        case 6:
            return 40
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch component {
        case 0:
            let strHour = "0" + self.arrHour[row]
            return strHour.db_substring(from: (strHour.count - 2)) // tu cuoi lay 2 ky tu
        case 1:
            return ":"
        case 2:
            let strMinutes = "0" + self.arrMinutes[row]
            return strMinutes.db_substring(from: (strMinutes.count - 2)) // tu cuoi lay 2 ky tu
        case 3:
            return "đến"
        case 4:
            let strHour = "0" + self.arrHour[row]
            return strHour.db_substring(from: (strHour.count - 2)) // tu cuoi lay 2 ky tu
        case 5:
            return ":"
        case 6:
            let strMinutes = "0" + self.arrMinutes[row]
            return strMinutes.db_substring(from: (strMinutes.count - 2)) // tu cuoi lay 2 ky tu
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var currFromTime = Date(unixTimestamp: self.selFromTime.db_unixTimestamp)
        var currToTime = Date(unixTimestamp: self.selToTime.db_unixTimestamp)
        
        if component == 0 { // Hour
            currFromTime.db_hour = self.arrHour[row].db_int ?? 0
            
            if self.validate(fromDate: currFromTime, toDate: currToTime) {
                self.selFromTime = currFromTime
                self.selFromRow.hour = row
            } else {
                pickerView.selectRow(self.selFromRow.hour, inComponent: component, animated: true)
            }
            
        } else if component == 2 { // Minutes
            currFromTime.db_minute = self.arrMinutes[row].db_int ?? 0
            
            if self.validate(fromDate: currFromTime, toDate: currToTime) {
                self.selFromTime = currFromTime
                self.selFromRow.minutes = row
            } else {
                pickerView.selectRow(self.selFromRow.minutes, inComponent: component, animated: true)
            }
            
        } else if component == 4 {
            currToTime.db_hour = self.arrHour[row].db_int ?? 0
            
            if self.validate(fromDate: currFromTime, toDate: currToTime) {
                self.selToTime = currToTime
                self.selToRow.hour = row
            } else {
                pickerView.selectRow(self.selToRow.hour, inComponent: component, animated: true)
            }
            
        } else if component == 6 {
            currToTime.db_minute = self.arrMinutes[row].db_int ?? 0
            
            if self.validate(fromDate: currFromTime, toDate: currToTime) {
                self.selToTime = currToTime
                self.selToRow.minutes = row
            } else {
                pickerView.selectRow(self.selToRow.minutes, inComponent: component, animated: true)
            }
            
        }
    }
    
    private func validate(fromDate: Date, toDate: Date) -> Bool
    {
        let range = toDate.db_unixTimestamp - fromDate.db_unixTimestamp
        if range >= 60*60 { // Cach nhau 1h
            return true
        }
        return false
    }
    
    
}
