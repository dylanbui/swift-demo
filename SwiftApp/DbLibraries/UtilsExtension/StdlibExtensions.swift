//
//  StdlibExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/28/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

// MARK: - Extension Int
// MARK: Properties
public extension Int {
    
    /// SwifterSwift: Radian value of degree input.
    public var db_degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
    /// SwifterSwift: Degree value of radian input
    public var db_radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
    
    /// SwifterSwift: UInt.
    public var db_uInt: UInt {
        return UInt(self)
    }
    
    /// SwifterSwift: Double.
    public var db_double: Double {
        return Double(self)
    }
    
    /// SwifterSwift: Float.
    public var db_float: Float {
        return Float(self)
    }
    
    /// SwifterSwift: CGFloat.
    public var db_cgFloat: CGFloat {
        return CGFloat(self)
    }
}

// MARK: Methods
public extension Int {
    
    /// SwifterSwift: Random integer between two integer values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random double between two double values.
    public static func random(between min: Int, and max: Int) -> Int {
        return random(inRange: min...max)
    }
    
    /// SwifterSwift: Random integer in a closed interval range.
    ///
    /// - Parameter range: closed interval range.
    /// - Returns: random double in the given closed range.
    public static func random(inRange range: ClosedRange<Int>) -> Int {
        let delta = UInt32(range.upperBound - range.lowerBound + 1)
        return range.lowerBound + Int(arc4random_uniform(delta))
    }
    
    /// SwifterSwift: Roman numeral string from integer (if applicable).
    ///
    ///        10.romanNumeral() -> "X"
    ///
    /// - Returns: The roman numeral string.
    public func romanNumeral() -> String? {
        // https://gist.github.com/kumo/a8e1cb1f4b7cff1548c7
        guard self > 0 else { // there is no roman numerals for 0 or negative numbers
            return nil
        }
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        var romanValue = ""
        var startingValue = self
        
        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]
            let div = startingValue / arabicValue
            if div > 0 {
                for _ in 0..<div {
                    romanValue += romanChar
                }
                startingValue -= arabicValue * div
            }
        }
        return romanValue
    }
    
}

// MARK: Initializers
public extension Int {
    
    /// SwifterSwift: Created a random integer between two integer values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    public init(randomBetween min: Int, and max: Int) {
        self = Int.random(between: min, and: max)
    }
    
    /// SwifterSwift: Create a random integer in a closed interval range.
    ///
    /// - Parameter range: closed interval range.
    public init(randomInRange range: ClosedRange<Int>) {
        self = Int.random(inRange: range)
    }
    
}

// MARK: - Extension Float
// MARK: Properties
public extension Float {
    
    /// SwifterSwift: Int.
    public var int: Int {
        return Int(self)
    }
    
    /// SwifterSwift: Double.
    public var double: Double {
        return Double(self)
    }
    
    /// SwifterSwift: CGFloat.
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
}

// MARK: - Extension Double
// MARK: Properties
public extension Double {
    
    /// SwifterSwift: Int.
    public var int: Int {
        return Int(self)
    }
    
    /// SwifterSwift: Float.
    public var float: Float {
        return Float(self)
    }
    
    /// SwifterSwift: CGFloat.
    public var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

// MARK: - Extension Bool
// MARK: Properties
public extension Bool {
    
    /// SwifterSwift: Return 1 if true, or 0 if false.
    ///
    ///        false.int -> 0
    ///        true.int -> 1
    ///
    public var int: Int {
        return self ? 1 : 0
    }
    
    /// SwifterSwift: Return "true" if true, or "false" if false.
    ///
    ///        false.string -> "false"
    ///        true.string -> "true"
    ///
    public var string: String {
        return description
    }
    
    /// SwifterSwift: Return inversed value of bool.
    ///
    ///        false.toggled -> true
    ///        true.toggled -> false
    ///
    public var toggled: Bool {
        return !self
    }
    
    /// SwifterSwift: Returns a random boolean value.
    ///
    ///     Bool.random -> true
    ///     Bool.random -> false
    ///
    public static var random: Bool {
        return arc4random_uniform(2) == 1
    }
    
}

// MARK: Methods
public extension Bool {
    
    /// SwifterSwift: Toggle value for bool.
    ///
    ///        var bool = false
    ///        bool.toggle()
    ///        print(bool) -> true
    ///
    /// - Returns: inversed value of bool.
    @discardableResult public mutating func toggle() -> Bool {
        self = !self
        return self
    }
    
}


// MARK: - Extension CGFloat
// MARK: Properties
public extension CGFloat {
    
    /// SwifterSwift: Absolute of CGFloat value.
    public var abs: CGFloat {
        return Swift.abs(self)
    }
    
    /// SwifterSwift: Ceil of CGFloat value.
    public var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    /// SwifterSwift: Radian value of degree input.
    public var degreesToRadians: CGFloat {
        return CGFloat.pi * self / 180.0
    }
    
    /// SwifterSwift: Floor of CGFloat value.
    public var floor: CGFloat {
        return Foundation.floor(self)
    }
    
    /// SwifterSwift: Check if CGFloat is positive.
    public var isPositive: Bool {
        return self > 0
    }
    
    /// SwifterSwift: Check if CGFloat is negative.
    public var isNegative: Bool {
        return self < 0
    }
    
    /// SwifterSwift: Int.
    public var int: Int {
        return Int(self)
    }
    
    /// SwifterSwift: Float.
    public var float: Float {
        return Float(self)
    }
    
    /// SwifterSwift: Double.
    public var double: Double {
        return Double(self)
    }
    
    /// SwifterSwift: Degree value of radian input.
    public var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
}

// MARK: Methods
public extension CGFloat {
    
    /// SwifterSwift: Random CGFloat between two CGFloat values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random CGFloat between two CGFloat values.
    public static func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        let delta = max - min
        return min + CGFloat(arc4random_uniform(UInt32(delta)))
    }
    
}


