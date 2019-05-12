//
//  NavBarPushTwoViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/12/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class NavBarPushTwoViewController: DbViewController
{

    var nav: MyCustomNavigationBarView?
    
    override init()
    {
        super.init()
        self.nav = MyCustomNavigationBarView(WithViewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        // Do any additional setup after loading the view.
        self.nav?.updateNav_BackAndTitle("Day la buoc cuoi, chi co back")
    }
    
    
    @IBAction func btnPush_Click(_ sender: AnyObject) {
        
    }
    
}


extension NavBarPushTwoViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        // (cell is non-optional; no need to use ?. or !)
        // Configure your cell:
        cell!.textLabel?.text       = "Key   :----- \(indexPath.row)"
        cell!.detailTextLabel?.text = "Value :----- \(indexPath.row)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
