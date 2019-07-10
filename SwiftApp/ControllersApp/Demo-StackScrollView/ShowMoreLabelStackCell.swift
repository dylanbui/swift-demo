//
//  ShowMoreLabelStackCell.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/10/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

final class ShowMoreLabelStackCell: StackCellBase
{
    private let lblContent: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.yellow
        lbl.textColor = UIColor.gray
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init()
    {
        super.init()
        
        backgroundColor = UIColor.lightGray
        
        addSubview(lblContent)
        
        lblContent.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 6))
        }
        
        lblContent.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(80)
        }

//        self.snp.makeConstraints { (make) in
//            make.height.greaterThanOrEqualTo(80)
//        }
    }
    
    func set(value: String) {
        
        lblContent.text = value
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateLayout(animated: true)
    }
}
