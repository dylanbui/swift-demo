//
//  LabelStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation
import StackScrollView
import SnapKit

final class LabelStackCell: StackCellBase
{
    private let label = UILabel()
  
    init(title: String)
    {
        super.init()
        
        addSubview(label)
        self.backgroundColor = UIColor.darkGray
    
        label.snp.makeConstraints { (make) in
            // -- Longer --
//            make.top.greaterThanOrEqualTo(8)
//            make.left.equalTo(8)
//            make.bottom.lessThanOrEqualTo(-8)
//            make.right.equalTo(-8)
            // -- Shorter --
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(8 ,8 ,8 ,8))
        }
    
        label.backgroundColor = UIColor.cyan
        
//    label <- [
//      Top(>=8),
//      Left(8),
//      Right(8),
//      Bottom(<=8),
//      CenterY(),
//    ]
    
        self.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(40) // .=40
        }
    
//    self <- [
//      Height(>=40),
//    ]
    
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = title
        label.numberOfLines = 0
    }

}
