//
//  DemoEurekaViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import Eureka
import FloatLabelRow

class DemoEurekaViewController: FormViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        form +++
            Section() { section in
                let header = HeaderFooterView<UIView>(.nibFile(name: "EurekaHeader", bundle: Bundle.main))
                section.header = header
            }
            <<< ButtonRow("Field row label examples") {
                $0.title = $0.tag
//                $0.presentationMode = .segueName(segueName: "RowsExampleViewControllerSegue", onDismiss: nil)
                $0.presentationMode = .show(controllerProvider: .callback(builder: {
                    // instantiate viewController
                    let yourViewController =  RowsExampleViewController()
                    return yourViewController
                }), onDismiss:nil)
            }
            <<< ButtonRow("Formatters examples") { (row: ButtonRow) -> Void in
                row.title = row.tag
//                row.presentationMode = .segueName(segueName: "FormattersControllerSegue", onDismiss: nil)
                row.presentationMode = .show(controllerProvider: .callback(builder: {
                    // instantiate viewController
                    let yourViewController =  FormatterExample()
                    return yourViewController
                }), onDismiss:nil)
            }
            <<< ButtonRow("Custom Formatters examples") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .show(controllerProvider: .callback(builder: {
                    // instantiate viewController
                    let yourViewController =  DecimalFormatterExample()
                    return yourViewController
                }), onDismiss:nil)
        }
    }



}

// MARK: Class RowsExampleViewController - Default provided FieldRow types
class RowsExampleViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            Section(header: "Field Row Label examples", footer: "Field rows provided by default")
            <<< TextFloatLabelRow() {
                $0.title = "Text Field"
                $0.value = "Placeholder"
                $0.cell.textField.textAlignment = .right
            }
            <<< IntFloatLabelRow() {
                $0.title = "Int field"
                $0.value = 2017
                $0.cell.textField.textAlignment = .right
            }
            <<< DecimalFloatLabelRow() {
                $0.title = "Decimal field"
                $0.value = 2017
                //$0.formatter = DecimalFormatter()
                $0.useFormatterDuringInput = true
            }
            <<< URLFloatLabelRow() {
                $0.title = "URL field"
                $0.value = URL(string: "http://xmartlabs.com")
            }
            <<< TwitterFloatLabelRow() {
                $0.title = "Twitter field"
                $0.value = "@xmartlabs"
            }
            <<< AccountFloatLabelRow() {
                $0.title = "Account field"
                $0.value = "Xmartlabs"
            }
            <<< PasswordFloatLabelRow() {
                $0.title = "Password field"
                $0.value = "password"
            }
            <<< NameFloatLabelRow() {
                $0.title = "Name field"
                $0.value = "Xmartlabs"
            }
            <<< EmailFloatLabelRow() {
                $0.title = "Email field"
                $0.value = "hello@xmartlabs"
            }
            <<< PhoneFloatLabelRow() {
                $0.title = "Phone field (disabled)"
                $0.value = "+598 9898983510"
                $0.disabled = true
            }
            <<< ZipCodeFloatLabelRow() {
                $0.title = "Zip code field"
                $0.value = "90210"
        }
    }
    
}

//MARK: Class FormatterExample - Native and Custom formatters
class FormatterExample : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            Section(header: "Number formatters", footer: "Native formatters")
            <<< DecimalFloatLabelRow() {
                $0.title = "Scientific style"
                $0.value = 2017
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .scientific
                $0.formatter = formatter
            }
            <<< IntFloatLabelRow() {
                $0.title = "Spell out style"
                $0.value = 2017
                let formatter = NumberFormatter()
                formatter.locale = .current
                formatter.numberStyle = .spellOut
                $0.formatter = formatter
            }
            <<< DecimalFloatLabelRow() {
                $0.title = "Energy: Jules to calories"
                $0.value = 100.0
                let formatter = EnergyFormatter()
                $0.formatter = formatter
            }
            <<< IntFloatLabelRow() {
                $0.title = "Weight: Kg to lb"
                $0.value = 1000
                $0.formatter = MassFormatter()
            }
            
            +++ Section(header: "Custom formatter", footer: "Custom formatter: CurrencyFormatter")
            <<< DecimalFloatLabelRow() {
                $0.title = "Currency style"
                $0.value = 2000.00
                $0.useFormatterDuringInput = true
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }
            
            <<< CustomDecimalRow() {
                $0.title = "Weight: Kg to lb"
                $0.value = 1000.25
            }

            <<< CustomIntegerRow() {
                $0.title = "CustomIntegerRow"
                $0.value = 1000.0
            }

            <<< CustomIntegerRow() {
                $0.title = "CustomIntegerRow"
                $0.value = 2000
        }

        
    }
    
    class CurrencyFormatter : NumberFormatter, FormatterProtocol {
        
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
            guard obj != nil else { return }
            let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
        }
        
        func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
            return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
        }
        
    }
    
}


//MARK: Class FormatterExample - Native and Custom formatters
class DecimalFormatterExample : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++
            Section(header: "Number formatters", footer: "Native formatters")
            
            <<< CustomDecimalRow() {
                $0.title = "Weight: Kg to lb"
                $0.value = 1000.25
            }
            
            <<< CustomIntegerRow() {
                $0.title = "CustomIntegerRow"
                $0.value = 1000.0
            }
            
            <<< CustomIntegerRow() {
                $0.title = "CustomIntegerRow"
                $0.value = 2000
            }
            
            +++ Section(header: "Custom formatter", footer: "Custom formatter: CurrencyFormatter")
            
            <<< LabelRow() {
                $0.title = "LabelRow"
                $0.value = "Val = 1000.0"
            }
            <<< LabelRow() {
                $0.title = "LabelRow"
                $0.value = "Val = 1000.0"
            }
            <<< LabelRow() {
                $0.title = "LabelRow"
                $0.value = "Val = 1000.0"
            }

            
            
            <<< TextRow("address") {
                $0.title = "Số nhà"
                $0.placeholder = "Nhập số nhà, đường"
                // $0.value = "Val = 1000.0"
            }
            
            <<< LabelRow() {
                $0.title = "LabelRow"
                $0.value = "Val = 1234567890"
            }
        
            <<< CustomPickerRow("myROWPHUONG") {
                $0.title = "Chon phuong"
                $0.placeholder = "Selector"
                let selected = CustomPickerItem(id: 3, title: "gia tri 3", desc: "content 3")
                $0.value = selected.title
                $0.cell.itemSelected = selected
                $0.cell.arrSources = [
                    CustomPickerItem(id: 1, title: "gia tri 1", desc: "content 1"),
                    CustomPickerItem(id: 2, title: "gia tri 2", desc: "content 2"),
                    CustomPickerItem(id: 3, title: "gia tri 3", desc: "content 3")]
                }
                
                .cellSetup({ (cell, row) in
                    
                })
                
                .onChange({ (row) in
                    // -- Su dung duoc --
                    // row.select(animated: true, scrollPosition: .middle)
                    print("\(String(describing: row.value))")
                    //print("row.value! = \(row.value!)")
                })
        
            <<< PzCustomPickerRow("PickerRowWard") {
                $0.title = "Chọn phường"
                $0.placeholder = "phường"
//                let selected = DbItem(id: 3, title: "Phường 3", desc: "Phường 3")
//                $0.value = selected.dbItemTitle
//                $0.cell.itemSelected = selected
                $0.cell.arrSources = [
                    DbItem(id: 1, title: "Phường 1", desc: "Phường 1"),
                    DbItem(id: 2, title: "Phường 2", desc: "Phường 2"),
                    DbItem(id: 3, title: "Phường 3", desc: "Phường 3")]
                }
                
                .cellSetup({ (cell, row) in
                    
                })
                
                .onChange({ (row) in
                    // -- Su dung duoc : Scroll to control position--
                    // row.select(animated: true, scrollPosition: .middle)
                    print("row.value = \(String(describing: row.value))")
                    let item = row.cell.itemSelected
                    print("item.debugDescription = \(item.debugDescription)")
                })


    }
    
    
}

