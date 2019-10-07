//
//  DbMvpCollectionView.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpCollectionViewAction: class
{
    var collectionView: UICollectionView! { get }
    
    associatedtype CollectionViewDataSourceType: DbMvpViewDataSource
    var dataSource: CollectionViewDataSourceType! { get set }
}

extension DbMvpCollectionViewAction
{
    func doReloadCollectionView(items: [CollectionViewDataSourceType.ItemType])
    {
        self.show(items: items)
    }
    
    public func show(items: [CollectionViewDataSourceType.ItemType])
    {
        dataSource.items = items
        collectionView.reloadData()
    }
}
