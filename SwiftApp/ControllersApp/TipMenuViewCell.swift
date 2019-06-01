//
//  TipMenuViewCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class TipMenuViewCell: UITableViewCell
{
    var vclParent: UIViewController?
    var indexPath: IndexPath?
    
    @IBOutlet weak var btnTip: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBAction func btnTip_Click(_ sender: UIButton)
    {
        let menu = DbTipMenuView()
        menu.dataSourceStrings(["Action 1", "Action 2", "Action 3", "Action 4"])
        menu.didSelect { (dataSource, index) in
            // print("dataSource = \(dataSource)")
            print("index = \(String(describing: index))")
            print("self.indexPath = \(String(describing: self.indexPath))")
        }
        
        menu.showMenu(forView: sender, withinSuperview: self.vclParent?.view)
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
