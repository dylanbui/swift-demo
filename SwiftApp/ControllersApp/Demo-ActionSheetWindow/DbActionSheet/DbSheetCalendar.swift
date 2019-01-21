//
//  DbSheetCalendar.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/18/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbSheetCalendarMultiChoose = ([Date]) -> Void
typealias DbSheetCalendarSingleChoose = (Date) -> Void
typealias DbSheetCalendarCancel = () -> Void

enum DbSheetCalendarViewType {
    case selectionTypeSingle
    case selectionTypeMulti
    case selectionTypeRange
}

class DbSheetCalendar: DbAbstractSheet
{
    internal var fsCalendar: FSCalendar!
    
    public var handleSingleChoosed: DbSheetCalendarSingleChoose?
    public var handleMultiChoosed: DbSheetCalendarMultiChoose?
    public var handleCancel: DbSheetCalendarCancel?
    
    var minimumDate: Date? = nil
    var maximumDate: Date? = nil
    
    var selectionType: DbSheetCalendarViewType! {
        didSet {
            if self.selectionType == .selectionTypeSingle {
                self.fsCalendar.allowsMultipleSelection = false
                self.fsCalendar.swipeToChooseGesture.isEnabled = false // Swipe-To-Choose
            } else if self.selectionType == .selectionTypeMulti
                || self.selectionType == .selectionTypeRange {
                self.fsCalendar.allowsMultipleSelection = true
                self.fsCalendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
            }
        }
    }
    
    var selectDate: Date? {
        didSet {
            if self.selectDate != nil {
                self.fsCalendar.select(self.selectDate)
            }
        }
    }

    // -- For type : selectionTypeRange --
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    override init()
    {
        super.init()
        
        // -- Full content --
        self.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.fsCalendar = FSCalendar.init(frame: CGRect.zero)
        self.fsCalendar.delegate = self
//        self.fsCalendar.dataSource = self
        
        self.fsCalendar.calendarHeaderView.backgroundColor = UIColor.white
        
        self.fsCalendar.locale = Locale(identifier: "vi")
        self.fsCalendar.calendarHeaderView.calendar.locale = Locale(identifier: "vi")
        self.fsCalendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        self.fsCalendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        self.fsCalendar.appearance.headerDateFormat = "M/YYYY"
        
        self.fsCalendar.appearance.headerTitleColor = UIColor(95, 95, 95)
        self.fsCalendar.appearance.titleWeekendColor = UIColor(95, 95, 95)
        self.fsCalendar.appearance.weekdayTextColor = UIColor(95, 95, 95)
        
        self.fsCalendar.appearance.titleDefaultColor = UIColor(0, 0, 0, 0.54) // Xam
        self.fsCalendar.appearance.titleTodayColor = UIColor(241, 116, 35) // Cam
        self.fsCalendar.appearance.eventSelectionColor = UIColor.white
        self.fsCalendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        // self.fsCalendar.today = nil // Hide the today circle
        // self.fsCalendar.register(FormatCalendarCell.self, forCellReuseIdentifier: "cell")
        self.fsCalendar.clipsToBounds = true // Remove top/bottom line
        
        // -- Default Single Type --
        self.selectionType = .selectionTypeSingle
        
        // -- Delegate Sheet --
        self.pickerFieldDelegate = self
    }
    
    override func setupContentView() -> UIView?
    {
        self.fieldHeight = 350.0

        return self.fsCalendar
    }
    
}

//Mark:- PickerFieldDelegate
extension DbSheetCalendar: DbAbstractSheetDelegate
{
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
        // print("didCancelClick")
        self.handleCancel?()
    }
    
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet)
    {
        if self.selectionType == .selectionTypeSingle {
            self.handleSingleChoosed?(self.fsCalendar.selectedDate ?? Date())
            return
        }
        if self.selectionType == .selectionTypeMulti
            || self.selectionType == .selectionTypeRange {
            self.handleMultiChoosed?(self.fsCalendar.selectedDates)
            return
        }
    }
}

extension DbSheetCalendar: FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        if self.selectionType == .selectionTypeRange {
            // nothing selected:
            if firstDate == nil {
                firstDate = date
                return
            }
            
            // only first date is selected:
            if firstDate != nil && lastDate == nil {
                // handle the case of if the last date is less than the first date:
                if date <= firstDate! {
                    calendar.deselect(firstDate!)
                    firstDate = date
                    return
                }
                
                //let range = datesRange(from: firstDate!, to: date)
                let range = firstDate!.db_datesRange(to: date)
                lastDate = range.last
                for d in range {
                    calendar.select(d)
                }
                return
            }
            
            // both are selected:
            if firstDate != nil && lastDate != nil {
                for d in calendar.selectedDates {
                    calendar.deselect(d)
                }
                lastDate = nil
                firstDate = nil
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        if self.selectionType == .selectionTypeRange {
            // both are selected:
            // NOTE: the is a REDUANDENT CODE:
            if firstDate != nil && lastDate != nil {
                for d in calendar.selectedDates {
                    calendar.deselect(d)
                }
                
                lastDate = nil
                firstDate = nil
            }
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        if self.minimumDate != nil {
            return self.minimumDate!
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: String("1970-01-01"))!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date
    {
        if self.maximumDate != nil {
            return self.maximumDate!
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: String("2099-12-31"))!
    }
}
