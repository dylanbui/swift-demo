//
//  DbSheetCollectionView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/18/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

typealias DbSheetCollectionViewDidSelectCellBlock = (_ picker: DbSheetCollectionView, _ didSelectRow: DbItemProtocol, _ indexPath: IndexPath) -> Void


class DbSheetCollectionView: DbAbstractSheet
{
    private var collectionView: UICollectionView!
    
    var arrSource: [DbItemProtocol]?
    var didSelectCellBlock: DbSheetCollectionViewDidSelectCellBlock?
    
    override init()
    {
        super.init()
        
        self.pickerFieldDelegate = self
    }
    
    override func setupContentView()
    {
        // -- Default config --
        self.hideButtons = true
        self.fieldHeight = 300
        self.cancelWhenTouchUpOutside = true
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // -- Add to contentView --
        self.contentView?.addSubview(self.collectionView)
        // -- Add constraint for tableView --
        addConstraint(self.collectionView, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    static func initWithTitle(title: String,
                              rows: [DbItemProtocol]) -> DbSheetCollectionView
    {
        let picker = DbSheetCollectionView()
        picker.arrSource = rows
        picker.titleLabel?.text = title
        return picker
    }
}

// Mark:- PickerFieldDelegate
extension DbSheetCollectionView: DbAbstractSheetDelegate
{
    func pickerField(didShowPicker pickerField: DbAbstractSheet)
    {
        // print("didShowPicker")
    }
    
    func pickerField(didHidePicker pickerField: DbAbstractSheet)
    {
        // print("didHidePicker")
    }
    
    func pickerField(didCancelClick pickerField: DbAbstractSheet)
    {
        // print("didCancelClick")
    }
    
    func pickerField(didOKClick pickerField: DbAbstractSheet)
    {
        //        if let row = self.pickerView?.selectedRow(inComponent: 0) {
        //            self.doneBlock?(self, row, self.arrSource![row])
        //        }
    }
}

// Mark: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DbSheetCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let item = self.arrSource?[indexPath.row]  {
            if let color = item.dbRawValue as? Color {
                cell.backgroundColor = color.color
            }
        }
        cell.contentView.layer.cornerRadius=16
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let item = self.arrSource?[indexPath.row] {
            self.didSelectCellBlock?(self, item, indexPath)
        }
        self.dismiss()
    }
    
}
