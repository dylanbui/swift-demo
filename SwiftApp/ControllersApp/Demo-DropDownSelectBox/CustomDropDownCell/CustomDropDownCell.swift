//
//  CustomDropDownCell.swift
//  DbDropDownView
//
//  Created by Dylan Bui on 10/31/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import UIKit

class CustomDropDownCell: UITableViewCell
{
    @IBOutlet weak var subLabel: UILabel!
    
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
