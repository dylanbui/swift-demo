//
//  DemoCustomPullForProjectViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoCustomPullForProjectViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var dataSources: [String] = []
    var fetchingMore = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        super.viewDidLoad()
        self.navigationItem.title = "Full to refresh"
        
        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = []
        
        // -- Start load data --
        self.startLoadData()
        
//        let refreshView = DbPullLoadView()
//        refreshView.delegate = self
//        self.tableView.addPullLoadableView(refreshView, type: .refresh)
        // self.tableView.contentInset.top = 50
        
        //        self.tableView.addPullToHandlerView(type: .refresh) {
        //            print("++ refreshView.startLoading")
        //
        //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
        //                self.tableView.stopPullToHandlerView(type: .refresh)
        //                self.tableView.reloadData()
        //            }
        //        }
        
        // -- forScreen : Save last update each screen page --
        self.tableView.db_addPullToHandlerView(type: .refresh, forScreen: .listing) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                
                self.startLoadData()
                
                self.tableView.db_stopPullToHandlerView(type: .refresh)
                self.tableView.reloadData()
            }
        }
        
        self.tableView.db_addPullToHandlerView(type: .loadMore) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                
                var arrLoadMore: [String] = []
                for i in 0..<10
                {
                    arrLoadMore.append("LoadMore - Cell data -- " + String(self.dataSources.count + i))
                }
                
                self.dataSources.append(contentsOf: arrLoadMore)
                
                self.fetchingMore = false
                
                self.tableView.db_stopPullToHandlerView(type: .loadMore)
                self.tableView.reloadData()
            
            })
        }
        
    }
    
    func startLoadData()
    {
        self.dataSources.removeAll()
        
        // -- Start load data --
        for i in 0..<40 {
            self.dataSources.append("StartLoad - Cell data -- " + String(i))
        }
    }
    
    func beginBatchFetch()
    {
        fetchingMore = true
        print("Call API here..")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
            print("Consider this as API response.")
            
            var arrLoadMore: [String] = []
            for i in 0..<10
            {
                arrLoadMore.append("LoadMore - Cell data -- " + String(self.dataSources.count + i))
            }
            
            self.dataSources.append(contentsOf: arrLoadMore)
            
            self.fetchingMore = false
            self.tableView.reloadData()
        })
    }


}

// MARK: - UITableView data source -------------------

extension DemoCustomPullForProjectViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.backgroundColor = .getColor(with: indexPath.row)
        cell?.textLabel?.text = self.dataSources[indexPath.row]
        return cell!
    }
    
    // -- Load more with best practice --
    // Cach nay nen dung hon la self.tableView.addPullToHandlerView(type: .loadMore)
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        let cellBuffer: CGFloat = 10
//        let cellHeight: CGFloat = 50
//
//        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
//        let buffer: CGFloat = cellBuffer * cellHeight
//        let scrollPosition = scrollView.contentOffset.y
//        // Reached the bottom of the list
//        if scrollPosition > bottom - buffer {
//            if !fetchingMore {
//                beginBatchFetch()
//            }
//        }
//    }
}

