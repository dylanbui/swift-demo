//
//  SeparatorStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit
import StackScrollView


final class SeparatorStackCell: StackCellBase {
  
  private let borderView = UIView()
  
  public override var intrinsicContentSize: CGSize {
    return CGSize(width: UIViewNoIntrinsicMetric, height: 1 / UIScreen.main.scale)
  }
  
  public init(
    leftMargin: CGFloat = 0,
    rightMargin: CGFloat = 0,
    backgroundColor: UIColor = UIColor.white,
    separatorColor: UIColor = UIColor(white: 0, alpha: 0.2)) {
    
    super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 1 / UIScreen.main.scale))
    
    self.backgroundColor = backgroundColor
    borderView.backgroundColor = separatorColor
    addSubview(borderView)
    
    borderView.snp.makeConstraints { (make) in
//        make.top.equalTo(0)
//        make.left.equalTo(leftMargin)
//        make.bottom.equalTo(0)
//        make.right.equalTo(-rightMargin)
        
        make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, leftMargin, 0, rightMargin))
        make.height.equalTo(1 / UIScreen.main.scale)
    }
    
//    borderView.easy.layout([
//        Top(),
//        Left(leftMargin),
//        Right(rightMargin),
//        Height(1 / UIScreen.main.scale),
//        Bottom()
//        ])
    
//    borderView <- [
//      Top(),
//      Left(leftMargin),
//      Right(rightMargin),
//      Height(1 / UIScreen.main.scale),
//      Bottom()
//    ]
  }
}
