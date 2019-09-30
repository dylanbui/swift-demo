//
//  DbMvpViewCell.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpViewCell
{
    static var cellClassName: String { get }
    static var reuseIdentifier: String { get }
    static var identifier: String { get }
    
    associatedtype ItemType
    func configure(forItem item: ItemType)
    func configure(forDictinary dict: DictionaryType) // Optional
}

public extension DbMvpViewCell
{
    static var cellClassName: String { return String(describing: Self.self) }
    static var reuseIdentifier: String { return String(describing: Self.self) + "ReuseIdentifier" }
    static var identifier: String { return String(describing: Self.self) + "Identifier" }
    
    func configure(forDictinary dict: DictionaryType) { }
}
