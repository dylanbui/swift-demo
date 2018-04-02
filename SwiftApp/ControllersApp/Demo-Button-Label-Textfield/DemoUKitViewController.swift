//
//  NetworkViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 2/22/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoUKitViewController: BaseViewController {
    
    @IBOutlet weak var btnUploadFiles: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Demo UKit"

        // Do any additional setup after loading the view.
        
        let img_0 = self.view.viewWithTag(5555) as! UIImageView
        img_0.imageFontAwesomeIcon("calendar-alt")
        
        let img_1 = self.view.viewWithTag(1111) as! UIImageView
        img_1.imageFontAwesomeIcon("smile-o")
        
        let img_2 = self.view.viewWithTag(2222) as! UIImageView
        img_2.image = UIImage.fontAwesomeIcon("trash", iconColor: UIColor.blue)
        print("\(String(describing: img_2.image?.size))")
        //img_2.imageFontAwesomeIcon("trash", iconColor: UIColor.yellow)
        
        let img_3 = self.view.viewWithTag(3333) as! UIImageView
        img_3.imageFontAwesomeIcon("tree", iconColor: UIColor.blue)
        
        let img_4 = self.view.viewWithTag(4444) as! UIImageView
        img_4.imageFontAwesomeIcon("suitcase", iconColor: UIColor.green)
        
        let button_1 = self.view.viewWithTag(6666) as! UIButton
        button_1.set(image: UIImage.fontAwesomeIcon("eject"), title: "Shout", titlePosition: .left, additionalSpacing: 40.0, state: .normal)

        let button_2 = self.view.viewWithTag(9999) as! UIButton
        button_2.set(image: UIImage.fontAwesomeIcon("eject"), title: "Bấm nút tại đây", titlePosition: .right, additionalSpacing: 10.0, state: .normal)
        
        let txt_1 = self.view.viewWithTag(123456) as! DbTextField
        txt_1.leftImage = UIImage.fontAwesomeIcon("trash", iconColor: UIColor.blue)
        txt_1.rightImage = UIImage.fontAwesomeIcon("calendar-alt", iconColor: UIColor.brown)

        let txt_2 = self.view.viewWithTag(8888) as! DbTextField
        txt_2.leftImage = UIImage.fontAwesomeIcon("user-circle", iconColor: UIColor.blue, ofSize: 30.0)
        txt_2.leftImagePadding = 10.0
        
        let lbl_1 = self.view.viewWithTag(7777) as! DbLabel
        lbl_1.leftImage = UIImage.fontAwesomeIcon("trash", iconColor: UIColor.blue)
        lbl_1.rightImage = UIImage.fontAwesomeIcon("calendar-alt", iconColor: UIColor.darkGray)
        let tap_1 = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction_1))
        lbl_1.isUserInteractionEnabled = true
        lbl_1.addGestureRecognizer(tap_1)

        
        let lbl_2 = self.view.viewWithTag(1) as! DbLabel
        lbl_2.leftImage = UIImage.fontAwesomeIcon("trash", iconColor: UIColor.blue)
        lbl_2.rightImage = UIImage.fontAwesomeIcon("calendar-alt", iconColor: UIColor.darkGray)
        lbl_2.setTouchesAction {
            // With individual UIAlertAction objects
            let firstButtonAction = UIAlertAction(title: "First Button", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                print("First Button pressed")
            })
            let secondButtonAction = UIAlertAction(title: "Second Button", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                print("Second Button pressed")
            })

            DbAlertController.actionSheet("Title", message: "message", sourceView: self.view, actions: [firstButtonAction, secondButtonAction])
        }
    }

    @objc func tapFunction_1(sender:UITapGestureRecognizer) {
        print("tap working")
        DbAlertController.alert("Title", message: "Message", acceptMessage: "OK") { () -> () in
            print("cliked OK")
        }
        
    }

    
    
   
}
