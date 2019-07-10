//
//  DatePickerStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

//import EasyPeasy
//import StackScrollView

final class DatePickerStackCell: TapStackCell {
  
  let pickerView = UIDatePicker()
  let titleLabel = UILabel()
  let valueLabel = UILabel()
  var editing: Bool = false
  
  private let borderView = UIView()
  private let pickerContainerView = UIView()
  private let bodyContainerView = UIView()
  
  override init() {
    
    super.init()
    
    backgroundColor = UIColor.white
    
    pickerView.setContentHuggingPriority(.init(100), for: .horizontal)

    pickerContainerView.clipsToBounds = true
    pickerContainerView.addSubview(pickerView)
    
    addSubview(bodyContainerView)
    addSubview(borderView)
    addSubview(pickerContainerView)
    
    pickerView.snp.makeConstraints { (make) in
        make.top.equalToSuperview().priority(.medium)
        make.right.equalToSuperview()
        make.left.equalToSuperview()
        make.bottom.equalToSuperview().priority(.medium)
        make.centerY.equalToSuperview()
    }
    
//    pickerView.easy.layout([
//      Top().with(.medium),
//      Right(),
//      Left(),
//      Bottom().with(.medium),
//      CenterY(),
//    ])
    
    bodyContainerView.addSubview(titleLabel)
    bodyContainerView.addSubview(valueLabel)
    
    titleLabel.backgroundColor = UIColor.lightGray
    titleLabel.snp.makeConstraints { (make) in
        make.top.greaterThanOrEqualTo(12)
        make.bottom.lessThanOrEqualTo(12)
        make.left.equalTo(16)
//        make.right.equalTo(valueLabel.snp.left)
        make.width.equalTo(50)
        make.centerY.equalToSuperview()
    }
    
//    titleLabel.easy.layout([
//      Top(>=12),
//      Bottom(<=12),
//      Left(16),
//      CenterY(),
//    ])
    
    valueLabel.textAlignment = .right
    valueLabel.numberOfLines = 0
    valueLabel.backgroundColor = UIColor.red
    valueLabel.text = "noi dung" // Phai co du lieu , Label nay moi hien thi
    valueLabel.snp.makeConstraints { (make) in
        make.top.greaterThanOrEqualTo(12)
        make.bottom.lessThanOrEqualTo(12)
        make.left.equalTo(titleLabel.snp.right).offset(5)
        make.centerY.equalToSuperview()
        make.right.equalTo(-16)
    }
    
//    valueLabel.easy.layout([
//      Top(>=12),
//      Bottom(<=12),
//      Left(>=24).to(titleLabel, .right),
//      CenterY(),
//      Right(16),
//    ])
    
    bodyContainerView.snp.makeConstraints { (make) in
        make.top.equalToSuperview()
        make.right.equalToSuperview()
        make.left.equalToSuperview()
        //make.bottom.equalToSuperview()
        make.bottom.equalTo(borderView.snp.top)
    }
    
//    bodyContainerView.easy.layout([
//      Top(),
//      Right(),
//      Left(),
//      Bottom().to(borderView, .top),
//    ])
    
    borderView.backgroundColor = UIColor.red
    borderView.alpha = 0
    borderView.snp.makeConstraints { (make) in
        make.right.equalTo(16)
        make.left.equalTo(16)
        //make.height.equalTo(1 / UIScreen.main.scale)
        make.height.equalTo(1)
        make.bottom.equalTo(pickerContainerView.snp.top)
    }
    
//    borderView.easy.layout([
//      Left(16),
//      Right(16),
//      Height(1 / UIScreen.main.scale),
//      Bottom().to(pickerContainerView, .top),
//    ])
    
    pickerContainerView.snp.makeConstraints { (make) in
        make.right.equalToSuperview()
        make.left.equalToSuperview()
        make.bottom.equalToSuperview()
        make.height.equalTo(0)
    }
    
//    pickerContainerView.easy.layout([
//      Right(),
//      Left(),
//      Bottom(),
//      Height(0),
//    ])
    
    bodyContainerView.isUserInteractionEnabled = false
  }

  override func tap() {
    
    if editing {
      _close()
    } else {
      _open()
    }
    
  }
  
  func _close() {
    
    guard editing == true else { return }
    
    editing = false
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 0,
      options: [
        .beginFromCurrentState,
        .allowUserInteraction
      ],
      animations: {
        
        self.pickerContainerView.snp.updateConstraints({ (update) in
            update.height.equalTo(0)
        })
        
//        self.pickerContainerView.easy.layout([
//          Height(0),
//        ])
        
        self.borderView.alpha = 0
        self.pickerView.alpha = 0
        
        self.pickerContainerView.invalidateIntrinsicContentSize()
        self.pickerContainerView.layoutIfNeeded()
        self.updateLayout(animated: true)
        self.scrollToSelf(animated: true)
        
    }) { (finish) in
      
    }
    
  }
  
  func _open() {
    
    guard editing == false else { return }
    
    editing = true
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 0,
      options: [
        .beginFromCurrentState,
        .allowUserInteraction
      ],
      animations: {
        
        self.pickerContainerView.snp.updateConstraints({ (update) in
            //update.height.equalToSuperview()
            update.height.equalTo(200)
        })

//        NSLayoutConstraint.deactivate(
//          self.pickerContainerView.easy.layout([
//            Height(),
//          ])
//        )
        
        self.borderView.alpha = 1
        self.pickerView.alpha = 1
        
        self.pickerContainerView.invalidateIntrinsicContentSize()
        self.pickerContainerView.layoutIfNeeded()
        self.updateLayout(animated: true)
        self.scrollToSelf(animated: true)
        
    }) { (finish) in
      
    }
    
  }
  
  
    func set(title: String)
    {
        titleLabel.text = title
    }
} 
