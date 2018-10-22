//
//  ViewController.swift
//  StackScrollView
//
//  Created by muukii on 08/29/2016.
//  Copyright (c) 2016 muukii. All rights reserved.
//

import UIKit

import StackScrollView
import SnapKit


class StackScrollViewController: UIViewController {
  
  private let stackScrollView = StackScrollView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    var views: [UIView] = []
    
    let marginColor = UIColor(white: 0.98, alpha: 1)
    
    views.append(MarginStackCell(height: 96, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "LabelStackCell", backgroundColor: marginColor))

    views.append(LabelStackCell(title: "Sometimes you need modify existing constraints in order to animate or remove/replace constraints. In SnapKit there are a few different approaches to updating constraints."))
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "TextFieldStackCell", backgroundColor: marginColor))
    
    views.append(fullSeparator())
    
    views.append({
        let v = TextFieldStackCell()
        v.backgroundColor = UIColor.blue
        v.set(placeholder: "TextFieldStackCell")
        return v
        }())
    
    views.append(semiSeparator())
    
    views.append({
        let v = TextFieldStackCell()
        v.backgroundColor = UIColor.darkGray
        v.set(placeholder: "Detail")
        return v
        }())
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "DatePickerStackCell", backgroundColor: marginColor))
    
    views.append(fullSeparator())
    
    views.append({
        let v = DatePickerStackCell()
        v.set(title: "Date")
        return v
        }())
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "TextViewStackCell", backgroundColor: marginColor))




    stackScrollView.append(views: views)

  }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // stackScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackScrollView.frame = view.bounds
        view.addSubview(stackScrollView)
        
        stackScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(16)
            make.left.equalTo(self.view).offset(16)
            make.bottom.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-16)
        }


    }
  
  private func fullSeparator() -> SeparatorStackCell {
    return SeparatorStackCell(leftMargin: 0, rightMargin: 0, backgroundColor: .clear, separatorColor: UIColor(white: 0.90, alpha: 1))
  }
  
  private func semiSeparator() -> SeparatorStackCell {
    return SeparatorStackCell(leftMargin: 8, rightMargin: 8, backgroundColor: .clear, separatorColor: UIColor(white: 0.90, alpha: 1))
  }
}
