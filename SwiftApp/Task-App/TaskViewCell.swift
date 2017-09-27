//
//  TaskViewCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/20/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell
{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var cellData: [String:AnyObject]!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    // -- [String:AnyObject]! => allow nil value --
    func loadCell(_ params: [String:AnyObject]!)
    {
        cellData = params
        
        self.lblName.text = cellData["name"] as? String
        self.lblDesc.text = cellData["title"] as? String
        self.lblDate.text = cellData["datetime"] as? String
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
