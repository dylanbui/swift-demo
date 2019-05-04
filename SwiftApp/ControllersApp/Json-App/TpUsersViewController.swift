//
//  TpUsersViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
//import DZNEmptyDataSet

class TpUsersViewController: BaseViewController
{
    // @IBOutlet weak var tblContent: UITableView!
    var arrUser: [User] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Users List"
        //self.navigationBarHiddenForThisController()
        self.navigationItem.hidesBackButton = true
        
        print("TpUsersViewController")

        // Do any additional setup after loading the view.
        
        //var arrUser:[User] = []
        
        

        // -- lay du lieu sau 2s --
        DbUtils.performAfter(delay: 2.0) {
            User.getAll { (arrUser) in
                self.arrUser = arrUser
    //            print("arrUser.debugDescription = \(arrUser.debugDescription)")
    //            print("arrUser.count = \(arrUser.count)")
    //            let u = arrUser[0] as User
    //            print("User = \(u.toJSONString(prettyPrint: true))")
                self.tblContent.reloadData()
            }
        }
        
    }


}

extension TpUsersViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrUser.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 65
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let user:User = self.arrUser[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
}

extension TpUsersViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // let user: User = self.arrUser[indexPath.row]
        
        let vcl = TpPostsViewController()
        vcl.user = self.arrUser[indexPath.row];
        self.navigationController?.pushViewController(vcl, animated: true)
    }
    
}

