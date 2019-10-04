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
    @IBOutlet weak var mvpTableView: UITableView!
    
    // -- Su dung kieu ngam dinh thay cho :
    // typealias dataSource = DbMvpTableViewDataSource<MvpCharacter, MvpCharacterTableViewCell> --
    var dataSource: DbMvpTableViewDataSource<MvpCharacter, MvpCharacterTableViewCell>?
    
    // -- Init property for Class (not UIControl) --
    override func initDbControllerData()
    {
    }
    
    // -- Add property for UIControl --
    override func beforeViewDidLoad()
    {
        super.beforeViewDidLoad()
        // -- Attach DbMvpPresenter child class --
        self.presenter.attach(viewAction: self)
        // -- Make data source for UITableView --
        dataSource = DbMvpTableViewDataSource()
        dataSource?.registerCell(MvpCharacterTableViewCell.self, forTableView: mvpTableView)
        // -- Add property for UITableView --
        mvpTableView.dataSource = dataSource
        mvpTableView.delegate = self
        mvpTableView.tableFooterView = UIView()
        mvpTableView.accessibilityLabel = "CharactersTableView"
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
