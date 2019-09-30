//
//  MvpCharacterTableViewCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/30/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class MvpCharacterTableViewCell: UITableViewCell, DbMvpViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    // Ngam dinh la kieu "associatedtype ItemType" cua protocol DbMvpViewCell
    func configure(forItem item: MvpCharacter)
    {
        nameLabel.text = item.name
        nameLabel.accessibilityLabel = item.name
        thumbnailImage.db_download(from: item.thumbnail)
        applyImageGradient(thumbnailImage)
    }
    
    private func applyImageGradient(_ thumbnailImage: UIImageView)
    {
        guard thumbnailImage.layer.sublayers == nil else {
            return
        }
        let gradient: CAGradientLayer = CAGradientLayer(layer: thumbnailImage.layer)
        gradient.frame = thumbnailImage.bounds
        gradient.colors = [UIColor.gradientStartColor.cgColor, UIColor.gradientEndColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.6)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        thumbnailImage.layer.insertSublayer(gradient, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
