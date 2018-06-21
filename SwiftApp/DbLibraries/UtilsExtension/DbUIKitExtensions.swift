//
//  DbUIKitExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/30/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

// MARK: - Enums
public extension UITextField {
    
    /// SwifterSwift: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    public enum DbTextType {
        case emailAddress
        case password
        case generic
    }
    
}

// MARK: - Properties
public extension UITextField {
    
    /// SwifterSwift: Set textField for common text types.
    public var textType: DbTextType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                placeholder = "Email Address"
                
            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                placeholder = "Password"
                
            case .generic:
                isSecureTextEntry = false
                
            }
        }
    }
    
    /// SwifterSwift: Check if text field is empty.
    public var isEmpty: Bool {
        return text?.isEmpty == true
    }
    
    /// SwifterSwift: Return text with no spaces or new lines in beginning and end.
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// SwifterSwift: Check if textFields text is a valid email format.
    ///
    ///        textField.text = "john@doe.com"
    ///        textField.hasValidEmail -> true
    ///
    ///        textField.text = "swifterswift"
    ///        textField.hasValidEmail -> false
    ///
    public var hasValidEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    
    /// SwifterSwift: Left view tint color.
    @IBInspectable public var leftViewTintColor: UIColor? {
        get {
            guard let iconView = leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
    /// SwifterSwift: Right view tint color.
    @IBInspectable public var rightViewTintColor: UIColor? {
        get {
            guard let iconView = rightView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = rightView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
}

// MARK: - Methods
public extension UITextField {
    
    /// SwifterSwift: Clear text.
    public func db_clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// SwifterSwift: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    public func db_setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    /// SwifterSwift: Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    public func db_addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    /// SwifterSwift: Add padding to the left of the textfield rect.
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    public func db_addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.leftViewMode = UITextFieldViewMode.always
    }
    
}

// MARK: - UILabel
// MARK: - Methods
public extension UILabel {
    
    /// SwifterSwift: Initialize a UILabel with text
    public convenience init(text: String?) {
        self.init()
        self.text = text
    }
    
    /// SwifterSwift: Required height for a label
    public var db_requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
}

// MARK: - UITextView Methods
public extension UITextView {
    
    /// SwifterSwift: Clear text.
    public func db_clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// SwifterSwift: Scroll to the bottom of text view
    public func db_scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
        
    }
    
    /// SwifterSwift: Scroll to the top of text view
    public func db_scrollToTop() {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
    
}
