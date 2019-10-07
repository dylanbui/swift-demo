//
//  MvpComicCollectionViewCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/7/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class MvpComicCollectionViewCell: UICollectionViewCell, DbMvpViewCell
{
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var comicNameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(forItem item: MvpComic)
    {
        coverImageView.db_download(from: item.coverURL!)
        comicNameLabel.text = item.name
        comicNameLabel.accessibilityLabel = item.name
    }

}
