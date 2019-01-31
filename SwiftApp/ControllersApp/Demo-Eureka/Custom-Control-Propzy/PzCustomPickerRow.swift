//
//  PzCustomPickerRow.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/31/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import Eureka

class PzCustomPickerCell: _FieldCell<String>, CellType
{
    public var arrSources: [DbItemProtocol] = []
    public var itemSelected: DbItemProtocol?
    
    private var btn: UIButton!
    
    private var picker: DbSheetPicker!
    
    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    open override func setup()
    {
        super.setup()
        
        // -- Tap on uitextfield action --
        textField.onTap { (tapGestureRecognizer) in
            self.showPickerView()
        }
        
        // -- Add icon to right --
        //        self.textField.rightViewMode = UITextFieldViewMode.always
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //        let image = UIImage.arrowDown(UIColor.init(95, 95, 95, 0.8))
        //        imageView.image = image
        //        self.textField.rightView = imageView
    }
    
    // -- Doi voi custom control, phai chu y ham update, dua gia tri thay doi can hien vao ham update nay mooi xu ly duoc --
    override func update()
    {
        super.update()

        if let item = self.itemSelected {
            self.textField.text = item.dbItemTitle
        }
    }
    
    // -- Select row action --
    override func didSelect()
    {
        super.didSelect()
    }
    
    // -- Disable textField editing --
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return false
    }
    
    private func showPickerView()
    {
        // -- Return if == 0 --
        if self.arrSources.count <= 0 { return }
        
        // -- Cach khac --
//        var selectedIndex = 0
//        if let item = self.itemSelected {
//            if let index = self.arrSources.index(where: { (tuple) -> Bool in
//                return tuple.dbItemId == item.dbItemId
//            }) {
//                selectedIndex = index
//            }
//        }
        
        picker = DbSheetPicker.initWithTitle(title: self.titleLabel?.text ?? "",
                                                 rows: self.arrSources,
                                                 initialSelections: self.itemSelected,
                                                 okTitle: "Chọn",
                                                 cancelTitle: "Bỏ qua")
        picker.cancelWhenTouchUpOutside = true
        picker.defaultButtonsAxis = .horizontal
        picker.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) in
            // print("Gia tri vua chon : \(selectedValue.dbItemTitle)")
            // -- Khong cap nhat duoc textfield o day, co le do picker hien bang rootViewController --
            // nen khi an control no se chay ham update cua eureka, se load lai du lieu cu
            // nen phai cap nhat gia tri trong "override func update()"
            //self.textField.text = "khong cap nhat duoc"
            self.itemSelected = selectedValue
        }
        
        picker.cancelBlock = { (_ picker: DbSheetPicker) in
            // print("Bo qua chon")
        }
        
        picker.show()
        
        // -- Scroll to middle when active --
        self.row.select(animated: true, scrollPosition: .middle)
    }
    
    func reloadData(_ source: [DbItemProtocol] = []) -> Void
    {
        self.arrSources = source
        // -- reset data --
        self.itemSelected = nil
        self.row.value = nil
        self.textField.text = nil
    }
    
    
}

/// A String valued row where the user can enter arbitrary text.
final class PzCustomPickerRow: FieldRow<PzCustomPickerCell>, RowType
{
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
