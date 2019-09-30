//
//  DbMvpTableView.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

public protocol DbMvpTableViewAction: class
{
    var tableView: UITableView! { get }
    
    associatedtype TableViewDataSource: DbMvpViewDataSource
    var dataSource: TableViewDataSource? { get set }
}

public extension DbMvpTableViewAction
{
    func doReloadTableView(items: [TableViewDataSource.ItemType])
    {
        self.show(items: items)
    }
    
    func show(items: [TableViewDataSource.ItemType])
    {
        dataSource?.items = items
        tableView.reloadData()
    }

}
