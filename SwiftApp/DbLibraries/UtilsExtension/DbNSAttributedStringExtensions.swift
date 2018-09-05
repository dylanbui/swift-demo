//
//  NSAttributedStringExtensions.swift
//  PropzySam
//
//  Created by Dylan Bui on 8/21/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Base on : https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/Extensions/Foundation/NSAttributedStringExtensions.swift
//  Test : https://github.com/SwifterSwift/SwifterSwift/blob/master/Tests/FoundationTests/NSAttributedStringExtensionsTests.swift

import Foundation

/* Ex :
 
 let email = "steve.jobs@apple.com"
 let testString = NSAttributedString(string: "Your email is \(email)!").bolded
 let attributes: [NSAttributedStringKey: Any] = [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, .foregroundColor: UIColor.blue]
 let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
 
 let attrTestString = testString.applying(attributes: attributes, toRangesMatching: pattern)
 
 var string1 = NSAttributedString(string: "Test").italicized.underlined.struckthrough
 let string2 = NSAttributedString(string: " Appending").bolded
 XCTAssertEqual((string1 + string2).string, "Test Appending")
 XCTAssertEqual((string1 + string2.string).string, "Test Appending")
 
 string1 += string2.string
 XCTAssertEqual(string1.string, "Test Appending")
 
 */

// MARK: - Properties
public extension NSAttributedString {
    
    /// SwifterSwift: Bolded string.
    public var db_bolded: NSAttributedString {
        return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// SwifterSwift: Underlined string.
    public var db_underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
    }
    
    /// SwifterSwift: Italicized string.
    public var db_italicized: NSAttributedString {
        return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    
    /// SwifterSwift: Struckthrough string.
    public var db_struckthrough: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)])
    }
    
    /// SwifterSwift: Dictionary of the attributes applied across the whole string
    public var db_attributes: [NSAttributedStringKey: Any] {
        return attributes(at: 0, effectiveRange: nil)
    }
    
}

// MARK: - Methods
public extension NSAttributedString {
    
//    convenience init(rawValue: String, attributes: [NSAttributedStringKey: Any]) {
//        self.init(string: rawValue)
//
//    }
    
    
    /// SwifterSwift: Applies given attributes to the new instance of NSAttributedString initialized with self object
    ///
    /// - Parameter attributes: Dictionary of attributes
    /// - Returns: NSAttributedString with applied attributes
    fileprivate func applying(attributes: [NSAttributedStringKey: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        
        return copy
    }
    
    /// SwifterSwift: Add color to NSAttributedString.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    public func db_colored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    
    /// SwifterSwift: Apply attributes to substrings matching a regular expression
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - pattern: a regular expression to target
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern
    public func db_applying(attributes: [NSAttributedStringKey: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
        
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)
        
        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }
        
        return result
    }
    
    /// SwifterSwift: Apply attributes to occurrences of a given string
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - target: a subsequence string for the attributes to be applied to
    /// - Returns: An NSAttributedString with attributes applied on the target string
    public func db_applying<T: StringProtocol>(attributes: [NSAttributedStringKey: Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        
        return db_applying(attributes: attributes, toRangesMatching: pattern)
    }
}

// MARK: - Operators
public extension NSAttributedString {
    
    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    public static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }
    
    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }
    
    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    public static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    /// SwifterSwift: Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    public static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
}

/* Ex : https://stackoverflow.com/questions/27040924/nsrange-from-swift-range
let attributedString = NSMutableAttributedString(string: "Sample Text 12345", attributes: [.font : UIFont.systemFont(ofSize: 15.0)])
 
 // NSRange(range, in: )
if let range = attributedString.string.range(of: "Sample")  {
    attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(range, in: attributedString.string))
}

// NSRange(location: , length: )
if let range = attributedString.string.range(of: "12345") {
    attributedString.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: range.lowerBound.encodedOffset, length: range.upperBound.encodedOffset - range.lowerBound.encodedOffset))
}
 
 */

public extension NSMutableAttributedString {
    
    public func db_addAttribute(_ name: NSAttributedStringKey, value: Any, matchOfString: String) {
        db_addAttributes([name: value], matchOfString: matchOfString)
    }
    
    public func db_addAttributes(_ attrs: [NSAttributedStringKey : Any] = [:], matchOfString: String) {
        // NSRange(range, in: )
        if let range = self.string.range(of: matchOfString)  {
            addAttributes(attrs, range: NSRange(range, in: self.string))
        }
    }

    
}










