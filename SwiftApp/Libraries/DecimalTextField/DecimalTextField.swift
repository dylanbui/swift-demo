//
//  DecimalTextField.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

enum DecimalTextFieldType : Int
{
    case Decimal = 0
    case Integer = 1
}

class DecimalTextField: UITextField
{
    var decimalSeparator: String! = "." // Default
    var groupingSeparator: String! = "," // Default
    
    var integerSize: Int! = 15 // Default
    var decimalSize: Int! = 2 // Default
    
    private var numberFormatter: NumberFormatter!
    
    convenience init(withTextFieldType type: DecimalTextFieldType)
    {
        self.init(frame: CGRect.zero)
        self.initParams()
        self.reloadDataWithFormatter()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initParams()
        self.reloadDataWithFormatter()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initParams()
        self.reloadDataWithFormatter()
    }
    
    private func initParams() -> Void
    {
        self.groupingSeparator = "."
        self.decimalSeparator = ","
        self.integerSize = 15
        self.decimalSize = 2
        
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func reloadDataWithFormatter(_ formatter: NumberFormatter? = nil) -> Void
    {
        self.text = ""
        
        self.numberFormatter = NumberFormatter()
        // self.numberFormatter?.groupingSize = 3 // Default
        if formatter == nil {
            self.numberFormatter.numberStyle = .decimal
            self.numberFormatter.locale = Locale.current
        } else {
            self.numberFormatter.numberStyle = formatter!.numberStyle
            self.numberFormatter.locale = formatter!.locale
        }
        
        self.groupingSeparator = self.numberFormatter.groupingSeparator
        self.decimalSeparator = self.numberFormatter.decimalSeparator
        // -- Set keypad --
        self.keyboardType = .numberPad
        if self.numberFormatter.numberStyle == .decimal {
            self.keyboardType = .decimalPad
        }
    }
    
    func setTextFieldType(_ type: DecimalTextFieldType)
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = (type == .Decimal ? .decimal : .none)
        self.reloadDataWithFormatter(formatter)
    }
    
    func setDecimalValue(_ value: Double) -> Void
    {
        var textFieldText = String(value)
        textFieldText = textFieldText.replacingOccurrences(of: ".", with: self.decimalSeparator)
        self.text = self.reformatDecimalValue(textFieldText)
    }
    
    func getDecimalValue() -> Double
    {
        guard let str = self.text, !str.isEmpty else {
            return 0.0
        }
        
        var returnStr = str.replacingOccurrences(of: self.groupingSeparator, with: "")
        returnStr = returnStr.replacingOccurrences(of: self.decimalSeparator, with: ".")
        return Double(returnStr)!
    }

    @objc func textFieldDidChange(_ theTextField: UITextField) -> Void
    {
        guard let str = theTextField.text, !str.isEmpty else {
            return
        }
        
        // -- Only enter 1 self.decimalSeparator --
        let countDecimalSeparator = str.components(separatedBy: self.decimalSeparator).count - 1
        if countDecimalSeparator > 1 {
            theTextField.text = str.string_substring(to: str.count - 2)
            return
        }
        
        theTextField.text = self.reformatDecimalValue(str)
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
