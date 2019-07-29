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
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var progressBar: DbProgressBar!
    
    var indexPath: IndexPath?
    
    var deleteAction: ((_ indexPath: IndexPath?) -> Void)?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code

        // -- Limit height for DbProgressBar = 3 --
        self.progressBar.outlineColor = .black
        self.progressBar.outlineWidth = 0
        self.progressBar.spacing = 1
        self.progressBar.progressColor = .orange // .white
        self.progressBar.backgroundColor = .lightGray
        self.progressBar.value = 0.0
    }
    
    // -- Co the bo trong tuong lai --
    public func reloadUploadStatusDone(done: Bool)
    {
        if done {
            imageView.alpha = 1.0
        } else {
            imageView.alpha = 0.2
        }
    }
    
    public func reloadCellFor(asset: PhotoAsset)
    {
        asset.getThumbPhoto { (image) in
            self.imageView.image = image
        }
        
        if asset.uploadState == .Done {
            
            if self.imageView.alpha < 1.0 {
                UIView.animate(withDuration: 0.3) {
                    self.imageView.alpha = 1.0
                }
            } else {
                self.imageView.alpha = 1.0
            }
            
            self.progressBar.isHidden = true
            self.lblPercent.isHidden = true
            self.btnDelete.isHidden = false
            
        } else {
            self.imageView.alpha = 0.2
            self.progressBar.isHidden = false
            self.lblPercent.isHidden = false
            self.btnDelete.isHidden = true
            
            if let progress = asset.uploadProgress {
                // -- Update progress bar value--
                self.lblPercent.text = String(format:"%.0f", (progress.fractionCompleted*100))
                self.progressBar.updateProgress(progress)
            } else {
                self.lblPercent.text = ""
                self.progressBar.value = 0
            }
        }
    }
    
    @IBAction func btnDelete_Click(_ sender: AnyObject)
    {
        self.deleteAction?(indexPath)
    }


}
