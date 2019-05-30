//
//  DemoWebViewViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit


class DemoWebViewViewController: BaseViewController
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
        // webView.loadUrl = url // Load url
        // webView.html = templateHtml
        
        // webView.webView.scrollView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        let strTienIt = self.formatDienTichDuAn(["Bãi giữ xe",
                                                 "Hồ bơi",
                                                 "BBQ",
                                                 "Năm bàn giao: 2000",
                                                 "Hệ thống điều hoà",
                                                 "Máy phát điện",
                                                 "Hệ thống an ninh",
                                                 "Sân chơi thể thao",
                                                 "Hệ thống PCCC"])
        
        let strXungQuanh_1 = self.formatDienTichXungQuanh("Gần trường học", arrItems: [
            "Đại học Y Dược TP HCM: 2000m",
            "Đại học Hồng Bàng: 1300m",
            "Đại học gì đó: 0m"])

        let strXungQuanh_2 = self.formatDienTichXungQuanh("Ngân hàng", arrItems: [
            "Ngân hàng ACB: 700m",
            "Ngân hàng Vietcombank: 1300m",
            "Đại học gì đó: 0m"])

        let strXungQuanh_3 = self.formatDienTichXungQuanh("Tòa nhà Văn phòng", arrItems: [
            "Thuận Kiều Plaza: 800m",
            "Gần Hòa Barry",
            "Trạm xăng Hồng Đức số 05: 700m"])
        
        let strXungQuanh_4 = self.formatDienTichXungQuanh("Gần bệnh viện", arrItems: [
            "Bệnh viện 175: 2500m"])
        
        var html = templateHtml.db_replace(string: "#{TIEN_IT_DU_AN}", with: strTienIt)
        html = html.db_replace(string: "#{TIEN_IT_XUNG_QUANH}", with: strXungQuanh_1 + strXungQuanh_2 + strXungQuanh_3 + strXungQuanh_4)
        
        print("-------------------------------")
        print("\(html)")
        print("-------------------------------")
        
        // webView.html = html
        
        webView.webView.scrollView.isScrollEnabled = true
        webView.webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        // webView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle().bundleURL)
    }
    
    func formatDienTichDuAn(_ arrItems: [String]? = nil) -> String
    {
        guard let arrItems = arrItems else {
            return "<p>Đang cập nhật</p>"
        }
        var str = ""
        for item in arrItems {
            str += "<li>\(item)</li>"
        }
        return str
    }
    
    func formatDienTichXungQuanh(_ title: String, arrItems: [String]? = nil) -> String
    {
        var strItem = ""
        for item in arrItems ?? [] {
            strItem += "<li>\(item)</li>"
        }
        
        let str = """
            <div class="bl-utility-around">
                <p class="p-title">\(title)</p>
                <ul>\(strItem)</ul>
            </div>
        """
        
        return str
    }
}

extension DemoWebViewViewController: DbHtmlViewDelegate
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

private let templateHtml = """

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta charset="utf-8">
<title></title>
</head>

<style type="text/css">

.bl-info-project .blocks {
padding-bottom: 30px;
}

.bl-info-project .bl-title {
font-size: 20px;
color: #363636;
margin-bottom: 15px;
margin-top: 0;
font-weight: 400;
line-height: 1.42857143;
border-bottom: 2px solid #2e79d1;
display: inline-block;
}

.bl-info-project ul {
margin: 0;
padding: 0;
}

.bl-info-project ul li {
width: 40%;
position: relative;
display: inline-block;
list-style: none;
padding: 6px 0 6px 15px;
font-size: 14px;
font-family: 'Open Sans', sans-serif;
font-weight: 400;
}

.bl-info-project ul li:before {
content: '';
display: inline-block;
position: absolute;
background: url(ic-dot-utility.png) no-repeat center;
height: 4px;
width: 4px;
left: 4px;
top: 13px;
}

.bl-table {
display: table;
width: 100%;
}

.bl-utility-around {
display: inline-block;
float: left;
width: 100%;
}

.bl-utility-around .p-title {
position: relative;
padding: 6px 0 6px 15px;
font-size: 14px;
font-family: 'Open Sans',sans-serif;
font-weight: 400;
margin-bottom: 0;
}

.bl-utility-around .p-title:before {
content: '';
display: inline-block;
position: absolute;
background: url(ic-dot-utility.png) no-repeat center;
height: 4px;
width: 4px;
left: 4px;
top: 13px;
}

.bl-utility-around ul {
padding-left: 20px;
}

.bl-utility-around ul li {
position: relative;
width: 100%;
font-family: 'Open Sans',sans-serif;
font-weight: 400;
padding: 6px 0 6px 20px;
font-size: 14px;
}

.bl-utility-around ul li:before {
display: inline-block;
position: absolute;
height: 10px;
width: 10px;
left: 4px;
top: 10px;
background: url(ic-check-utility.png) no-repeat left top;
}

</style>

<body>

<div class="bl-info-project">
<div class="blocks block-1">

<h2 class="bl-title">Tiện ích dự án:</h2>

<ul>

#{TIEN_IT_DU_AN}

</ul>
</div>


<div class="blocks block-1">
<h2 class="bl-title">Tiện ích xung quanh:</h2>
<div class="bl-table">

#{TIEN_IT_XUNG_QUANH}

</div>
</div>
</div>

</body>
</html>

"""
