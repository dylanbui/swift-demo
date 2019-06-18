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
    var db_degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }
    
    /// SwifterSwift: Degree value of radian input
    var db_radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }
    
    /// SwifterSwift: Double.
    var db_double: Double {
        return Double(self)
    }
    
    /// SwifterSwift: Float.
    var db_float: Float {
        return Float(self)
    }
    
    /// SwifterSwift: CGFloat.
    var db_cgFloat: CGFloat {
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
    static func db_random(between min: Int, and max: Int) -> Int {
        return db_random(inRange: min...max)
    }
    
    /// SwifterSwift: Random integer in a closed interval range.
    ///
    /// - Parameter range: closed interval range.
    /// - Returns: random double in the given closed range.
    static func db_random(inRange range: ClosedRange<Int>) -> Int {
        let delta = UInt32(range.upperBound - range.lowerBound + 1)
        return range.lowerBound + Int(arc4random_uniform(delta))
    }
}

// MARK: - Extension Float
// MARK: Properties
public extension Float {
    
    /// SwifterSwift: Int.
    var db_int: Int {
        return Int(self)
    }
    
    /// SwifterSwift: Double.
    var db_double: Double {
        return Double(self)
    }
    
    /// SwifterSwift: CGFloat.
    var db_cgFloat: CGFloat {
        return CGFloat(self)
    }
    
}

// MARK: - Extension Double
// MARK: Properties
public extension Double {
    
    /// SwifterSwift: Int.
    var db_int: Int {
        return Int(self)
    }
    
    /// SwifterSwift: Float.
    var db_float: Float {
        return Float(self)
    }
    
    /// SwifterSwift: CGFloat.
    var db_cgFloat: CGFloat {
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
    var db_int: Int {
        return self ? 1 : 0
    }
    
    /// SwifterSwift: Return "true" if true, or "false" if false.
    ///
    ///        false.string -> "false"
    ///        true.string -> "true"
    ///
    var db_string: String {
        return description
    }
    
    /// SwifterSwift: Return inversed value of bool.
    ///
    ///        false.toggled -> true
    ///        true.toggled -> false
    ///
    var db_toggled: Bool {
        return !self
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
    @discardableResult mutating func db_toggle() -> Bool {
        self = !self
        return self
    }
    
}


// MARK: - Extension CGFloat
// MARK: Properties
public extension CGFloat {
    
    /// SwifterSwift: Radian value of degree input.
    var db_degreesToRadians: CGFloat {
        return CGFloat.pi * self / 180.0
    }
    
    /// SwifterSwift: Degree value of radian input.
    var db_radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
    /// SwifterSwift: Absolute of CGFloat value.
    var db_abs: CGFloat {
        return Swift.abs(self)
    }
    
    /// SwifterSwift: Ceil of CGFloat value.
    var db_ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    /// SwifterSwift: Floor of CGFloat value.
    var db_floor: CGFloat {
        return Foundation.floor(self)
    }
    
    /// SwifterSwift: Int.
    var db_int: Int {
        return Int(self)
    }
    
    /// SwifterSwift: Float.
    var db_float: Float {
        return Float(self)
    }
    
    /// SwifterSwift: Double.
    var db_double: Double {
        return Double(self)
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
    static func db_randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        let delta = max - min
        return min + CGFloat(arc4random_uniform(UInt32(delta)))
    }
    
}


