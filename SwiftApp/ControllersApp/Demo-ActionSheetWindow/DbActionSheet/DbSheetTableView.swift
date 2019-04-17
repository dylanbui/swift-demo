//
//  DbSheetTableView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/18/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

/* Demo about use DbAbstractSheet with UITableView
 
 let item_1 = DbItem(id: 1, title: "Giá từ thấp đến cao")
 let item_2 = DbItem(id: 2, title: "Giá từ cao xuống thấp")
 let item_3 = DbItem(id: 3, title: "Diện tích từ nhỏ đến lớn")
 let item_4 = DbItem(id: 4, title: "Diện tích từ lớn đến nhỏ")
 let item_5 = DbItem(id: 5, title: "Ngày tạo mới nhất")
 let arrSortItem = [item_1, item_2, item_3, item_4, item_5]
 
 let sheet = DbSheetTableView.initWithTitle(title: "Chọn từ bảng",
                                rows: arrSortItem,
                                okTitle: "Chọn",
                                cancelTitle: "Bỏ qua")
 
 sheet.didSelectRowBlock = { (_ picker: DbSheetTableView, _ didSelectRow: DbPickerProtocol, indexPath: IndexPath) in
                print("VUA MOI CHON DONG : \(didSelectRow)")
        }
 
 sheet.show()
 
 */

import Foundation

typealias DbSheetTableViewDidSelectRowBlock = (_ picker: DbSheetTableView, _ didSelectRow: DbItemProtocol, _ indexPath: IndexPath) -> Void
typealias DbSheetTableViewCellConfiguration = ([DbItemProtocol], IndexPath, UITableViewCell) -> Void

class DbSheetTableView: DbAbstractSheet
{
    internal var tableView: UITableView!
    
    var separatorColor: UIColor? {
        get {
            return self.tableView.separatorColor
        }
        set {
            self.tableView.separatorColor = newValue
        }
    }
    
    var cellHeight: CGFloat? {
        get {
            return self.tableView.estimatedRowHeight
        }
        set {
            self.tableView.estimatedRowHeight = (newValue != nil ? newValue! : UITableViewAutomaticDimension)
        }
    }
    
    var arrSource: [DbItemProtocol]?
    var didSelectRowBlock: DbSheetTableViewDidSelectRowBlock?
    var cellConfiguration: DbSheetTableViewCellConfiguration?
    
    fileprivate static let cellIdentifier = "DbSheetTableCell"
    fileprivate var reuseIdentifier: String?
    
    override init()
    {
        super.init()
        
        // -- Default height --
        self.fieldHeight = 400
        // -- Default config --
        self.defaultButtonType = .none
        
        self.pickerFieldDelegate = self
        self.cancelWhenTouchUpOutside = true
    }
    
    @discardableResult
    override func setupContentView() -> UIView?
    {
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .clear
        
        return self.tableView        
    }
    
    static func initWithTitle(title: String,
                              rows: [DbItemProtocol],
                              okTitle: String, cancelTitle: String) -> DbSheetTableView
    {
        let picker = DbSheetTableView()
        picker.arrSource = rows
        picker.titleLabel?.text = title
        picker.okButton?.setTitle(okTitle, for: .normal)
        picker.cancelButton?.setTitle(cancelTitle, for: .normal)
        return picker
    }
    
    public func registerCellNib(nib: UINib, forCellReuseIdentifier identifier: String)
    {
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
        self.reuseIdentifier = identifier
    }
    
    public func registerCellString(identifier: String)
    {
        self.registerCellNib(nib: UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}

//Mark:- PickerFieldDelegate
extension DbSheetTableView: DbAbstractSheetDelegate
{
    func sheetPicker(didShowPicker sheetPicker: DbAbstractSheet)
    {
        // print("didShowPicker")
    }

    func sheetPicker(didHidePicker sheetPicker: DbAbstractSheet)
    {
        // print("didHidePicker")
    }
    
    func sheetPicker(didCancelClick sheetPicker: DbAbstractSheet)
    {
        // print("didCancelClick")
    }
    
    func sheetPicker(didOKClick sheetPicker: DbAbstractSheet)
    {
//        if let row = self.pickerView?.selectedRow(inComponent: 0) {
//            self.doneBlock?(self, row, self.arrSource![row])
//        }
    }
}

// Mark:- UITableViewDelegate,UITableViewDataSource
extension DbSheetTableView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell?
        
        if let identifier = self.reuseIdentifier {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        } else {
            // -- Make default cell --
            cell = tableView.dequeueReusableCell(withIdentifier: DbSheetTableView.cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: DbSheetTableView.cellIdentifier)
            }
            
            // -- Fill data to default cell --
            if let item: DbItemProtocol = self.arrSource?[indexPath.row] {
                cell?.textLabel?.text = item.dbItemTitle
                cell?.detailTextLabel?.text = item.dbItemDesc
                cell?.backgroundColor = .clear
                // -- Image config --
//                let image=UIImage(named: country.code)
//                cell.imageView?.image = image
//                cell.imageView?.contentMode = .scaleAspectFill
//                cell.imageView?.layer.cornerRadius = 15
//                cell.imageView?.clipsToBounds=true
            }
        }
        
        // -- Run configuration cell --
        self.cellConfiguration?(self.arrSource ?? [], indexPath, cell!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item: DbItemProtocol = self.arrSource?[indexPath.row] {
            self.didSelectRowBlock?(self, item, indexPath)
        }
        self.dismiss()
    }
}
