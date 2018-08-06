//
//  PzListingViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/6/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class PzListingViewController: DbViewController
{
    var arrListing: [PzListing] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
//        PzListingApi.getListing { (arr, pzResponse) in
//            for listing: PzListing in arr ?? [] {
//                print("Cat description \(listing.description)")
//            }
//            
//            self.arrListing = arr ?? []
//            self.tblContent.reloadData()
//        }
        
        
        PzListingApi.getListingDetail(withId: 1614) { (item, pzResponse) in
            if let itemListing = item {
                print("itemListing description \(itemListing.description)")
            }
        }
        
        
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

extension PzListingViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrListing.count
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
        
        let listing: PzListing = arrListing[indexPath.row]
        cell?.textLabel?.text = listing.address
        
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
