//
//  MarginStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit
import StackScrollView
import EasyPeasy


final class MarginStackCell: StackCellBase
{
    let heightSize: CGFloat
  
    init(height: CGFloat, backgroundColor: UIColor)
    {
        self.heightSize = height
        super.init()
        self.backgroundColor = backgroundColor
    }
  
    override var intrinsicContentSize: CGSize
    {
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }
}
