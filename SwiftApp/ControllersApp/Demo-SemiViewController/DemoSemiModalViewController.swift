//
//  DemoSemiModalViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/25/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoSemiModalViewController: BaseViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func btnUp_Click(_ sender: AnyObject)
    {
        let view = RentInfoView()
        view.handleViewAction = { (owner, sid, params, error) in
            self.vclParent?.db_dismissSemiModalView()
        }

        let options: [DbSemiModalOption: Any] = [
            DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.slideUp,
            .contentYOffset : 10,
            // DbSemiModalOption.animationDuration: 0.3
        ]
        
        self.db_presentSemiView(view, options: options)
    }
    
    @IBAction func btnCenter_Click(_ sender: AnyObject)
    {
        let view = RentInfoView()
        view.handleViewAction = { (owner, sid, params, error) in
            self.vclParent?.db_dismissSemiModalView()
        }
        
        let options: [DbSemiModalOption: Any] = [
            DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.slideCenter,
            // DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.fadeInOutCenter,
            DbSemiModalOption.animationDurationIn: 0.4,
            DbSemiModalOption.animationDurationOut: 0.2,
            .contentYOffset : -50,
            // .backgroundView : blurEffectView
        ]
        
        self.db_presentSemiView(view, options: options)
    }
    
    @IBAction func btnDown_Click(_ sender: AnyObject)
    {
        let view = RentInfoView()
        view.handleViewAction = { (owner, sid, params, error) in
            self.vclParent?.db_dismissSemiModalView()
        }
        
        let options: [DbSemiModalOption: Any] = [
            DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.slideDown,
            // .contentYOffset : 20,
            // DbSemiModalOption.animationDuration: 0.3
        ]
        
        self.db_presentSemiView(view, options: options)
    }
}
