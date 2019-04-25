//
//  DemoEmptyDataSetViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoEmptyDataSetViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
         let status = DbEmptyStatus(isLoading: true, description: "Loadinggggg …")
//        let status = DbEmptyStatus(isLoading: true,
//                                   spinnerColor: UIColor.red,
//                                   backgroundColor: UIColor.white,
//                                   description: "Loadinggggg …", verticalOffset: 160)
//        // let status = DbEmptyStatus.simpleLoading
//
        show(emptyStatus: status)
        
        // self.fetchData()
    }
    
    func fetchData(_ result: Bool = false)
    {
        let delayTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            
            let done = result
            
            if done {
                print("Hide status !!!")
                self.hideEmptyStatus()

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
        title = "Empty"
        
//        let status = DbEmptyStatus.init(image: UIImage(named: "placeholder_instagram"),
//                                        title: "no Data", description: "No data available.💣",
//                                        actionTitle: "Retry ⭐️") {
//
//                                            // -- Show loading --
//                                            let status = DbEmptyStatus.simpleLoading
//                                            self.show(emptyStatus: status)
//                                            self.fetchData(true)
//        }
//
//        self.show(emptyStatus: status)
        
        let btn = UIButton.init(type: .system)
        btn.frame = CGRect.init(0, 0, 100, 75)
        btn.backgroundColor = UIColor.orange
        btn.setTitle("bấm zô", for: UIControl.State())
        btn.onTap { (tapGesture) in
            // -- Show loading --
            let status = DbEmptyStatus.simpleLoading
            self.show(emptyStatus: status)
            self.fetchData(true)
            print("CUng lam giong nhu ai")
        }
        
        let statusBtn = DbEmptyStatus.init(image: UIImage(named: "placeholder_instagram"),
                                        title: "no Data", description: "No data available.💣",
                                        actionButton: btn)
        
        self.show(emptyStatus: statusBtn)


//        let status = DbEmptyStatus(title: "no Data", description: "No data available.💣", actionTitle: "Retry ⭐️", image: UIImage(named: "placeholder_instagram")) {
//            // self.hideStatus()
//            
//            // -- Show loading --
//            let status = DbEmptyStatus.simpleLoading
//            self.show(emptyStatus: status)
//            
//            self.fetchData(true)
//        }
//        
//        self.show(emptyStatus: status)
        
        // -- Auto hide --
//        let delayTime = DispatchTime.now() + Double(Int64(4.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
//            self.hideStatus()
//        }
    }
    
}

extension DemoEmptyDataSetViewController: DbEmptyStatusController
{
    public var statusView: DbEmptyStatusView? {
        // 375, 300
        return CustomViewEmpty() //.init(frame: CGRect(0, 0, 375, 300))
//         return DbEmptyDefaultStatusView()
//        let view = DbEmptyDefaultStatusView()
//        return DbEmptyDefaultStatusView()
    }
}

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


