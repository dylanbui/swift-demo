//
//  DbMvpCollectionViewDataSource.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

open class DbMvpCollectionViewDataSource<U, V: DbMvpViewCell>: NSObject, UICollectionViewDataSource,
    DbMvpViewDataSource where U == V.ItemType
{
    open var items = [U]()
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: V.reuseIdentifier,
            for: indexPath)
        let item = self.item(at: indexPath)
        (cell as! V).configure(forItem: item)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return items.count
    }
}
