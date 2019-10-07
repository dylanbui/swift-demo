//
//  DbMvpTableViewDelegate.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

public protocol DbMvpTableViewPresenter: DbMvpPresenter
{
    associatedtype ItemType
    func itemWasTapped(_ item: ItemType)
}


open class DbMvpTableViewDelegate<T: DbMvpViewDataSource, U: DbMvpTableViewPresenter>: NSObject,
UITableViewDelegate where T.ItemType == U.ItemType
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
        let item = dataSource.item(at: indexPath)
        presenter.itemWasTapped(item)
    }
}
