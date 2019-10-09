//
//  MvpSeriesDetailCollectionViewDataSource.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation


class MvpSeriesDetailCollectionViewDataSource: DbMvpCollectionViewDataSource<MvpComic, MvpComicCollectionViewCell>, UICollectionViewDelegateFlowLayout
{
    var seriesHeader: MvpSeries?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "MvpSeriesDetailCollectionHeaderViewReusableIdentifier",
                for: indexPath as IndexPath) as! MvpSeriesDetailCollectionHeaderView
            if let header = self.seriesHeader {
                headerView.configure(forItem: header)
            }
            return headerView
        }
        assert(false, "Unexpected element kind")
    }


}
