//
//  DemoHtmlWithAdvButtonViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 6/6/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

private let kPadding: CGFloat = 10.0

private let kDemoText: String = "<a href='http://github.com/mattdonnelly/MDHTMLLabel'>MDHTMLLabel</a> is a lightweight, easy to use replacement for <b>UILabel</b> which allows you to fully <font face='Didot-Italic' size='19'>customize</font> the appearence of the text using HTML (with a few added features thanks to <b>CoreText</b>), as well letting you handle whenever a user taps or holds down on link and automatically detects ones not wrapped in anchor tags"


class DemoHtmlWithAdvButtonViewController: UIViewController
{
    @IBOutlet weak var lblHtml: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Khong su dung duoc voi mau Alpha
        self.lblHtml.font = UIFont.systemFont(ofSize: 13.0)
        //self.lblHtml.textColor = UIColor.init(hexString: "#A3FF00")
        //self.lblHtml.textColor = UIColor.red
        //self.lblHtml.textColor = UIColor.gray
        self.lblHtml.htmlText = kDemoText

        
    }

}

