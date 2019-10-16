//
//  MvpSeriesViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

// MARK: - Delegate

protocol MvpSeriesViewControllerGotoDelegate: class
{
    func gotoMvpSeriesDetail(_ controller: MvpSeriesViewController, item: MvpSeries)
}

class MvpSeriesViewController: DbMvpViewController<MvpSeriesPresenter>, MvpSeriesViewAction, DbMvpTableViewAction
{
    // TODO: Con dang bi loi loading, se xu ly sau
    
    weak var gotoDelegate: MvpSeriesViewControllerGotoDelegate?
    
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
    var delegate: UITableViewDelegate?
    
    // -- Init property for Class (not UIControl) --
    override func initDbControllerData()
    {
    }
    
    // -- Add property for UIControl --
    override func beforeViewDidLoad()
    {
        super.beforeViewDidLoad()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // -- Attach DbMvpPresenter child class --
        self.presenter.attach(viewAction: self)
        // -- Make data source for UITableView --
        self.dataSource = DbMvpTableViewDataSource()
        self.dataSource?.registerCell(MvpSeriesTableViewCell.self, forTableView: mvpTableView)
        // -- Add property for UITableView --
        self.mvpTableView.dataSource = dataSource
        //        self.mvpTableView.delegate = self
        // self.delegate = DbMvpTableViewDelegate(dataSource: self.dataSource!, presenter: self)
        
        self.delegate = DbMvpTableViewDelegate(dataSource: self.dataSource!, presenter: self)
        self.mvpTableView.delegate = self.delegate
        
        self.mvpTableView.tableFooterView = UIView()
        self.mvpTableView.accessibilityLabel = "SeriesTableView"
        self.mvpTableView.rowHeight = 50 // Fix height size
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        // Do any additional setup after loading the view.
    }


}

extension MvpSeriesViewController: DbMvpTableViewPresenter
{
    func itemWasTapped(_ item: MvpSeries, at indexPath: IndexPath)
    {
        // -- Su dung NavigationDelegate --
        self.gotoDelegate?.gotoMvpSeriesDetail(self, item: item)
        // -- Van su dung duoc cach di chuyen cu, nhung chi nen dung voi cac control --
//        let vcl = MvpSeriesDetailViewController()
//        vcl.presenter = MvpSeriesDetailPresenter.init(ui: vcl, seriesName: item.name)
//        vcl.dataSource = MvpSeriesDetailCollectionViewDataSource()
//        self.navigationController?.pushViewController(vcl, animated: true)
    }
}

//extension MvpSeriesViewController: UITableViewDelegate
//{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        tableView.deselectRow(at: indexPath, animated: true)
//        print("didSelectRowAt = \(indexPath)")
////        let item = self.arr[indexPath.row] as? [String:Any]
//
//        let item = self.dataSource?.item(at: indexPath)
//
//        let vcl = MvpSeriesDetailViewController()
//        vcl.presenter = MvpSeriesDetailPresenter.init(ui: vcl, seriesName: item?.name ?? "")
//        self.navigationController?.pushViewController(vcl, animated: true)
//
//    }
//}
