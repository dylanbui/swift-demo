//
//  TpPostsViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class TpPostsViewController: BaseViewController
{
    // @IBOutlet weak var tblContent: UITableView!
    var user: User!
    var arrPost: [Post] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = self.user.name
//        self.navigationItem.title = "Posts by"
//        if let name = self.user.name {
//            self.navigationItem.title = "Posts by" + name
//        }
        
        Post.getByUser(self.user) { (arrPost) in
            self.arrPost = arrPost
            self.tblContent.reloadData()
        }
    }
    
    
}

extension TpPostsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let post: Post = self.arrPost[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
}

extension TpPostsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


