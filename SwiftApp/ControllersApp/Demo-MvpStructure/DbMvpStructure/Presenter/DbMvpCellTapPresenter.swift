//
//  DbMvpCellTapPresenter.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpCellTapPresenter
{
    associatedtype ItemType
    
    func itemWasTapped(_ item: ItemType)
}
