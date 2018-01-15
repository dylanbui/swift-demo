//
//  DbViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/16/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

class DbViewController: UIViewController
{
    
    var stranferParams: [String:AnyObject]!
    var returnParamsDelegate: DbIReturnDelegate!
    
    
//    @property (nonatomic, strong) NSMutableDictionary* stranferParams;
//    @property (strong) AppDelegate *appDelegate;
//    @property (weak) id <ICallbackParentDelegate> callbackParentDelegate;
//
//
//    @property (nonatomic) BOOL isLoadingDataSource;
//
//    @property (weak, nonatomic) IBOutlet UITableView *tblContent;
//
//    @property (nonatomic) float verticalOffsetForEmptyDataSet;
//    @property (nonatomic, strong) NSString  *titleForEmptyDataSet;
//    @property (nonatomic, strong) UIImage *defaultImageForEmptyDataSet;
//
//
//    - (void)initLoadDataForController:(id)params;
//
//    - (void)navigationBarHiddenForThisController;
//
//    // -- Will be callback when network available --
//    - (void)loadDataFromServer;

    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension DbViewController: DbIReturnDelegate {
    // MARK: - IReturnParamsDelegate
    // MARK: -
    func onReturn(params: [String : AnyObject], callerId: Int) {
        
    }
}


