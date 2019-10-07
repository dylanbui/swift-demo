//
//  MvpSeriesDetailCollectionViewDataSource.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation


class MvpSeriesDetailCollectionViewDataSource: DbMvpCollectionViewDataSource<MvpComic, MvpComicCollectionViewCell>
{
    var seriesHeader: MvpSeries?
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
            if kind == UICollectionElementKindSectionHeader {
                let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "MvpSeriesDetailCollectionHeaderViewReusableIdentifier",
                    for: indexPath as IndexPath)
                    as! MvpSeriesDetailCollectionHeaderView
                if let header = self.seriesHeader {
                    headerView.configure(forItem: header)
                }
                return headerView
            }
            assert(false, "Unexpected element kind")
    }

}
