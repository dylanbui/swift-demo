//
//  CustomDecimalRow.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Eureka

class CustomDecimalCell: _FieldCell<Double>, CellType
{
    var decimalSeparator: String! = "." // Default
    var groupingSeparator: String! = "," // Default
    
    var integerSize: Int! = 15 // Default
    var decimalSize: Int! = 2 // Default
    
    private var numberFormatter: NumberFormatter!

    
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
        
        guard let fieldRow = row as? FieldRowConformance, let formatter = fieldRow.formatter as? NumberFormatter else {
            return
        }

        numberFormatter = formatter
        
        // -- Config keyboard format --
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        if numberFormatter.maximumFractionDigits == 0 {
            textField.keyboardType = .numberPad
        }
        
        self.groupingSeparator = self.numberFormatter.groupingSeparator
        self.decimalSeparator = self.numberFormatter.decimalSeparator
        
        self.integerSize = self.numberFormatter.maximumIntegerDigits
        self.decimalSize = self.numberFormatter.maximumFractionDigits
        
        // -- Format value --
        if let val = row.value {
            self.setDecimalValue(val)
        }
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // -- Format value --
        if let val = row.value {
            self.setDecimalValue(val)
        }
        
        return true
    }
    
    override func textFieldDidChange(_ textField: UITextField)
    {
        guard let textValue = textField.text else {
            row.value = nil
            return
        }
        
        textField.text = self.reformatDecimalValue(textValue)
        
        row.value = self.getDecimalValue()
    }
    
    private func setDecimalValue(_ value: Double) -> Void
    {
        var textFieldText = String(value)
        textFieldText = textFieldText.replacingOccurrences(of: ".", with: self.decimalSeparator)
        textField.text = self.reformatDecimalValue(textFieldText)
    }
    
    private func getDecimalValue() -> Double?
    {
        guard let str = textField.text, !str.isEmpty else {
            return nil
        }
        
        var returnStr = str.replacingOccurrences(of: self.groupingSeparator, with: "")
        returnStr = returnStr.replacingOccurrences(of: self.decimalSeparator, with: ".")
        return Double(returnStr)!
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
        
        // -- maximumFractionDigits > 0 --
        if arrSplit.count > 1 && numberFormatter.maximumFractionDigits > 0 {
            var decimalPart = arrSplit[1]
            // -- Limit Decimal Size --
            if decimalPart.count > self.decimalSize {
                decimalPart.string_slice(from: 0, to: self.decimalSize)
            }
            textFieldText = String("\(textFieldText)\(self.decimalSeparator!)\(decimalPart)")
        }
        
        return textFieldText
    }
}

final class CustomDecimalRow: FieldRow<CustomDecimalCell>, RowType
{
    public required init(tag: String?) {
        super.init(tag: tag)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumIntegerDigits = 15
        numberFormatter.maximumFractionDigits = 2
        
        formatter = numberFormatter
    }
}

final class CustomIntegerRow: FieldRow<CustomDecimalCell>, RowType
{
    public required init(tag: String?) {
        super.init(tag: tag)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumIntegerDigits = 15
        numberFormatter.maximumFractionDigits = 0
        
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
    mutating func string_slice(from start: Int, to end: Int) {
        guard end >= start else { return }
        if let str = self[safe: start..<end] {
            self = str
        }
    }
    
    func string_substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
}
