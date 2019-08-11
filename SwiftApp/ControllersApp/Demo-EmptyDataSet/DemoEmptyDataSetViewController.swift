//
//  DemoEmptyDataSetViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoEmptyDataSetViewController: BaseViewController
{
    override var emptyStatusView: DbEmptyStatusView? {
        // -- Su dung duoc cho cac phien ban > 10 --
        let view = DbEmptyDefaultStatusView()
        // -- Add Constraint for custom Button Size --
//        NSLayoutConstraint.activate([
//            view.actionButton.widthAnchor.constraint(equalToConstant: 170),
//            view.actionButton.heightAnchor.constraint(equalToConstant: 38)
//            ])
//        view.actionButton.backgroundColor = UIColor.orange
        
        // Cach 2
        view.actionButton.backgroundColor = UIColor.blue
        view.actionButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        view.actionButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        return view
    }
    
    override var emptyStatusOnView: UIView {
        return self.headerView
//        return self.tableView
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    fileprivate struct CellIdentifier {
        static let reuseIdentifier = "Cell"
    }
    
    // MARK: - Properties
    var indexPath = IndexPath()
    fileprivate var isLoading = false
    fileprivate var dataCount = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Loading"
        //self.edgesForExtendedLayout = []
        
        print("edgesForExtendedLayout = \(String(describing: self.edgesForExtendedLayout))")
//        if self.edgesForExtendedLayout.rawValue == 0 {
        if self.edgesForExtendedLayout == [] {
            print("NO navigation bar")
        }
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let status = DbEmptyStatus(isLoading: true,
                                   backgroundColor: UIColor.lightGray, description: "Loadinggggg …",
                                   verticalOffset: 5)
//        let status = DbEmptyStatus(isLoading: true,
//                                   spinnerColor: UIColor.red,
//                                   backgroundColor: UIColor.lightGray,
//                                   title: "Loading ...",
//                                   description: "Loadinggggg …",
//                                   verticalOffset: 5)
        // let status = DbEmptyStatus.simpleLoading
        self.showEmptyView(WithStatus: status)
        
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        print("debugDescription = \(self.tableView.frame.debugDescription)")
    }
    
    func fetchData(_ result: Bool = false)
    {
        let delayTime = DispatchTime.now() + Double(Int64(5.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            
            let done = result
            
            if done {
                print("Hide status !!!")
                self.hideEmptyViewStatus()

                // -- Done load --
                self.dataCount = 7
                self.tableView.reloadData()
            } else {
                self.emptyStatus()
            }
        }
    }
    
    func emptyStatus()
    {
        title = "Empty" // iconEmpty
        
//        let status = DbEmptyStatus(title: "no Data", actionTitle: "Retry ⭐️", image: UIImage(named: "placeholder_instagram"))
        
        let status = DbEmptyStatus(title: "no Data", actionTitle: "Retry ⭐️", image: UIImage(named: "iconEmpty")) {
            // self.hideStatus()
            // -- Show loading --
            let status = DbEmptyStatus.simpleLoading
            self.showEmptyView(WithStatus: status)

            self.fetchData(true)
        }
        
//        let status = DbEmptyStatus(title: "no Data", description: "No data available.💣", actionTitle: "Retry ⭐️", image: UIImage(named: "placeholder_instagram")) {
//            // self.hideStatus()
//
//            // -- Show loading --
//            let status = DbEmptyStatus.simpleLoading
//            self.show(emptyStatus: status)
//
//            self.fetchData(true)
//        }
        
        self.showEmptyView(WithStatus: status)
        
        // -- Auto hide --
//        let delayTime = DispatchTime.now() + Double(Int64(4.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
//            self.hideStatus()
//        }
    }
    
}

//extension DemoEmptyDataSetViewController: DbEmptyStatusController
//{
//    var emptyStatusView: DbEmptyStatusView? {
//        return CustomViewEmpty()
//        // -- Su dung duoc cho cac phien ban > 10 --
////        let view = DbEmptyDefaultStatusView()
////        // -- Add Constraint for custom Button Size --
////        NSLayoutConstraint.activate([
////            view.actionButton.widthAnchor.constraint(equalToConstant: 170),
////            view.actionButton.heightAnchor.constraint(equalToConstant: 38)
////            ])
////        view.actionButton.backgroundColor = UIColor.orange
////        return view
//
////        let view = DbEmptyCustomStatusView()
////        view.actionButton.backgroundColor = UIColor.orange
////        view.actionButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
////        view.actionButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
////        return view //DbEmptyCustomStatusView()
//    }
//}

extension DemoEmptyDataSetViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.reuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: CellIdentifier.reuseIdentifier)
        }
        cell!.textLabel?.text = "Cell"
        cell!.detailTextLabel?.text = "Click to delete"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // let item = self.arr[indexPath.row] as? [String:AnyObject]
    }
}


