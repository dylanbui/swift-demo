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
    
    var indexPath: IndexPath?
    
    var deleteAction: ((_ indexPath: IndexPath?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func reloadUploadStatusDone(done: Bool)
    {
        if done {
            imageView.alpha = 1.0
        } else {
            imageView.alpha = 0.2
        }
    }
    
    @IBAction func btnDelete_Click(_ sender: AnyObject)
    {
        self.deleteAction?(indexPath)
    }


}
