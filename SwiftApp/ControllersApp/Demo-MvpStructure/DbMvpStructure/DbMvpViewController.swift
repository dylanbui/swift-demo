//
//  DbMvpViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

class DbMvpViewController<P: DbMvpPresenter>: DbViewController //UIViewController
{
//    open var presenter: P! = P.init(withViewAction: self)
    public var presenter: P = P.init()
    
//    init()
//    {
//        super.init(nibName: nil, bundle: nil)
//        // self.presenter = P.init(withViewAction: P.ViewAction)
//        // P.init(withViewAction: P.ViewAction)
//
//        self.initDbControllerData()
//    }
//
//    required public init?(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)
//        self.initDbControllerData()
//    }
//
//    func initDbControllerData()
//    {
//
////        P.init(withViewAction: P.ViewAction)
//        //self.presenter = P.init(withViewAction: V)
//    }
    
    deinit {
        presenter.destroy()
    }
    
    open func beforeViewDidLoad()
    {

    }
    
    open override func viewDidLoad()
    {
        self.beforeViewDidLoad()
        
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
}
