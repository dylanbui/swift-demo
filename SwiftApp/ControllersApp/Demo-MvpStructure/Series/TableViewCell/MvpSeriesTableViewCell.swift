//
//  MvpSeriesTableViewCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class MvpSeriesTableViewCell: DbTableViewCell, DbMvpViewCell
{
    @IBOutlet weak var seriesNameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(forItem item: MvpSeries)
    {
        self.seriesNameLabel.text = item.name
        self.seriesNameLabel.accessibilityLabel = item.name
        self.accessoryType = .disclosureIndicator
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool)
    {
        if highlighted {
            self.seriesNameLabel.textColor = UIColor.cellTextHighlightedColor
            self.backgroundColor = UIColor.cellBackgroundHighlightedColor
        } else {
            self.seriesNameLabel.textColor = UIColor.cellTextColor
            self.backgroundColor = UIColor.cellBackgroundColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
