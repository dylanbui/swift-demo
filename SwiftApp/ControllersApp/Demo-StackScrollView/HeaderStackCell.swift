//
//  HeaderStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation
//import StackScrollView
import SnapKit

final class HeaderStackCell: DbStackCellBase
{
    let label = UILabel()
  
    init(title: String, backgroundColor: UIColor)
    {
        super.init()
    
        self.backgroundColor = backgroundColor
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        addSubview(label)
        
        label.snp.makeConstraints { (make) in
            // even longer
//            make.top.equalTo(4)
//            make.left.equalTo(8)
//            make.bottom.equalTo(-4)
//            make.right.equalTo(-16)
            // even shorter
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(4, 8, 4, 16))
        }
    
//    label <- [
//      Top(4),
//      Left(8),
//      Right(16),
//      Bottom(4),
//    ]
    
        label.text = title
    }
}
