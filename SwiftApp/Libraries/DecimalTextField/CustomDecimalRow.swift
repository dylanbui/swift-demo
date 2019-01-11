//
//  CustomDecimalRow.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Eureka

/// A row where the user can enter a decimal number.
//public final class CustomDecimalRow: _DecimalRow, RowType {
//    required public init(tag: String?) {
//        super.init(tag: tag)
//    }
//}

class CustomDecimalCell: _FieldCell<Double>, CellType
{
    var decimalSeparator: String! = "." // Default
    var groupingSeparator: String! = "," // Default
    
    var integerSize: Int! = 15 // Default
    var decimalSize: Int! = 2 // Default
    
    private var numberFormatter: NumberFormatter!

    
    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        
        // textField.addTarget(self, action: #selector(self.textFieldDidChanged), for: .editingChanged)
        
        guard let fieldRow = row as? FieldRowConformance, let formatter = fieldRow.formatter as? NumberFormatter else {
            return
        }

        numberFormatter = formatter
        
        self.groupingSeparator = self.numberFormatter.groupingSeparator
        self.decimalSeparator = self.numberFormatter.decimalSeparator
        
        self.integerSize = self.numberFormatter.maximumIntegerDigits
        self.decimalSize = self.numberFormatter.maximumFractionDigits
        
        // -- Format value --
        if let val = row.value {
            self.setDecimalValue(val)
        }
    }
    
    func setDecimalValue(_ value: Double) -> Void
    {
        var textFieldText = String(value)
        textFieldText = textFieldText.replacingOccurrences(of: ".", with: self.decimalSeparator)
        textField.text = self.reformatDecimalValue(textFieldText)
    }
    
    func getDecimalValue() -> Double?
    {
        guard let str = textField.text else {
            return nil
        }

        var returnStr = str.replacingOccurrences(of: self.groupingSeparator, with: "")
        returnStr = returnStr.replacingOccurrences(of: self.decimalSeparator, with: ".")
        return Double(returnStr)!
    }
    
    override func textFieldDidChange(_ textField: UITextField)
    {
        guard let textValue = textField.text else {
            row.value = nil
            return
        }
//        guard let fieldRow = row as? FieldRowConformance, let formatter = fieldRow.formatter else {
//            row.value = textValue.isEmpty ? nil : (Double.init(string: textValue) ?? row.value)
//            return
//        }
        
        textField.text = self.reformatDecimalValue(textValue)
        
        row.value = self.getDecimalValue()
    }
    
    private func reformatDecimalValue(_ decimalString: String) -> String
    {
        let arrSplit = decimalString.components(separatedBy: self.decimalSeparator)
        
        var textFieldText: String = arrSplit[0].replacingOccurrences(of: self.groupingSeparator, with: "") as String
        if textFieldText.count > 1 {
            // -- Use String extension --
            textFieldText.string_slice(from: 0, to: self.integerSize)
        }
        
        textFieldText = self.numberFormatter?.string(for: Double(textFieldText)) ?? ""
        
        if arrSplit.count > 1 {
            //if self.textFieldType == .Decimal && arrSplit.count > 1 {
            var decimalPart = arrSplit[1]
            // -- Limit Decimal Size --
            if decimalPart.count > self.decimalSize {
                decimalPart.string_slice(from: 0, to: self.decimalSize)
            }
            textFieldText = String("\(textFieldText)\(self.decimalSeparator!)\(decimalPart)")
        }
        
        return textFieldText
    }
    
//    @objc func textFieldDidChanged(_ theTextField: UITextField) -> Void
//    {
//
//    }
}

final class CustomDecimalRow: FieldRow<CustomDecimalCell>, RowType
{
    public required init(tag: String?) {
        super.init(tag: tag)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        //numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumIntegerDigits = 15
        numberFormatter.maximumFractionDigits = 2
        
        formatter = numberFormatter
    }
}

fileprivate extension String
{
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    fileprivate mutating func string_slice(from start: Int, to end: Int) {
        guard end >= start else { return }
        if let str = self[safe: start..<end] {
            self = str
        }
    }
    
    fileprivate func string_substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
}
