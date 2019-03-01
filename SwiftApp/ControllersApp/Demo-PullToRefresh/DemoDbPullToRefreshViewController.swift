//
//  DemoDbPullToRefreshViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

// -- Demo pull to refresh and load more --

import UIKit

extension UIColor {
    class func getColor(with row: Int) -> UIColor {
        return [.red, .blue, .green, .orange, .yellow][(row / 10) % 5]
    }
}

class DemoDbPullToRefreshViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var dataSources: [String] = []
    var fetchingMore = false

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

extension DemoDbPullToRefreshViewController: UITableViewDataSource, UITableViewDelegate
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let cellBuffer: CGFloat = 10
        let cellHeight: CGFloat = 50
        
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = cellBuffer * cellHeight
        let scrollPosition = scrollView.contentOffset.y
        // Reached the bottom of the list
        if scrollPosition > bottom - buffer {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
}
