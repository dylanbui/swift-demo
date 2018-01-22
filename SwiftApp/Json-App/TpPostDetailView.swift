//
//  TpPostDetailView.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/22/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation

class TpPostDetailView: DbPopupView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    //var objPost: Post! = Post()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("goi cho lop cha init(frame: CGRect)")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("goi cho lop cha init?(coder aDecoder: NSCoder) ")
    }
    
    func loadData(_ post: Post!) {
        self.lblTitle.text = post.title
        self.lblBody.text = post.body
    }
    
    @IBAction func btnTest_Click(_ sender: Any) {
        self.dismissPopupWithCompletion { (finished) in
            print("dismissPopupWithCompletion: XONG")
        }
    }
}
