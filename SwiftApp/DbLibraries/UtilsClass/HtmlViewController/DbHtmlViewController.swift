//
//  DbHtmlViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/22/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

class DbHtmlViewController: UIViewController
{
    var url: URL!
    var navTitle: String?
    var delegate: DbHtmlViewDelegate?
    
    private var webView: DbHtmlView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = navTitle
        
        // -- Create webview --
        webView = DbHtmlView()
        view = webView
        webView.delegate = self
        if delegate != nil {
            webView.delegate = delegate
        }
        webView.progressBarColor = UIColor.blue
        webView.loadUrl = url // Load url
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
}

extension DbHtmlViewController: DbHtmlViewDelegate
{
    func loadingProgress(progress: Float)
    {
        // print("loadingProgress \(progress)")
    }
    
    func didFinishLoad()
    {
        // print("didFinishLoad")
    }
    
}
