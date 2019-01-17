//
//  DemoActionSheetWindowViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

struct Color {
    let title:String
    let color:UIColor
}

struct Country {
    let code: String
    let name: String
}


class DemoActionSheetWindowViewController: UIViewController
{
    var countries=[Country]()
    let states = ["Alaska",
                  "Alabama",
                  "Arkansas",
                  "American Samoa",
                  "Arizona",
                  "California",
                  "Colorado",
                  "Connecticut",
                  "District of Columbia",
                  "Delaware",
                  "Florida",
                  "Georgia",
                  "Guam",
                  "Hawaii",
                  "Iowa",
                  "Idaho",
                  "Illinois",
                  "Indiana",
                  "Kansas",
                  "Kentucky",
                  "Louisiana",
                  "Massachusetts",
                  "Maryland",
                  "Maine",
                  "Michigan",
                  "Minnesota",
                  "Missouri",
                  "Mississippi",
                  "Montana",
                  "North Carolina",
                  " North Dakota",
                  "Nebraska",
                  "New Hampshire",
                  "New Jersey",
                  "New Mexico",
                  "Nevada",
                  "New York",
                  "Ohio",
                  "Oklahoma",
                  "Oregon",
                  "Pennsylvania",
                  "Puerto Rico",
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Virginia",
                  "Virgin Islands",
                  "Vermont",
                  "Washington",
                  "Wisconsin",
                  "West Virginia",
                  "Wyoming"]
    let colors=[
        Color(title: "red", color: UIColor.red),
        Color(title: "black", color: UIColor.black),
        Color(title: "blue", color: UIColor.blue),
        Color(title: "brown", color: UIColor.brown),
        Color(title: "cyan", color: UIColor.cyan),
        Color(title: "darkGray", color: UIColor.darkGray),
        Color(title: "green", color: UIColor.green),
        Color(title: "magenta", color: UIColor.magenta),
        Color(title: "yellow", color: UIColor.yellow),
        Color(title: "orange", color: UIColor.orange),
        Color(title: "purple", color: UIColor.purple),
        Color(title: "green", color: UIColor.lightGray)
    ]

    
    @IBOutlet weak var pickerViewField: PickerField!
    @IBOutlet weak var datePickerField: PickerField!
    @IBOutlet weak var tabelViewField: PickerField!
    @IBOutlet weak var collectionViewField: PickerField!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupPickerViewField()
        setupDatePickerField()
        setupTableViewField()
        setupCollectionViewField()
    }

    @IBAction func pickerClick(_ sender: UIButton)
    {
        let item_1 = DbPickerItem(iId: 1, desc: "Giá từ thấp đến cao")
        let item_2 = DbPickerItem(iId: 2, desc: "Giá từ cao xuống thấp")
        let item_3 = DbPickerItem(iId: 3, desc: "Diện tích từ nhỏ đến lớn")
        let item_4 = DbPickerItem(iId: 4, desc: "Diện tích từ lớn đến nhỏ")
        let item_5 = DbPickerItem(iId: 5, desc: "Ngày tạo mới nhất")
        let arrSortItem = [item_1, item_2, item_3, item_4, item_5]

        
        let sheet = DbSheetPicker.initWithTitle(title: "Chọn quốc gia",
                                          rows: arrSortItem,
                                          initialSelections: DbPickerItem(iId: 4, desc: "Diện tích từ lớn đến nhỏ"),
                                          okTitle: "Đồng ý",
                                          cancelTitle: "Bỏ qua")
        sheet.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbPickerProtocol) in
            print("Gia tri vua chon : \(selectedValue.dbPickerItemTitle)")
        }
        
        sheet.cancelBlock = { (_ picker: DbSheetPicker) in
            print("Bo qua chon")
        }
        
        sheet.didSelectRowBlock = { (_ picker: DbSheetPicker, _ didSelectRow: Int) in
            print("VUA MOI CHON DONG : \(didSelectRow)")
        }
        sheet.show()
        
        return
        
//        let picker = PickerField()
//
//        picker.type = .pickerView
//        picker.pickerView?.dataSource=self
//        picker.pickerView?.delegate=self
//        picker.titleLabel?.text="select a state 1111"
//        picker.pickerFieldDelegate = self
//
//        picker.show()
        
//        let picker = DbAbstractPicker()
//
//        picker.type = .pickerView
//        picker.pickerView?.dataSource=self
//        picker.pickerView?.delegate=self
//        picker.titleLabel?.text="select a state 1111"
//
//        picker.show()
        
        // self.pickerViewField.show()
        

        let picker = DbSheetPicker.initWithTitle(title: "Chon quoc gia",
                                                 rows: arrSortItem,
                                                 initialSelections: nil,
                                                 okTitle: "Dong y",
                                                 cancelTitle: "Bo qua")
        picker.anchorControl = sender
        picker.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbPickerProtocol) in
            print("Gia tri vua chon : \(selectedValue.dbPickerItemTitle)")
        }

        picker.cancelBlock = { (_ picker: DbSheetPicker) in
            print("Bo qua chon")
        }

        picker.didSelectRowBlock = { (_ picker: DbSheetPicker, _ didSelectRow: Int) in
            print("VUA MOI CHON DONG : \(didSelectRow)")
        }
        picker.show()

    }
}

// Mark:- PickerFieldDelegate
extension DemoActionSheetWindowViewController: PickerFieldDelegate
{
    func pickerField(didOKClick pickerField: PickerField) {
        if pickerField.type == .datePicker{
            let componenets = Calendar.current.dateComponents([.year, .month, .day], from: pickerField.datePicker!.date)
            if let day = componenets.day, let month = componenets.month, let year = componenets.year {
                pickerField.text =  "\(day)/\(month)/\(year)"
            }
        }
            
        else if pickerField.type == .pickerView{
            if let row=pickerField.pickerView?.selectedRow(inComponent: 0){
                pickerField.text=states[row]
            }
        }
    }
}

// Mark:- PickerView
extension DemoActionSheetWindowViewController: UIPickerViewDelegate,UIPickerViewDataSource
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    
    fileprivate func setupPickerViewField() {
        pickerViewField.type = .pickerView
        pickerViewField.pickerView?.dataSource=self
        pickerViewField.pickerView?.delegate=self
        pickerViewField.placeholder="your state ..."
        pickerViewField.titleLabel?.text="select a state"
        pickerViewField.pickerFieldDelegate=self
        // pickerViewField.rightImageView.image=#imageLiteral(resourceName: "arrow")
        //pickerViewField.rightImageView.tintColor = .lightGray
    }
    
    
}


// Mark:- DatePicker
extension DemoActionSheetWindowViewController
{
    
    fileprivate func setupDatePickerField() {
        datePickerField.type = .datePicker
        datePickerField.placeholder="your birthday ..."
        datePickerField.pickerFieldDelegate=self
        datePickerField.datePicker?.datePickerMode = .date
        datePickerField.datePicker?.maximumDate = Date()
        // datePickerField.rightImageView.image=#imageLiteral(resourceName: "arrow")
        //datePickerField.rightImageView.tintColor = .lightGray
    }
    
}

// Mark:- TableView
extension DemoActionSheetWindowViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let country=self.countries[indexPath.row]
        cell.textLabel?.text = country.name
        let image=UIImage(named: country.code)
        cell.imageView?.image = image
        cell.imageView?.contentMode = .scaleAspectFill
        cell.backgroundColor = .clear
        cell.imageView?.layer.cornerRadius = 15
        cell.imageView?.clipsToBounds=true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = self.countries[indexPath.row]
        tabelViewField.text=country.name
        
        if let image=UIImage(named: country.code){
            tabelViewField.leftViewMode = .always
            let view=UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let imageView = UIImageView(frame: CGRect(x: 3, y: 3, width: 24, height: 24))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius=12
            imageView.clipsToBounds=true
            view.addSubview( imageView )
            tabelViewField.leftView = view
        }
        else{
            tabelViewField.leftViewMode = .never
            tabelViewField.leftView = nil
        }
        
        tabelViewField.dismiss()
    }
    
    fileprivate func setupTableViewField() {
        
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: localeCode) ?? ""
            let countryCode = localeCode
            let country = Country(code: countryCode, name: countryName)
            countries.append(country)
        }
        
        
        tabelViewField.type = .tableView
        tabelViewField.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tabelViewField.tableView?.dataSource=self
        tabelViewField.tableView?.delegate=self
        tabelViewField.titleLabel?.text="select a country"
        tabelViewField.placeholder="your country ..."
        tabelViewField.hideButtons=true
        tabelViewField.fieldHeight=400
        tabelViewField.cancelWhenTouchUpOutside=true
        // tabelViewField.rightImageView.image=#imageLiteral(resourceName: "arrow")
        //tabelViewField.rightImageView.tintColor = .lightGray
    }
    
    
}


//Mark:- CollectionViewView
extension DemoActionSheetWindowViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row].color
        cell.contentView.layer.cornerRadius=16
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = self.colors[indexPath.row]
        collectionViewField.text=color.title
        collectionViewField.backgroundColor = color.color
        collectionViewField.dismiss()
        
        switch color.color {
        case .red,.black,.blue,.brown,.darkGray,.orange,.purple:
            collectionViewField.textColor = .white
            break
        default:
            collectionViewField.textColor = .black
            break
        }
    }
    
    fileprivate func setupCollectionViewField() {
        collectionViewField.type = .collectionView
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionViewField.collectionView?.setCollectionViewLayout(layout, animated: true)
        collectionViewField.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewField.collectionView?.dataSource=self
        collectionViewField.collectionView?.delegate=self
        collectionViewField.titleLabel?.text="select a color"
        collectionViewField.placeholder="your favorite color ..."
        collectionViewField.hideButtons=true
        collectionViewField.fieldHeight=300
        collectionViewField.cancelWhenTouchUpOutside=true
        // collectionViewField.rightImageView.image=#imageLiteral(resourceName: "arrow")
        //collectionViewField.rightImageView.tintColor = .lightGray
    }
}
