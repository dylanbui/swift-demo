//
//  RentInfoView.swift
//  PropzySam
//
//  Created by MyVTD on 4/25/19.
//  Copyright © 2019 Dylan Bui. All rights reserved.
//

import UIKit

// bo contrain chay tot

@IBDesignable
class RentInfoView: DbLoadableView
{
    public var handleViewAction: DbHandleAction?
    
    @IBOutlet weak var txtName: DbTextField!
    @IBOutlet weak var txtPhone: DbTextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    // Default Init
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        setup()
    }
    
    // -- convenience --
    convenience init()
    {
        self.init(frame: .zero)
        setup()
    }
    
    private func setup()
    {
        // -- Pai xac dinh truoc chieu cao --
        self.height = 410
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.handleViewAction!(self, 0, nil, nil)
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
        self.handleViewAction!(self, 1, nil, nil)
    }
    
}
