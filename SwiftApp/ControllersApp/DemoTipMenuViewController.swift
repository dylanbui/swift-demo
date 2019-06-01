//
//  DemoTipMenuViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/31/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoTipMenuViewController: BaseViewController
{
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBottomMenu: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Tip Menu"

        // Do any additional setup after loading the view.
        
        let btnAdd = UIBarButtonItem(
            title: "Phường",
            style: .plain,
            target: self,
            action: #selector(self.btnBarItem_Click(_:))
        )
        self.navigationItem.rightBarButtonItem = btnAdd
        
    }
    
    let menu = DbTipMenuView()

    @IBAction func btnBarItem_Click(_ sender: UIBarButtonItem!)
    {
        //let menu = DbTipMenuView()
        if menu.isShow == true {
            return
        }
        
        menu.theme = DbTipMenuViewTheme.blueTheme()
        menu.selectedIndex = 2
        
        menu.dataSourceStrings(["UIBarButtonItem 1", "UIBarButtonItem 2", "UIBarButtonItem 3", "UIBarButtonItem 4"])
        menu.didSelect { (dataSource, index) in
            print("dataSource = \(dataSource)")
            print("index = \(String(describing: index))")
            
        }
        
        // menu.showMenu(forView: self.btnMenu)
        menu.showMenu(forBarItem: sender, withinSuperview: self.view)
    }

    @IBAction func btnMenu_Click(_ sender: UIButton!)
    {
        
        let menu = DbTipMenuView()
        menu.dataSourceStrings(["Action 1", "Action 2", "Action 3", "Action 4"])
        menu.didSelect { (dataSource, index) in
            print("dataSource = \(dataSource)")
            print("index = \(String(describing: index))")
        
        }
        
        // menu.showMenu(forView: self.btnMenu)
        menu.showMenu(forView: sender, withinSuperview: self.view)
    }
    
    @IBAction func btnBottomMenu_Click(_ sender: UIButton!)
    {
        
        let menu = DbTipMenuView()
        menu.dataSourceStrings(["Action 1", "Action 2", "Action 3", "Action 4"])
        menu.didSelect { (dataSource, index) in
            print("dataSource = \(dataSource)")
            print("index = \(String(describing: index))")
            
        }
        
        // menu.showMenu(forView: self.btnMenu)
        menu.showMenu(forView: sender, withinSuperview: self.view)
        
        
    }


}
