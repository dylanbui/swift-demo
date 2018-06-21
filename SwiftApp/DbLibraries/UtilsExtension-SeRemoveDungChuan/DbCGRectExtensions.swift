//
//  CoreGraphicsExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/29/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

// MARK: CGPoint

extension CGPoint {
    
    /// Creates a point with unnamed arguments.
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    /// Creates a point with unnamed arguments.
    public init(_ x: Int, _ y: Int) {
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }
    
    /// Creates a point with unnamed arguments.
    public init(_ x: Double, _ y: Double) {
        self.x = CGFloat(x)
        self.y = CGFloat(y)
    }
    
}

// MARK: CGSize
extension CGSize {
    
    /// Creates a size with unnamed arguments.
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    /// Creates a size with unnamed arguments.
    public init(_ width: Int, _ height: Int) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }

    /// Creates a size with unnamed arguments.
    public init(_ width: Double, _ height: Double) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
}

// MARK: CGRect

extension CGRect {
    
//    private func raw(v: AnyObject) -> CGFloat { return CGFloat(truncating: v as! NSNumber) }
//
    private func rX(r: CGRect) -> CGFloat { return r.origin.x }
    private func rY(r: CGRect) -> CGFloat { return r.origin.y }
    private func rH(r: CGRect) -> CGFloat { return r.size.width }
    private func rW(r: CGRect) -> CGFloat { return r.size.height }
    
    /// Creates a rect with unnamed arguments.
    public init(_ origin: CGPoint, _ size: CGSize) {
        self.origin = origin
        self.size = size
    }
    
    /// Creates a rect with unnamed arguments.
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
    
    /// Creates a rect with unnamed arguments.
    public init(_ x: Int, _ y: Int, _ width: Int, _ height: Int) {
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
    
    /// Creates a rect with unnamed arguments.
    public init(_ x: Double, _ y: Double, _ width: Double, _ height: Double) {
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
    
    @discardableResult public mutating func addX(_ x: CGFloat) -> CGFloat {
        self.origin.x = rX(r: self) + x
        return self.origin.x
    }

    @discardableResult public mutating func addY(_ y: CGFloat) -> CGFloat {
        self.origin.y = rY(r: self) + y
        return self.origin.y
    }

    @discardableResult public mutating func addWidth(_ width: CGFloat) -> CGFloat {
        self.size.width = rW(r: self) + width
        return self.size.width
    }

    @discardableResult public mutating func addHeight(_ height: CGFloat) -> CGFloat {
        self.size.height = rH(r: self) + height
        return self.size.height
    }
    
}
