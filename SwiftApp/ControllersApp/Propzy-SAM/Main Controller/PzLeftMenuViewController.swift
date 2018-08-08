//
//  PzLeftMenuViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/8/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class PzLeftMenuViewController: DbViewController
{
    var arrMenuItem: [String] = ["Action 1", "Action 1", "Action 1", "Action 1"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PzLeftMenuViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrMenuItem.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        return 65
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = arrMenuItem[indexPath.row]
        
        //        guard listing = arrListing[indexPath.row] else {
        //            print("Khong co du lieu o day")
        //        }
        //        cell!.textLabel.text = results[indexPath.row].lastname + " " + results[indexPath.row].firstname
        
        return cell!
        
        
        
        //        var cell: TaskViewCell! = tableView.dequeueReusableCell(withIdentifier: "taskViewCell") as? TaskViewCell
        //        if(cell == nil) {
        //            cell = Bundle.main.loadNibNamed("TaskViewCell", owner: self, options: nil)? [0] as! TaskViewCell
        //        }
        //
        ////        let item = self.arrTasks[indexPath.row] as? [String:AnyObject]
        ////        cell.loadCell(item)
        //
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        let item = self.arrTasks[indexPath.row] as? [String:AnyObject]
        //
        //        let vcl = TaskDetailViewController()
        //        vcl.stranferParams = item
        //        self.navigationController?.pushViewController(vcl, animated: true)
    }
    
}
