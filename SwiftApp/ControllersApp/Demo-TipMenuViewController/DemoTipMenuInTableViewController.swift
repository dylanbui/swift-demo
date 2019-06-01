//
//  DemoTipMenuInTableViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoTipMenuInTableViewController: BaseViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "DemoTipMenuInTable"
        // Do any additional setup after loading the view.
    }



}

/*
 // -- Fixed rowHeight of UITableViewCell --
 self.tblContent.rowHeight = 164.0 // UITableViewAutomaticDimension
 self.tblContent.estimatedRowHeight = 0
 
 // -- Height of UITableViewCell define by constraint --
 //        self.tblContent.rowHeight = UITableViewAutomaticDimension
 //        self.tblContent.estimatedRowHeight = 164.0
 
 self.tblContent.estimatedSectionHeaderHeight = 0
 self.tblContent.estimatedSectionFooterHeight = 0
 
 */

extension DemoTipMenuInTableViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: TipMenuViewCell! = tableView.dequeueReusableCell(withIdentifier: "TipMenuViewCell") as? TipMenuViewCell
        if(cell == nil) {
            cell = Bundle.main.loadNibNamed("TipMenuViewCell", owner: self, options: nil)?.first as? TipMenuViewCell
        }
        
        cell.lblTitle.text = "indexPath.row = \(indexPath.row)"
        cell.vclParent = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

}

