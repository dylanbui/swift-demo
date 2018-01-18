//
//  DbViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/16/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit
import DZNEmptyDataSet
import SVPullToRefresh

class DbViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0;
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return nil;
//    }
    
    
    var stranferParams: [String:AnyObject]!
    var returnParamsDelegate: DbIReturnDelegate!
    
    @IBOutlet weak var tblContent: UITableView!
    
    var isLoadingDataSource: Bool = true
    var verticalOffsetForEmptyDataSet: Float = 0
    var titleForEmptyDataSet: String? = nil
    var defaultImageForEmptyDataSet: UIImage? = nil
    
    fileprivate var isNavigationBarHidden: Bool = false
    
    var appDelegate: AppDelegate? = nil
    var errorCode: Int = 0
    
//
//    // -- Will be callback when network available --
//    - (void)loadDataFromServer;
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.initDbControllerData()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initDbControllerData()
    }

    func initDbControllerData() {
        self.appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        // self.appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func initLoadDataForController(_ params: [String: AnyObject]? = nil) {
//        [String:AnyObject]!
        self.stranferParams = params
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DbUtils.postNotification(DbNotify.VclDidLoad.rawValue, object: self)
        
        // -- Define push notification --
        DbUtils.removeNotification(self, name: DbNotify.ReachableNetwork.rawValue)
        DbUtils.addNotification(DbNotify.ReachableNetwork.rawValue, observer: self, selector: Selector(("loadDataFromServer")), object: nil)
        
        // -- Show loading first in UITableView --
        self.isLoadingDataSource = true;
        
        self.titleForEmptyDataSet = nil;
        self.defaultImageForEmptyDataSet = nil;
        self.verticalOffsetForEmptyDataSet = 0;
        
        if let tbl = self.tblContent {
            tbl.rowHeight = UITableViewAutomaticDimension;
            tbl.estimatedRowHeight = 44;
            tbl.delegate = self as? UITableViewDelegate;
            tbl.dataSource = self as? UITableViewDataSource;
            
            tbl.emptyDataSetSource = self;
            tbl.emptyDataSetDelegate = self;
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(self.isNavigationBarHidden, animated: true)
        //[self.navigationController setNavigationBarHidden:self.isNavigationBarHidden animated:YES];
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationBarHiddenForThisController() {
        self.isNavigationBarHidden = true;
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func loadDataFromServer() {
        
    }
    
//    @objc func loadDataFromServer() {
//
//    }
    
    // MARK: - DZNEmptyDataSetSource
    // MARK: -
    
}



