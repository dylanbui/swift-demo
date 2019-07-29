//
//  ViewController.swift
//  StackScrollView
//
//  Created by muukii on 08/29/2016.
//  Copyright (c) 2016 muukii. All rights reserved.
//

import UIKit
//import StackScrollView
import SnapKit


class StackScrollViewController: UIViewController {
  
  private let stackScrollView = DbStackScrollView()

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.view.addSubview(stackScrollView)
    stackScrollView.snp.makeConstraints { (make) in
        make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    var views: [UIView] = []
    
    let marginColor = UIColor(white: 0.98, alpha: 1)
    
    views.append(MarginStackCell(height: 96, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "LabelStackCell", backgroundColor: marginColor))

    views.append(LabelStackCell(title: "Sometimes you need modify existing constraints in order to animate or remove/replace constraints. In SnapKit there are a few different approaches to updating constraints."))
    
    views.append(MarginStackCell(height: 130, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "TextFieldStackCell", backgroundColor: marginColor))
    
//    views.append(fullSeparator())
    
//    views.append(NibToggerShow())
    
//    views.append(fullSeparator())
    
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
        v.set(title: "Date: ")
        return v
        }())
    
    views.append(fullSeparator())
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    views.append(HeaderStackCell(title: "TextViewStackCell", backgroundColor: marginColor))
    
    views.append({
        let v = ShowMoreLabelStackCell()
        v.set(value: "I've been wracking my head against this for the last 3 hours.I have a custom cell with class JobDescriptionCell whose row height is set to UITableViewAutomaticDimension. This cell has a label containing the job description. By default the numberOfLines on the label is 3, but tapping on the label should change the numberOfLines to 0 so that the full text is visible. In order to implement this, I added a BOOL property in JobDescriptionCell named expanded. The setter for this property changes the numberOfLines to 0 or 3 depending on whether expanded is YES or NO respectively. I added a second boolean property jobDescriptionExpanded in the ViewController containing the UITableView. When the DescriptionCell is selected, I reverse jobDescriptionExpanded and reload the cell, passing in the updated value of expansion state. This is the only way I could get it to work and it sucks. It's convoluted and I'm sure there is an easier way. Could you guys please tell me how you managed to implement this?")
        return v
        }())

    // -- 6 dong remove --
    (0..<6).forEach { _ in
        let s = fullSeparator()
        views.append(s)
        views.append({
            let v = ButtonStackCell(buttonTitle: "Remove")
            v.tapped = { [unowned v] in
                v.remove()
                s.remove()
            }
            return v
            }()
        )
    }
    
    do {
        // Load from XIB
        let cell = NibItemStackCell()
        views.append(fullSeparator())
        views.append(cell)
        views.append(fullSeparator())
        
        let lbl = UILabel.init(frame: CGRect(0, 0 , 100, 50))
        lbl.text = "Khong"
        lbl.backgroundColor = UIColor.yellow
        cell.addSubview(lbl)        
    }
    
    views.append(MarginStackCell(height: 40, backgroundColor: marginColor))
    
    
    views.append({
        let v = TextViewStackCell()
        v.backgroundColor = UIColor.darkGray
        v.set(value: "TextViewStackCell")
        return v
        }())

    stackScrollView.append(views: views)

  }
    
    override func viewWillAppear(_ animated: Bool)
    {
        // stackScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // stackScrollView.frame = view.bounds
    }
  
  private func fullSeparator() -> SeparatorStackCell
  {
    return SeparatorStackCell(leftMargin: 0, rightMargin: 0, backgroundColor: .clear, separatorColor: UIColor(white: 0.90, alpha: 1))
  }
  
  private func semiSeparator() -> SeparatorStackCell
  {
    return SeparatorStackCell(leftMargin: 8, rightMargin: 8, backgroundColor: .clear, separatorColor: UIColor(white: 0.90, alpha: 1))
  }
    
}
