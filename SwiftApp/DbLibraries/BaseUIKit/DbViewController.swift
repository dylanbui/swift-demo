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

class DbViewController: UIViewController
{
    var stranferParams: [String:AnyObject]!
    var returnParamsDelegate: DbIReturnDelegate!
    
    @IBOutlet weak var tblContent: UITableView!
    
    var isLoadingDataSource: Bool = true
    var verticalOffsetForEmptyDataSet: Float = 0
    var titleForEmptyDataSet: String? = nil
    var defaultImageForEmptyDataSet: UIImage? = nil
    
    fileprivate var isNavigationBarHidden: Bool = false
    
    var appDelegate: AppDelegate!
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
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        DbNotification.post(DbNotification.Name.MyViewControllerDidLoad.rawValue, object: self)
        
        // -- Define push notification --
        DbUtils.removeNotification(self, name: DbNotify.ReachableNetwork.rawValue)
        DbUtils.addNotification(DbNotify.ReachableNetwork.rawValue, observer: self, selector: Selector(("loadDataFromServer")), object: nil)
        
        // -- Show loading first in UITableView --
        self.isLoadingDataSource = true
        
        self.titleForEmptyDataSet = nil
        self.defaultImageForEmptyDataSet = nil
        self.verticalOffsetForEmptyDataSet = 0
        
        if let tbl = self.tblContent {
            tbl.rowHeight = UITableViewAutomaticDimension
            tbl.estimatedRowHeight = 44;
            tbl.delegate = self as? UITableViewDelegate
            tbl.dataSource = self as? UITableViewDataSource
            
            // -- Da dinh nghia trong cung file roi nen khong can ep kieu as?
            tbl.emptyDataSetSource = self as DZNEmptyDataSetSource
            tbl.emptyDataSetDelegate = self as? DZNEmptyDataSetDelegate
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
    
    func setNavigationTitleWithAnimation(_ title: String) {
        let caAnimation: CAAnimation? = self.navigationController?.navigationBar.layer.animation(forKey: "fadeText")
        
        if caAnimation != nil {
            let fadeTextAnimation = CATransition()
            fadeTextAnimation.duration = 0.5
            fadeTextAnimation.type = kCATransitionFade
            
            self.navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        }
        self.navigationItem.title = title
    }
    
    
}

// MARK: - DZNEmptyDataSetSource
// MARK: -

extension DbViewController: DZNEmptyDataSetSource {

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        if self.verticalOffsetForEmptyDataSet != 0 {
            return CGFloat(self.verticalOffsetForEmptyDataSet)
        }
        return CGFloat((self.tblContent.tableHeaderView?.frame.size.height)!/2.0)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        // -- Network connection --
        if (errorCode == 1005) {
            let vwError = DbErrorView()
            vwError.errorNetworkConnection()
            return vwError
//            DbErrorView *vwError = [[DbErrorView alloc] init];
//            [vwError errorNetworkConnection];
//            return vwError;
        }
        
        // -- Empty data --
        if (!self.isLoadingDataSource) {
            let vwError = DbErrorView()
            vwError.errorEmptyData()
            if self.titleForEmptyDataSet != nil {
                vwError.lblTitle.text = self.titleForEmptyDataSet;
            }
            if self.defaultImageForEmptyDataSet != nil {
                vwError.imgError.image = self.defaultImageForEmptyDataSet;
            }
            return vwError
//            DbErrorView *vwError = [[DbErrorView alloc] init];
//            [vwError errorEmptyData];
//            if (self.titleForEmptyDataSet != nil) {
//                vwError.lblTitle.text = self.titleForEmptyDataSet;
//            }
//            if (self.defaultImageForEmptyDataSet != nil) {
//                vwError.imgError.image = self.defaultImageForEmptyDataSet;
//            }
//            return vwError;
        }
        
        // -- Default is loading --
        let activityView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityView.startAnimating()
        return activityView        
    }
    
}


