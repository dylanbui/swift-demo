//
//  CustomViewEmpty.swift
//  PropzySurvey
//
//  Created by MyVTD on 3/13/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import UIKit

/*
 Khi custom empty view thi phai su dung UIStackView de lam layout
 */

@IBDesignable
class CustomViewEmpty: DbLoadableView, DbEmptyStatusView
{
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var btnSur: UIButton!
    
    public var view: UIView {
        return self
    }
    
    public var status: DbEmptyStatusModel? {
        didSet {
            
            guard let status = status else { return }
            
            self.lblTitle.text = status.title
            self.imgEmpty.image = status.image
            self.btnSur.setTitle(status.actionTitle, for: UIControlState())
            
            self.viewActivityIndicator.color = status.spinnerColor
            if status.isLoading {
                self.viewActivityIndicator.startAnimating()
            } else {
                self.viewActivityIndicator.stopAnimating()
            }
            
            self.imgEmpty.isHidden = self.imgEmpty.image == nil
            self.lblTitle.isHidden = self.lblTitle.text == nil
            self.btnSur.isHidden = status.action == nil
            
            self.verticalStackView.isHidden = self.imgEmpty.isHidden && self.lblTitle.isHidden && self.btnSur.isHidden
            
            // -- Update layout when update StackView Constraint --
            // -- Add Constraint chieu cao cua tung view --
            // Phai co 1 view cho priority thap, de no se chiem chieu cao cua view nay
        }
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup()
    {
        self.viewActivityIndicator.isHidden = true
        self.viewActivityIndicator.hidesWhenStopped = true
        self.viewActivityIndicator.activityIndicatorViewStyle = .gray
        self.viewActivityIndicator.color = UIColor.lightGray
        
        // -- Su dung cach nay hay set trong file xib deu duoc --
        self.btnSur.db_anchor(widthConstant: 170, heightConstant: 40)
    }
    
    @IBAction func btn_Click(_ sender: AnyObject)
    {
        self.status?.action?()
    }
}
