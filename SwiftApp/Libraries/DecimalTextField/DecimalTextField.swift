//
//  DecimalTextField.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import APNumberPad

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
    
    private var textFieldType: DecimalTextFieldType! = .Integer
    private var numberFormatter: NumberFormatter?
    private var numberPad: APNumberPad?
    
    convenience init(withTextFieldType type: DecimalTextFieldType)
    {
        self.init(frame: CGRect.zero)
        self.initParams()
        self.reloadDataWithType(type)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initParams()
        self.reloadDataWithType(.Integer)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initParams()
        self.reloadDataWithType(.Integer)
    }
    
    private func initParams() -> Void
    {
        self.groupingSeparator = "."
        self.decimalSeparator = ","
        self.integerSize = 15
        self.decimalSize = 2
        
        // -- Set default sign --
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        self.groupingSeparator = formatter.groupingSeparator
        self.decimalSeparator = formatter.decimalSeparator
        
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }
    
    func reloadDataWithType(_ type: DecimalTextFieldType) -> Void
    {
        self.text = ""
        self.textFieldType = type
        
        // -- Set number pad --
        self.numberPad = APNumberPad.init(delegate: self as APNumberPadDelegate)
        // configure function button
        if self.textFieldType == .Decimal {
            self.numberPad?.leftFunctionButton.setTitle(self.decimalSeparator, for: .normal)
            self.numberPad?.leftFunctionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        self.inputView = self.numberPad
        
        self.numberFormatter = NumberFormatter()
        self.numberFormatter?.groupingSeparator = self.groupingSeparator
        self.numberFormatter?.groupingSize = 3
        self.numberFormatter?.decimalSeparator = self.decimalSeparator
        self.numberFormatter?.numberStyle = .decimal
        self.numberFormatter?.maximumFractionDigits = 0
        self.numberFormatter?.minimumFractionDigits = 0
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
        
        if self.textFieldType == .Decimal && arrSplit.count > 1 {
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

extension DecimalTextField: APNumberPadDelegate
{
    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder & UITextInput)
    {
        guard let str = self.text else {
            print("\(self.text!)")
            return
        }

        // -- Only enter 1 self.decimalSeparator --
        if (!str.isEmpty && !str.contains(self.decimalSeparator)) {
            textInput.insertText(self.decimalSeparator)
        }
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
}
