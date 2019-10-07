//
//  MvpSeriesDetailCollectionHeaderView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class MvpSeriesDetailCollectionHeaderView: UICollectionReusableView, DbMvpViewCell
{
    @IBOutlet weak var seriesCoverImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!


    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(forItem series: MvpSeries)
    {
        self.seriesCoverImageView.db_download(from: series.coverURL!)
        self.ratingLabel.text = series.rating
        self.descriptionLabel.text = series.description
    }
    
}
