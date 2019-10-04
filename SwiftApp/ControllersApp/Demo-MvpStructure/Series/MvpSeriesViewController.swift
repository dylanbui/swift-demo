//
//  MvpSeriesViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class MvpSeriesViewController: DbMvpViewController<MvpSeriesPresenter>, MvpSeriesViewAction, DbMvpTableViewAction
{
    
    var containerLoadingView: UIView {
        return self.view
    }
    
    var loadingView: UIView {
        let loadingView = MvpLoadingView()
        loadingView.color = UIColor.loadingColor
        return loadingView
    }
    
    @IBOutlet weak var mvpTableView: UITableView!
    
    // -- Su dung kieu ngam dinh thay cho :
    // typealias dataSource = DbMvpTableViewDataSource<MvpSeries, MvpSeriesTableViewCell> --
    var dataSource: DbMvpTableViewDataSource<MvpSeries, MvpSeriesTableViewCell>?
    
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
        self.dataSource = DbMvpTableViewDataSource()
        self.dataSource?.registerCell(MvpSeriesTableViewCell.self, forTableView: mvpTableView)
        // -- Add property for UITableView --
        self.mvpTableView.dataSource = dataSource
        self.mvpTableView.delegate = self
        self.mvpTableView.tableFooterView = UIView()
        self.mvpTableView.accessibilityLabel = "SeriesTableView"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}

extension MvpSeriesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        print("didSelectRowAt = \(indexPath)")
//        let item = self.arr[indexPath.row] as? [String:Any]
    }
}
