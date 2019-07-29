//
//  TextViewStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

final class TextViewStackCell: StackCellBase, UITextViewDelegate {

  private let textView = UITextView()
  
  override init() {
    super.init()
    
    addSubview(textView)
//    textView <- Edges(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
//    self <- Height(>=40)
    
    textView.snp.makeConstraints { (make) in
        make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0))
        
//        make.edges.
//        make.top.greaterThanOrEqualTo(12)
//        make.bottom.lessThanOrEqualTo(12)
//        make.left.equalTo(16)
//        make.centerY.equalToSuperview()
    }
    
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.isScrollEnabled = false
    textView.delegate = self
    
    self.snp.makeConstraints { (make) in
        make.height.greaterThanOrEqualTo(80)
    }
  }
  
  func set(value: String) {
    
    textView.text = value
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updateLayout(animated: true)
  }
}
