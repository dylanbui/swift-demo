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
    private var fsCalendar: FSCalendar!
    
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
    
    
    override init()
    {
        super.init()
        
        self.fsCalendar = FSCalendar.init(frame: CGRect.zero)
//        self.fsCalendar.delegate = self
//        self.fsCalendar.dataSource = self
        
        // Do any additional setup after loading the view.
        //        calendar.allowsMultipleSelection = true
        //        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        self.fsCalendar.calendarHeaderView.backgroundColor = UIColor.white
        
        self.fsCalendar.locale = Locale(identifier: "vi")
        self.fsCalendar.calendarHeaderView.calendar.locale = Locale(identifier: "vi")
        self.fsCalendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        self.fsCalendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        self.fsCalendar.appearance.headerDateFormat = "M - YYYY"
        
        self.fsCalendar.appearance.headerTitleColor = UIColor(95, 95, 95)
        self.fsCalendar.appearance.titleWeekendColor = UIColor(95, 95, 95)
        self.fsCalendar.appearance.weekdayTextColor = UIColor(95, 95, 95)
        
        self.fsCalendar.appearance.titleDefaultColor = UIColor(0, 0, 0, 0.54) // Xam
        self.fsCalendar.appearance.titleTodayColor = UIColor(241, 116, 35) // Cam
        self.fsCalendar.appearance.eventSelectionColor = UIColor.white
        self.fsCalendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        // calendar.today = nil // Hide the today circle
        // calendar.register(FormatCalendarCell.self, forCellReuseIdentifier: "cell")
        self.fsCalendar.clipsToBounds = true // Remove top/bottom line
        
        // -- Default Single Type --
        self.selectionType = .selectionTypeSingle
        
        // -- Delegate Sheet --
        self.pickerFieldDelegate = self
    }
    
    override func setupContentView()
    {
        self.fieldHeight = 300.0

        
        self.contentView?.addSubview(self.fsCalendar)
        self.addConstraint(self.fsCalendar, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    
}

//Mark:- PickerFieldDelegate
extension DbSheetCalendar: DbAbstractSheetDelegate
{
    func pickerField(didCancelClick pickerField: DbAbstractSheet)
    {
        print("didCancelClick")
    }
    
    func pickerField(didOKClick pickerField: DbAbstractSheet)
    {
        if self.selectionType == .selectionTypeSingle {
            self.handleSingleChoosed?(self.fsCalendar.selectedDate ?? Date())
            return
        }
    }
}
