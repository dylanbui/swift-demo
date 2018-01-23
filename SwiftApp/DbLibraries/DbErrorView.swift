//
//  DbErrorView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/19/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class DbErrorView: UIView {
    
    var imgError = UIImageView()
    var lblTitle = UILabel()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: DbMacro.screenWidth(), height: DbMacro.screenHeight()))
        createLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createLayout()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }

    
    private func createLayout() {
        imgError = UIImageView.init(image: UIImage(named: "db_ic_empty_data.png"))
        self.addSubview(imgError)
        // -- Make constraints after addSubview --
//        [self.imgError mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@0);
//            make.centerX.equalTo(self.mas_centerX);
//            //        make.width.equalTo(@48);
//            //        make.height.equalTo(@48);
//            }];
        imgError.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        lblTitle = UILabel()
        lblTitle.font = UIFont.systemFont(ofSize: 17.0)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.gray.withAlphaComponent(0.6)
        lblTitle.numberOfLines = 0
        self.addSubview(lblTitle)
        // -- Make constraints after addSubview --
//        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.imgError.mas_bottom).with.offset(12.0);
//            //        make.leading.equalTo(@15);
//            //        make.trailing.equalTo(@-15);
//            make.left.equalTo(self).offset(15);
//            make.right.equalTo(self).offset(-15);
//            make.height.greaterThanOrEqualTo(@21);
//            }];
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgError.snp.bottom).offset(12.0)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.height.greaterThanOrEqualTo(21)
        }
        
        
    }

    override func updateConstraints() {
        super.updateConstraints()
    }

    func errorEmptyData() {
        self.imgError.image = UIImage(named: "db_ic_empty_data.png")
        self.lblTitle.text = "Chưa có dữ liệu"
        //[self needsUpdateConstraints];
    }
    
    func errorNetworkConnection() {
        self.imgError.image = UIImage(named: "db_ic_error_wifi.png")
        self.lblTitle.text = "Kiểm tra lại kết nối mạng của thiết bị";
        //[self needsUpdateConstraints];
    }

}
