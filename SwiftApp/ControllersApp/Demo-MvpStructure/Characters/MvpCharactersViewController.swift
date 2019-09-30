//
//  MvpCharactersViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class MvpCharactersViewController: DbMvpViewController<MvpCharactersPresenter>, DbMvpTableViewAction, MvpCharactersViewAction
{
    //typealias TableViewDataSource = DbMvpTableViewDataSource<MvpCharacter, MvpCharacterTableViewCell>
    
    @IBOutlet weak var tableView: UITableView!
    // var dataSource: DbMvpTableViewDataSource<MvpCharacter, MvpCharacterTableViewCell>!
    // Su dung default DataSource
    // var dataSource: TableViewDataSource = TableViewDataSource()
    var dataSource: DbMvpTableViewDataSource<MvpCharacter, MvpCharacterTableViewCell>?
    // var delegate: UITableViewDelegate!
    
    //var dataSourceTest: DbMvpTableViewDataSource<MvpCharacter, MvpCharacterTableViewCell>?
    
    // -- Init property for Class (not UIControl) --
    override func initDbControllerData()
    {
    }
    
    // -- Add property for UIControl --
    override func beforeViewDidLoad()
    {
        super.beforeViewDidLoad()
        
        self.presenter.attach(viewAction: self)
        
        dataSource = DbMvpTableViewDataSource()
        dataSource?.registerCell(MvpCharacterTableViewCell.self, forTableView: tableView)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.accessibilityLabel = "CharactersTableView"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    
    

}

extension MvpCharactersViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        print("didSelectRowAt = \(indexPath)")
        
//        let item = self.arr[indexPath.row] as? [String:Any]
    }
}



//extension MvpCharactersViewController: MvpCharactersViewAction
//{
//    func show(items: [MvpCharacter])
//    {
//        //self.tableViewReload(items: items)
//
//
//    }
//
//
//
//}
