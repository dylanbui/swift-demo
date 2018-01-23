//
//  DbTableViewCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

class DbTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    var dictCellData: [String: AnyObject]?
    var handleControlAction: DbHandleViewAction?
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func reloadCellData(_ cellData: [String: AnyObject]?) {
        self.dictCellData = cellData
    }
    
}

