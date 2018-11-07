//
//  DbCornerButton.swift
//  PropzySam
//
//  Created by MyVTD on 9/11/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//

import UIKit

class DbCornerButton: UIButton {
    
    private func commonInit() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commonInit()
    }
}
