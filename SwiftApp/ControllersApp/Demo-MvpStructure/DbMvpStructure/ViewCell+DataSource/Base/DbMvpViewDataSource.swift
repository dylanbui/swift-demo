//
//  DbMvpViewDataSource.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpViewDataSource
{
    associatedtype ItemType
    
    var items: [ItemType] { get set }
}

public extension DbMvpViewDataSource
{
    func item(at indexPath: IndexPath) -> ItemType
    {
        return items[(indexPath as NSIndexPath).item]
    }
}

