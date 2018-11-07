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

protocol ManageNavigationBar where Self : UIViewController {
    // protocol stuff here
    var isNavigationBarHidden: Bool { get set }
    func navigationBarHiddenForThisController() -> Void
}

// -- Khong su dung, dang nghien cuu --
extension ManageNavigationBar where Self : UIViewController {
//    var isNavigationBarHidden: Bool = false
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(self.isNavigationBarHidden, animated: true)
//        //[self.navigationController setNavigationBarHidden:self.isNavigationBarHidden animated:YES];
//    }
    
    mutating func navigationBarHiddenForThisController() -> Void {
        self.isNavigationBarHidden = true;
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

class DbViewController: UIViewController
{
    var transferParams: [String: Any] = [:]
    var returnParamsDelegate: DbIReturnDelegate!
    
    @IBOutlet weak var tblContent: UITableView!
    
    var isLoadingDataSource: Bool = false
    var verticalOffsetForEmptyDataSet: Float = 0
    var defaultTitleForEmptyDataSet: String? = nil
    var defaultImageForEmptyDataSet: UIImage? = nil
    
    var isNavigationBarHidden: Bool = false
    
    var appDelegate: AppDelegate!
    var errorCode: Int = 0
    
//
//    // -- Will be callback when network available --
//    - (void)loadDataFromServer;
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.initDbControllerData()
    }
    
    deinit {
        Notification.remove(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initDbControllerData()
    }

    func initDbControllerData() {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        // self.appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func initLoadDataForController(_ params: [String: Any]? = nil) {
        if params != nil {
            self.transferParams = params!
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Notification.post(Notification.Name.MyViewControllerDidLoad, object: self)
        
        // -- Define push notification --
        Notification.remove(self, name: Notification.Name.MyApplicationReachableNetwork)
        Notification.add(Notification.Name.MyApplicationReachableNetwork, observer: self, selector: Selector(("loadDataFromServer")), object: nil)
        
        // -- Show loading first in UITableView --
//        self.isLoadingDataSource = true
//        self.defaultTitleForEmptyDataSet = nil
//        self.defaultImageForEmptyDataSet = nil
//        self.verticalOffsetForEmptyDataSet = 0
        
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        Notification.post(Notification.Name.MyViewControllerWillAppear, object: self)
        self.navigationController?.setNavigationBarHidden(self.isNavigationBarHidden, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat
    {
        if self.verticalOffsetForEmptyDataSet != 0 {
            return CGFloat(self.verticalOffsetForEmptyDataSet)
        }
        
        if self.defaultImageForEmptyDataSet != nil {
           return  (CGFloat(Db.screenHeight()) - self.defaultImageForEmptyDataSet!.size.height)/2 - 64
        }
        
        return 100.0
//        return CGFloat((self.tblContent.tableHeaderView?.frame.size.height)!/2.0)
//         return CGFloat(Db.screenHeight()/3)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView!
    {
        // -- Network connection --
        if (errorCode == 1005) {
            let vwError = DbErrorView()
            vwError.errorNetworkConnection()
            return vwError
        }
        
        // -- Empty data --
        if (!self.isLoadingDataSource) {
            let vwError = DbErrorView()
            vwError.errorEmptyData()
            if self.defaultTitleForEmptyDataSet != nil {
                vwError.lblTitle.text = self.defaultTitleForEmptyDataSet
            }
            if self.defaultImageForEmptyDataSet != nil {
                vwError.imgError.image = self.defaultImageForEmptyDataSet
            }
            // vwError.backgroundColor = UIColor.yellow // Debug
            return vwError
        }
        
        // -- Default is loading --
        let loadingView = UIView(frame: CGRect(0, 0, Db.screenWidth(), 50))
        let activityView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityView.frame = CGRect(0, 0, 50, 50)
        activityView.center = view.center
        activityView.centerY = activityView.height/2
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        loadingView.addSubview(activityView)
        return loadingView
    }
    
}


