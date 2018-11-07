//
//  RootViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit


//class RootViewController: DbViewController {
class RootViewController: UIViewController
{
    var vclDrawer: MMDrawerController?
    var vclLeftMenu: PzLeftMenuViewController?
    var vclMain: PzMainViewController?

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.navigationBarHiddenForThisController()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // -- Save RootViewController --
//        self.appDelegate.rootViewController = self

        // Do any additional setup after loading the view.
        
//        let vcl = DemoTableViewController()
        //let vcl = TaskListViewController()
//        let vcl = TpUsersViewController()
//        let vcl = FirstViewController()
        // let vcl = SecondViewController()
//        let vcl = NetworkViewController()
//        let vcl = DemoUKitViewController()
//        let vcl = CategoriesViewController()
//        let vcl = PzLoginViewController()
        let vcl = PzListingViewController()
//        let vcl = StackScrollViewController()
        
        // -- An nut back --
        vcl.navigationItem.setHidesBackButton(true, animated:false)
        // self.navigationController?.pushViewController(vcl, animated: false)
        self.navigationController?.db_pushOrReplaceToFirstViewController(vcl, animated: false)
        
        // ---- weak var weakSelf = self
//        Utils.dispatchToBgQueue {
//            print("Bg : Say helooo delay")
//            self.delayWithSeconds(5, completion: {
//                for index in 1...100 {
//                    if index % 10 == 0 {
//                        print("index = \(index)")
//                    }
//                }
//            })
//        }
//
//        Utils.dispatchToMainQueue {
//            print("Main : Say helooo")
//            for index in 1...100 {
//                if index % 10 == 0 {
//                    print("Main = index = \(index)")
//                }
//            }
//
//        }
        
        
//        Notification.add("DA_LOGIN_THANH_CONG", observer: self, selector: #selector(showMainViewController(_:)), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    @objc func showMainViewController(_ notification: Notification) -> Void
    {
        self.createDrawerController()
        self.navigationController?.db_pushOrReplaceToFirstViewController(self.vclDrawer!, animated: true)
    }

    private func createDrawerController() -> Void
    {
        self.vclMain = PzMainViewController()
        let navMain = UINavigationController(rootViewController: self.vclMain!)
//        navMain.navigationBar.tintColor = UIColor.black
        
        self.vclLeftMenu = PzLeftMenuViewController()
//        let navLeftMenu = UINavigationController(rootViewController: self.vclLeftMenu!)
//        navLeftMenu.setNavigationBarHidden(true, animated: false)
        
        self.vclDrawer = MMDrawerController(center: navMain, leftDrawerViewController: self.vclLeftMenu)
        // self.vclDrawer?.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.vclDrawer?.showsShadow = true
        self.vclDrawer?.restorationIdentifier = "MMDrawer"
        
        self.vclDrawer?.maximumLeftDrawerWidth = CGFloat(Db.screenWidth() - 60)
        //self.vclDrawer?.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone //.all
        // self.vclDrawer?.openDrawerGestureModeMask = .none
        self.vclDrawer?.closeDrawerGestureModeMask = .all
    }
    


    
}
