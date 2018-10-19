//
//  SwitchStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import EasyPeasy

final class SwitchStackCell: StackCellBase {
  
  var valueChanged: (Bool) -> Void = { _ in }
  
  let titleLabel = UILabel()
  private let switchView = UISwitch()
  
  init(title: String) {
    super.init()
    
    backgroundColor = .white
    
    addSubview(titleLabel)
    addSubview(switchView)
    
    titleLabel.snp.makeConstraints { (make) in
        make.top.greaterThanOrEqualTo(12)
        make.bottom.lessThanOrEqualTo(12)
        make.left.equalTo(16)
        make.centerY.equalTo(self)
    }
    
//    titleLabel <- [
//      Top(>=12),
//      Bottom(<=12),
//      Left(16),
//      CenterY(),
//    ]
    
    switchView.snp.makeConstraints { (make) in
//        make.left.equalTo(titleLabel.right).offset(12)
        
//        make.trailing.equalTo(titleLabel).offset(12)
//        make.left.equalTo(titleLabel.snp.right).inset(12)
        make.leading.equalTo(titleLabel.snp.right).inset(12)
        
        
        make.top.greaterThanOrEqualTo(0)
        make.right.equalTo(16)
        make.centerY.equalTo(self)
        make.bottom.lessThanOrEqualTo(0)
    }
    
//    switchView <- [
//      Left(12).to(titleLabel, .right),
//      Top(>=0),
//      Right(16),
//      CenterY(),
//      Bottom(<=0),
//    ]
    
    switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    
    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    
    titleLabel.text = title
  }
  
  @objc private func switchValueChanged() {
    
    valueChanged(switchView.isOn)
  }
}
