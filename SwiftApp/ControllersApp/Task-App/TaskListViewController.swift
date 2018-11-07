//
//  TaskListViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/20/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class TaskListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    
    // @IBOutlet weak var tblContent: UITableView!
    var arrTasks: [AnyObject]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Task List"

        // Do any additional setup after loading the view.
        
        SwiftyPlistManager.shared.getValue(for: "DemoJob", fromPlistWithName: "DemoData") { (anyData, error) in
            self.arrTasks = anyData as? [AnyObject]
            self.tblContent.reloadData()
        }
        
        
        Utils.hi()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let btnAdd = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addItem(sender:))
        )
        self.navigationItem.rightBarButtonItem = btnAdd
    }
    
    @objc func addItem(sender: UIBarButtonItem)
    {
        let vcl = TaskUpdateViewController()
        let item = self.arrTasks[0] as? [String: Any]
        vcl.transferParams = item!
        vcl.returnParamsDelegate = self
        self.navigationController?.pushViewController(vcl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: TaskViewCell! = tableView.dequeueReusableCell(withIdentifier: "taskViewCell") as? TaskViewCell
        if(cell == nil) {
            cell = Bundle.main.loadNibNamed("TaskViewCell", owner: self, options: nil)? [0] as! TaskViewCell
        }
        
        let item = self.arrTasks[indexPath.row] as? [String:AnyObject]
        cell.loadCell(item)

        return cell        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arrTasks[indexPath.row] as? [String: Any]
        
        let vcl = TaskDetailViewController()
        vcl.transferParams = item!
        self.navigationController?.pushViewController(vcl, animated: true)
    }

    
}

extension TaskListViewController: DbIReturnDelegate {
    func onReturn(params: [String : Any]?, callerId: Int)
    {
        print("\(callerId)")
        print("\(params.debugDescription)")
        
        self.arrTasks.append(params as AnyObject)
        self.tblContent.reloadData()
        
        SwiftyPlistManager.shared.save(self.arrTasks, forKey: "DemoJob", toPlistWithName: "DemoData")
        { (errer) in
            if errer != nil {
                print("Da them du lieu")
            }
        }
        
    }
    
    
}


