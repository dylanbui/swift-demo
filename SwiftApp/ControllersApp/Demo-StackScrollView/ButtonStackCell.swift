//
//  ButtonStackCell.swift
//  StackScrollView
//
//  Created by muukii on 5/2/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit
//import EasyPeasy

final class ButtonStackCell: StackCellBase
{
    var tapped: () -> Void = {}
    private let button = UIButton(type: .system)
  
    init(buttonTitle: String)
    {
        super.init()
        backgroundColor = .white
    
        button.backgroundColor = UIColor.yellow
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
        }
    
//    button.easy.layout([
//        Center(),
//        Top(12),
//        Bottom(12),
//        ])
    
        button.setTitle(buttonTitle, for: .normal)
    }
  
    @objc private func buttonTapped()
    {
        tapped()
    }
}
