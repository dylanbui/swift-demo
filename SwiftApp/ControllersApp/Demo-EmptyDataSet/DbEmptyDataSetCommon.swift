//
//  DbEmptyDataSetCommon.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

class WeakObjectContainer: NSObject {
    weak var object: AnyObject?
    
    init(object: Any) {
        super.init()
        self.object = object as AnyObject
    }
}

// swiftlint:disable variable_name
internal struct AssociatedKeys {
    static var emptyDataSetDataSource = "emptyDataSetDataSource"
    static var emptyDataSetDelegate = "emptyDataSetDelegate"
    static var emptyDataView = "emptyDataView"
}

internal struct Selectors {
    static let tableViewSwizzledReloadData = #selector(UIScrollView.tb_tableViewSwizzledReloadData)
    static let tableViewSwizzledEndUpdates = #selector(UIScrollView.tb_tableViewSwizzledEndUpdates)
    @available(iOS 11.0, *)
    static let tableViewSwizzledPerformBatchUpdates = #selector(UIScrollView.tb_tableViewSwizzledPerformBatchUpdates(_:completion:))
    static let collectionViewSwizzledReloadData = #selector(UIScrollView.tb_collectionViewSwizzledReloadData)
    static let collectionViewSwizzledPerformBatchUpdates = #selector(UIScrollView.tb_collectionViewSwizzledPerformBatchUpdates(_:completion:))
}

internal struct TableViewSelectors {
    static let reloadData = #selector(UITableView.reloadData)
    static let endUpdates = #selector(UITableView.endUpdates)
    static let numberOfSections = #selector(UITableViewDataSource.numberOfSections(in:))
    @available(iOS 11.0, *)
    static let performBatchUpdates = #selector(UITableView.performBatchUpdates(_:completion:))
}

internal struct CollectionViewSelectors {
    static let reloadData = #selector(UICollectionView.reloadData)
    static let numberOfSections = #selector(UICollectionViewDataSource.numberOfSections(in:))
    static let performBatchUpdates = #selector(UICollectionView.performBatchUpdates(_:completion:))
}

internal struct DefaultValues {
    static let verticalOffset: CGFloat = 0
    static let verticalSpace: CGFloat = 12
    static let verticalSpaces = [verticalSpace, verticalSpace]
    static let titleMargin: CGFloat = 15
    static let descriptionMargin: CGFloat = 15
}

public protocol DbEmptyDataSetDataSource {
    func db_imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage?
    func db_titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString?
    func db_descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString?
    
    func db_imageTintColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor?
    func db_backgroundColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor?
    
    func db_verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat
    func db_verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat]
    func db_titleMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat
    func db_descriptionMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat
    
    func db_customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView?
}

public protocol DbEmptyDataSetDelegate {
    func db_emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool
    func db_emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool
    func db_emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool
    
    func db_emptyDataSetDidTapEmptyView(in scrollView: UIScrollView)
    
    func db_emptyDataSetWillAppear(in scrollView: UIScrollView)
    func db_emptyDataSetDidAppear(in scrollView: UIScrollView)
    func db_emptyDataSetWillDisappear(in scrollView: UIScrollView)
    func db_emptyDataSetDidDisappear(in scrollView: UIScrollView)
}

public extension DbEmptyDataSetDataSource {
    func db_imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return nil
    }
    
    func db_titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }
    
    func db_descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        return nil
    }
    
    func db_imageTintColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        return nil
    }
    
    func db_backgroundColorForEmptyDataSet(in scrollView: UIScrollView) -> UIColor? {
        return nil
    }
    
    func db_verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return DefaultValues.verticalOffset
    }
    
    func db_verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return DefaultValues.verticalSpaces
    }
    
    func db_titleMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return DefaultValues.titleMargin
    }
    
    func db_descriptionMarginForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        return DefaultValues.descriptionMargin
    }
    
    func db_customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

public extension DbEmptyDataSetDelegate {
    func db_emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func db_emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func db_emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func db_emptyDataSetDidTapEmptyView(in scrollView: UIScrollView) {
        
    }
    
    func db_emptyDataSetWillAppear(in scrollView: UIScrollView) {
        
    }
    
    func db_emptyDataSetDidAppear(in scrollView: UIScrollView) {
        
    }
    
    func db_emptyDataSetWillDisappear(in scrollView: UIScrollView) {
        
    }
    
    func db_emptyDataSetDidDisappear(in scrollView: UIScrollView) {
        
    }
}
