//
//  MvpSeriesDetailViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

private struct Config
{
    static let numberOfColumns = 3
    static let cellHeight = 174
    static let headerHeight = 534
    static let footerHeight = 20
    static let cellMargin = 20
}

class MvpSeriesDetailViewController: DbMvpViewController<MvpSeriesDetailPresenter>, MvpSeriesDetailViewAction, DbMvpCollectionViewAction
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: MvpSeriesDetailCollectionViewDataSource!

    // typealias dataSource = DbMvpTableViewDataSource<MvpSeries, MvpSeriesTableViewCell> --
    // var dataSource: DbMvpTableViewDataSource<MvpSeries, MvpSeriesTableViewCell>?
    
//    func setNavigationTitle(_ title: String)
//    {
//        self.setNavigationTitleWithAnimation(title)
//    }
    
    override func beforeViewDidLoad()
    {
        super.beforeViewDidLoad()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureCollectionView()
    }

    func configureHeader(_ series: MvpSeries)
    {
         dataSource.seriesHeader = series
    }

    private func configureCollectionView()
    {
        // Khong hieu sao ko chay duoc vao ham 
//        self.collectionView.register(MvpSeriesDetailCollectionHeaderView.self,
//                                     forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
//                                     withReuseIdentifier: "MvpSeriesDetailCollectionHeaderViewReusableIdentifier")
//
//        self.collectionView.register(UINib(nibName: "MvpSeriesDetailCollectionHeaderView", bundle: nil),
//                                     forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
//                                     withReuseIdentifier: "MvpSeriesDetailCollectionHeaderViewReusableIdentifier")
        
        // MvpComicCollectionViewCellIdentifier
        
        self.collectionView.register(MvpComicCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "MvpComicCollectionViewCellIdentifier")
                                                                //MvpComicCollectionViewCellIdentifier
        self.collectionView.register(UINib(nibName: "MvpComicCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "MvpComicCollectionViewCellIdentifier")

        //self.dataSource = MvpSeriesDetailCollectionViewDataSource()
        // let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        // let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        // let topInset = navBarHeight + statusBarHeight
        collectionView.accessibilityLabel = "ComicsCollectionView"
        // collectionView.contentInset = UIEdgeInsetsMake(-topInset, 0, 0, 0)
        collectionView.dataSource = self.dataSource
        // collectionView.delegate = nil
        
        let layout = UICollectionViewFlowLayout()
        // layout.sectionHeadersPinToVisibleBounds = true
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: CGFloat(Config.headerHeight))
        layout.itemSize = CGSize(
            width: view.frame.width / CGFloat(Config.numberOfColumns),
            height: CGFloat(Config.cellHeight))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = CGFloat(Config.cellMargin)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }



}
