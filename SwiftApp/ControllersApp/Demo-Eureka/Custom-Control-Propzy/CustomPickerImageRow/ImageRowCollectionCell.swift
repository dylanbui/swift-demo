//
//  ImageRowCollectionCell.swift
//  PropzySurvey
//
//  Created by Dylan Bui on 2/22/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import UIKit

class ImageRowCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var indexImage: Int?
    
    var deleteAction: ((_ index: Int?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnDelete_Click(_ sender: AnyObject)
    {
        self.deleteAction?(indexImage)
    }


}
