//
//  DemoSurveyViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/6/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoSurveyViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let survey = SurveyView()
        self.view.addSubview(survey)
        
        survey.db_anchor(top: self.view.topAnchor, left: self.view.leftAnchor,
                         bottom: nil, right: self.view.rightAnchor,
                         topConstant: 125, leftConstant: 0, bottomConstant: 0, rightConstant: 0,
                         widthConstant: 0, heightConstant: 50)
        
        //survey.db_anchorCenterXToSuperview()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
