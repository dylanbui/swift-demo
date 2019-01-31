//
//  DemoActionSheetWindowViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoDbSheetPickerViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "DbSheetPicker"
    }

    @IBAction func customPickerHorizontal_Click(_ sender: UIButton)
    {
        // DbTopAlertController.alert("Hien ra di chaaaa")
//        DbTopAlertController.alert("Hien ra ne", message: "Hine cai gi day", acceptMessage: "Chon di") {
//            print("No moi chon roi")
//        }
        
        
        
        // let alert = DbTopAlertController(title: "Your title", message: "Your message", preferredStyle: .alert)
        let alert = DbTopAlertController(title: "Your title 1", message: "Your message 1", preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in
            alert.dismiss(animated: true, completion: {
                print("DbTopAlertController - DISMISS")
            })
        }
        alert.addAction(cancelButton)

        alert.show(animated: true) {
            print("DbTopAlertController - SHOW")
        }
        
        //UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        
        
//        let item_1 = DbItem(id: 1, title: "Giá từ thấp đến cao")
//        let item_2 = DbItem(id: 2, title: "Giá từ cao xuống thấp")
//        let item_3 = DbItem(id: 3, title: "Diện tích từ nhỏ đến lớn")
//        let item_4 = DbItem(id: 4, title: "Diện tích từ lớn đến nhỏ")
//        let item_5 = DbItem(id: 5, title: "Ngày tạo mới nhất")
//        let arrSortItem = [item_1, item_2, item_3, item_4, item_5]
//
//        let picker = DbSheetPicker.initWithTitle(title: "Sắp xếp dữ liệu",
//                                                 rows: arrSortItem,
//                                                 initialSelections: nil,
//                                                 okTitle: "Đồng ý",
//                                                 cancelTitle: "Bỏ qua")
//        picker.anchorControl = sender
//        picker.customButtonsAxis = .horizontal
//        picker.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) in
//            print("Gia tri vua chon : \(selectedValue.dbItemTitle)")
//        }
//
//        picker.cancelBlock = { (_ picker: DbSheetPicker) in
//            print("Bo qua chon")
//        }
//
//        picker.didSelectRowBlock = { (_ picker: DbSheetPicker, _ didSelectRow: Int) in
//            print("VUA MOI CHON DONG : \(didSelectRow)")
//        }
//        picker.show()
    }
    
    @IBAction func customPickerVertical_Click(_ sender: UIButton)
    {
        let alert = DbTopAlertController(title: "Your title 2", message: "Your message2 ", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in
            alert.dismiss(animated: true, completion: {
                print("DbTopAlertController - DISMISS - 2")
            })
        }
        alert.addAction(cancelButton)
        
        alert.show(animated: true) {
            print("DbTopAlertController - SHOW - 2")
        }
        
//        let item_1 = DbItem(id: 1, title: "Giá từ thấp đến cao")
//        let item_2 = DbItem(id: 2, title: "Giá từ cao xuống thấp")
//        let item_3 = DbItem(id: 3, title: "Diện tích từ nhỏ đến lớn")
//        let item_4 = DbItem(id: 4, title: "Diện tích từ lớn đến nhỏ")
//        let item_5 = DbItem(id: 5, title: "Ngày tạo mới nhất")
//        let arrSortItem = [item_1, item_2, item_3, item_4, item_5]
//
//        let picker = DbSheetPicker.initWithTitle(title: "Sắp xếp dữ liệu",
//                                                 rows: arrSortItem,
//                                                 initialSelections: nil,
//                                                 okTitle: "Đồng ý",
//                                                 cancelTitle: "Bỏ qua")
//        picker.anchorControl = sender
//        picker.defaultButtonsAxis = .vertical
//        picker.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) in
//            print("Gia tri vua chon : \(selectedValue.dbItemTitle)")
//        }
//
//        picker.cancelBlock = { (_ picker: DbSheetPicker) in
//            print("Bo qua chon")
//        }
//
//        picker.didSelectRowBlock = { (_ picker: DbSheetPicker, _ didSelectRow: Int) in
//            print("VUA MOI CHON DONG : \(didSelectRow)")
//        }
//        picker.show()
    }
    
    @IBAction func datePicker_Click(_ sender: UIButton)
    {
        let sheetDate = DbSheetDatePicker.initWithTitle(title: "Chọn ngày tháng",
                                                        datePickerMode: .date,
                                                        okTitle: "Chọn", cancelTitle: "Bỏ qua")
        { (sheetDatePicker, selectedDate) in
            print("selectedDate = \(String(describing: selectedDate))")

        }
        sheetDate.show()
    }
    
    @IBAction func monthYearPicker_Click(_ sender: UIButton)
    {
        let sheetDate = DbSheetMonthYearPicker.initWithTitle(title: "Chọn tháng năm",
                                                             datePickerMode: .MonthAndYear,
                                                             okTitle: "Chọn", cancelTitle: "Bỏ qua")
        { (sheetDatePicker, selectedDate) in
            print("DbSheetMonthYearPicker selectedDate = \(String(describing: selectedDate))")
            
        }
        sheetDate.show()
    }
    
    @IBAction func tableviewPicker_Click(_ sender: UIButton)
    {
        let item_1 = DbItem(id: 1, title: "Giá từ thấp đến cao", desc: "Giá từ thấp đến cao")
        let item_2 = DbItem(id: 2, title: "Giá từ cao xuống thấp", desc: "Giá từ cao xuống thấp")
        let item_3 = DbItem(id: 3, title: "Diện tích từ nhỏ đến lớn", desc: "Diện tích từ nhỏ đến lớn")
        let item_4 = DbItem(id: 4, title: "Diện tích từ lớn đến nhỏ", desc: "Diện tích từ lớn đến nhỏ")
        let item_5 = DbItem(id: 5, title: "Ngày tạo mới nhất", desc: "Ngày tạo mới nhất")
        let arrSortItem = [item_1, item_2, item_3, item_4, item_5]

        let sheet = DbSheetTableView.initWithTitle(title: "Sắp xếp dữ liệu",
                                          rows: arrSortItem,
                                          okTitle: "Chọn",
                                          cancelTitle: "Bỏ qua")
        sheet.didSelectRowBlock = { (_ picker: DbSheetTableView, _ didSelectRow: DbItemProtocol, indexPath: IndexPath) in
            print("VUA MOI CHON DONG : \(didSelectRow)")
        }
        sheet.show()
    }

    @IBAction func collectionviewPicker_Click(_ sender: UIButton)
    {
        let arrSortItem = [
            DbItem(id: 1, title: "red", desc: "red", raw: Color(title: "red", color: UIColor.red)),
            DbItem(id: 2, title: "black", desc: "black", raw: Color(title: "black", color: UIColor.black)),
            DbItem(id: 3, title: "blue", desc: "blue", raw: Color(title: "blue", color: UIColor.blue)),
            DbItem(id: 4, title: "brown", desc: "brown", raw: Color(title: "brown", color: UIColor.brown)),
            DbItem(id: 5, title: "cyan", desc: "cyan", raw: Color(title: "cyan", color: UIColor.cyan)),
            DbItem(id: 6, title: "darkGray", desc: "darkGray", raw: Color(title: "darkGray", color: UIColor.darkGray)),
            DbItem(id: 7, title: "green", desc: "green", raw: Color(title: "green", color: UIColor.green)),
            DbItem(id: 8, title: "magenta", desc: "magenta", raw: Color(title: "magenta", color: UIColor.magenta)),
            DbItem(id: 9, title: "yellow", desc: "yellow", raw: Color(title: "yellow", color: UIColor.yellow)),
            DbItem(id: 10, title: "orange", desc: "orange", raw: Color(title: "orange", color: UIColor.orange)),
            DbItem(id: 11, title: "purple", desc: "purple", raw: Color(title: "purple", color: UIColor.purple)),
            DbItem(id: 12, title: "green", desc: "green", raw: Color(title: "green", color: UIColor.green))
        ]
        
        let sheet = DbSheetCollectionView.initWithTitle(title: "Chọn từ bảng",
                                                        rows: arrSortItem)
        sheet.didSelectCellBlock = { (_ picker: DbSheetCollectionView, _ didSelectRow: DbItemProtocol, indexPath: IndexPath) in
            print("VUA MOI CHON DONG : \(didSelectRow)")
        }
        sheet.show()
    }
    
    @IBAction func fscalendarPicker_Click(_ sender: UIButton)
    {
        let sheet = DbSheetCalendar()
        // sheet.selectionType = .selectionTypeSingle
        // sheet.selectionType = .selectionTypeMulti
        sheet.selectionType = .selectionTypeRange
//        sheet.handleSingleChoosed = { selectedDate in
//            print("\(String(describing: selectedDate))")
//        }
        sheet.handleMultiChoosed = { arrSelectedDate in
            print("\(String(describing: arrSelectedDate))")
        }
        sheet.show()
    }

    @IBAction func customButtonPicker_Click(_ sender: UIButton)
    {
        let item_1 = DbItem(id: 1, title: "Giá từ thấp đến cao")
        let item_2 = DbItem(id: 2, title: "Giá từ cao xuống thấp")
        let item_3 = DbItem(id: 3, title: "Diện tích từ nhỏ đến lớn")
        let item_4 = DbItem(id: 4, title: "Diện tích từ lớn đến nhỏ")
        let item_5 = DbItem(id: 5, title: "Ngày tạo mới nhất")
        let arrSortItem = [item_1, item_2, item_3, item_4, item_5]
        
        let picker = DbSheetPicker.initWithTitle(title: "Sắp xếp dữ liệu",
                                                 rows: arrSortItem,
                                                 initialSelections: nil,
                                                 okTitle: "Đồng ý",
                                                 cancelTitle: "Bỏ qua")
        picker.anchorControl = sender
        picker.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) in
            print("Gia tri vua chon : \(selectedValue.dbItemTitle)")
        }
        
        picker.cancelBlock = { (_ picker: DbSheetPicker) in
            print("Bo qua chon")
        }
        
        picker.didSelectRowBlock = { (_ picker: DbSheetPicker, _ didSelectRow: Int) in
            print("VUA MOI CHON DONG : \(didSelectRow)")
        }
        
        let button_1 = UIButton(type: .system)
        button_1.titleLabel?.textColor = UIColor.red
        button_1.tintColor = UIColor.red
        button_1.setTitle("Destructor", for: .normal)
        _ = button_1.on(.touchUpInside) { (button) in
            picker.dismiss()
            print("Chon loai 1")
        }

        let button_2 = UIButton(type: .system)
        button_2.setTitle("Select All", for: .normal)
        _ = button_2.on(.touchUpInside) { (button) in
            picker.dismiss()
            print("Select All")
        }

        picker.customButtons = [button_1, button_2]        
        picker.show()

    }
    
    
}


