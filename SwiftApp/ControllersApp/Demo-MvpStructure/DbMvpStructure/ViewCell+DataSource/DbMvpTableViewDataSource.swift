//
//  DbMvpTableViewDataSource.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import Foundation

open class DbMvpTableViewDataSource<U, V: DbMvpViewCell> : NSObject, UITableViewDataSource,
    DbMvpViewDataSource where U == V.ItemType
{
//    open func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
//    open func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String)

    
    func registerCell(_ cellClass: AnyClass?, forTableView tableView: UITableView)
    {
        tableView.register(cellClass,
                           forCellReuseIdentifier: V.identifier)
        tableView.register(UINib(nibName: V.cellClassName, bundle: nil),
                           forCellReuseIdentifier: V.identifier)

//        tableView.register(cellClass, forCellWithReuseIdentifier: V.identifier)
//        tableView.register(cellClass, forCellReuseIdentifier: V.identifier)
    }
    
    open var items = [U]()
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: V.identifier, for: indexPath) as UITableViewCell
        let item = self.item(at: indexPath)
        (cell as! V).configure(forItem: item)
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
}
