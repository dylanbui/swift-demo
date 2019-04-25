//
//  CustomViewEmpty.swift
//  PropzySurvey
//
//  Created by MyVTD on 3/13/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import UIKit

@IBDesignable
class CustomViewEmpty: DbLoadableView, DbEmptyStatusView
{

    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!

    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
//    public var lblLoading: UILabel = {
//        $0.font = UIFont.preferredFont(forTextStyle: .caption2)
//        $0.textColor = UIColor.black
//        $0.textAlignment = .center
//        $0.numberOfLines = 0
//        
//        return $0
//    }(UILabel())
//    
//    public let activityIndicatorView: UIActivityIndicatorView = {
//        $0.isHidden = true
//        $0.hidesWhenStopped = true
//        $0.activityIndicatorViewStyle = .gray
//        $0.color = UIColor.lightGray
//        return $0
//    }(UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge))
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var btnSur: UIButton!
    
    public var view: UIView {
        return self
    }
    
    public var status: DbEmptyStatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            self.lblLoading.text = status.title
            
            self.viewActivityIndicator.color = status.spinnerColor
            if status.isLoading {
                self.viewActivityIndicator.startAnimating()
                
                self.imgEmpty.isHidden = true
                self.btnSur.isHidden = true
            } else {
                self.viewActivityIndicator.stopAnimating()
            }
            
            imageView.isHidden = imageView.image == nil
            titleLabel.isHidden = titleLabel.text == nil
            descriptionLabel.isHidden = descriptionLabel.text == nil
            let actionButtonHidden: Bool = status.actionButton == nil
            
            verticalStackView.isHidden = self.imgEmpty.isHidden && self.btnSur.isHidden && actionButtonHidden
            
        }
    }
    
    
//    override init(frame: CGRect)
//    {
//        super.init(frame: frame)
//    }
//    
//    public required init?(coder aDecoder: NSCoder)
//    {
//        //fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
//    }
}
