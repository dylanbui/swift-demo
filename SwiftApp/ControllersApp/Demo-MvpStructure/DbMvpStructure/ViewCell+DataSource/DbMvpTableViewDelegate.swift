//
//  DbMvpTableViewDelegate.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

public protocol DbMvpTableViewPresenter
{
    associatedtype ItemType
    func itemWasTapped(_ item: ItemType, at indexPath: IndexPath)
}

open class DbMvpTableViewDelegate<T: DbMvpViewDataSource, U: DbMvpTableViewPresenter>:
    NSObject, UITableViewDelegate where T.ItemType == U.ItemType
{
    fileprivate let dataSource: T
    fileprivate let presenter: U

    public init(dataSource: T, presenter: U)
    {
        self.dataSource = dataSource
        self.presenter = presenter
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = dataSource.item(at: indexPath)
        presenter.itemWasTapped(item, at: indexPath)
    }
}
