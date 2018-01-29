//
//  DecimalTextField.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import APNumberPad

enum DecimalTextFieldType : Int {
    case Decimal = 0
    case Integer = 1
}

class DecimalTextField: UITextField {
    
    var textFieldType: DecimalTextFieldType! = .Integer
    
    var decimalSeparator: String! = "." // Default
    var groupingSeparator: String! = "," // Default
    
    var integerSize: Int! = 12 // Default
    var decimalSize: Int! = 2 // Default
    
    
    private var numberFormatter: NumberFormatter?
    private var numberPad: APNumberPad?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initParams()
        self.reloadDataWithType(.Integer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initParams()
        self.reloadDataWithType(.Integer)
    }
    
    func initParams() -> Void {
        self.groupingSeparator = "."
        self.decimalSeparator = ","
        self.integerSize = 15
        self.decimalSize = 2
        
        self.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
//        [self addTarget:self
//            action:@selector(textFieldDidChange:)
//            forControlEvents:UIControlEventEditingChanged];
    }
    
    func reloadDataWithType(_ type: DecimalTextFieldType) -> Void {
        self.text = ""
        self.textFieldType = type
        
        // -- Set number pad --
        self.numberPad = APNumberPad.init(delegate: self as APNumberPadDelegate)
        // configure function button
        if self.textFieldType == .Decimal {
            self.numberPad?.leftFunctionButton.setTitle(self.decimalSeparator, for: .normal)
            self.numberPad?.leftFunctionButton.titleLabel?.adjustsFontSizeToFitWidth = true;
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
    
    func setDecimalValue(_ value: Double) -> Void {
        
        var textFieldText = String(value)
        textFieldText = textFieldText.replacingOccurrences(of: ".", with: self.decimalSeparator)
        self.text = self.reformatDecimalValue(textFieldText)
//        NSString *textFieldText = [[value stringValue] stringByReplacingOccurrencesOfString:@"." withString:self.decimalSeparator];
//        self.text = [self reformatDecimalValue:textFieldText]; //textFieldText;
        
    }
    
    func getDecimalValue() -> Double {
        
        guard let str = self.text, str.isEmpty else {
            return 0.0
        }
        
        var returnStr = str.replacingOccurrences(of: self.groupingSeparator, with: "")
        returnStr = str.replacingOccurrences(of: self.decimalSeparator, with: ".")
        return Double(returnStr)!
//        NSString *textFieldText = [self.text stringByReplacingOccurrencesOfString:self.groupingSeparator withString:@""];
//        textFieldText = [textFieldText stringByReplacingOccurrencesOfString:self.decimalSeparator withString:@"."];
//        return [NSNumber numberWithDouble:[textFieldText doubleValue]];
        
    }

    @objc func textFieldDidChange(_ theTextField: UITextField) -> Void {
        
        guard let str = theTextField.text, str.isEmpty else {
            return
        }
        theTextField.text = self.reformatDecimalValue(str)
        
    }
    
    private func reformatDecimalValue(_ decimalString: String) -> String {
        
        let arrSplit = decimalString.components(separatedBy: self.decimalSeparator)
        
        var textFieldText = arrSplit[0].replacingOccurrences(of: self.groupingSeparator, with: "") as String
        if textFieldText.count > 1 {
            // -- Use String extension --
            textFieldText.db_slice(from: 0, to: self.integerSize)
        }
        
//        NSString *formattedOutput = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:[textFieldText doubleValue]]];
        
        textFieldText = self.numberFormatter?.string(for: Double(textFieldText)) ?? ""
        
        if arrSplit.count > 1 {
            var decimalPart = arrSplit[1]
            // -- Limit Decimal Size --
            if decimalPart.count > self.decimalSize {
                decimalPart.db_slice(from: 0, to: self.decimalSize)
            }
            textFieldText = String("\(textFieldText)\(self.decimalSeparator!)\(decimalPart)")
        }
        
        return textFieldText
    }
    
//    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder & UITextInput) {
//
//        guard let str = self.text, str.isEmpty, str.contains(self.decimalSeparator!) else {
//            return
//        }
//        textInput.insertText(self.decimalSeparator!)
//        //        if (![self.text isEqualToString:@""] && ![self.text containsString:self.decimalSeparator]) {
//        //            [textInput insertText:self.decimalSeparator];
//        //        }
//
//    }
    
}

extension DecimalTextField: APNumberPadDelegate {

    func numberPad(_ numberPad: APNumberPad, functionButtonAction functionButton: UIButton, textInput: UIResponder & UITextInput) {

        guard let str = self.text else {
            print("\(self.text!)")
            return
        }
        
        if (!str.isEmpty && !str.contains(self.decimalSeparator!)) {
            textInput.insertText(self.decimalSeparator!)
        }
        

//        if (![self.text isEqualToString:@""] && ![self.text containsString:self.decimalSeparator]) {
//            [textInput insertText:self.decimalSeparator];
//        }

    }

}

