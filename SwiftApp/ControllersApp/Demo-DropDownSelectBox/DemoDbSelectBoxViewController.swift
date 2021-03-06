//
//  DemoDbSelectBoxViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/1/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit


public protocol DbHelperCompatible {
    associatedtype someType
    var db: someType { get }
}

public extension DbHelperCompatible {
    var db: DbHelper<Self> {
        get { return DbHelper(self) }
    }
}

public struct DbHelper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// All conformance here
extension UIView: DbHelperCompatible {}



extension DbHelper where Base: UIView
{
    /// SwifterSwift: x origin of view.
    public var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            base.frame.origin.x = newValue
        }
    }
    
    /// SwifterSwift: y origin of view.
    public var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            base.frame.origin.y = newValue
        }
    }
    
    /// SwifterSwift: Width of view.
    public var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            base.frame.size.width = newValue
        }
    }
    
    // SwifterSwift: Height of view.
    public var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            base.frame.size.height = newValue
        }
    }
    
    
    func toHienThiTest() -> String
    {
        // some code to create an image from color
        return "MyHelper where Base: UIView"
    }
}

extension UIView
{
    func toHienThiTest() -> String
    {
        // some code to create an image from color
        return "MyHelper where Base: UIView"
    }
}

class DemoDbSelectBoxViewController: BaseViewController
{
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnHide: UIButton!
    @IBOutlet weak var anchorDbDropDownView: UIView!
    @IBOutlet weak var anchorDbDropDownPanel: UIView!
    
    @IBOutlet weak var selectBoxView: UIView!
    var selectBox: DbSelectBox!
    
    var listView: DbDropDownView!
    var listViewPanel: DbDropDownView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Demo View Controller"
        // Do any additional setup after loading the view, typically from a nib.
        
        let view = UIView()
        view.frame = .zero
        print("1 = \(view.db.toHienThiTest())")
        print("1 = \(view.toHienThiTest())")
        
        _ = view.db.x
        _ = view.x
        
        self.selectViewBottomNavigationBar()
        
        // -- selectBox 1 --
        self.selectBox = DbSelectBox(frame: CGRect(x: 20, y: 10, width: 250, height: 30))
        self.selectBox.layer.borderWidth = 1.0
        self.selectBox.layer.borderColor = UIColor.gray.cgColor
        self.selectBox.layer.masksToBounds = true
        self.selectBox.layer.cornerRadius = 3
        
        // self.selectBox.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.midY - 100)
        self.selectBox.dropDownView.dataSourceStrings(["Mexico", "USA", "England", "France", "Germany", "Spain", "Italy", "Canada"])
        self.selectBox.placeholder = "Select your country..."
        // Max results list height - Default: No limit
        self.selectBox.dropDownView.tableListHeight = 250
        
        self.selectBox.didSelect { (options, index) in
            // print("selectBox: \(options.count) at index: \(index)")
        }
        
        //self.selectBox.center = self.selectBoxView.center
        self.selectBoxView.addSubview(self.selectBox)
        
        
        // -- example 2 --
        self.listView = DbDropDownView(withAnchorView: self.anchorDbDropDownView)
        self.listView.dataSourceStrings(["Mexico", "USA", "England", "France", "Germany", "Spain", "Italy", "Canada"])
        
        var theme = DbDropDownViewTheme.testTheme()
        theme.cellHeight = 0 // use auto
        self.listView.theme = theme
        // self.listView.animationType = .Bouncing
        self.listView.animationType = .Default
        self.listView.tableListHeight = 160
        // self.listView.hideOptionsWhenTouchOut = true
        
        self.listView.registerCellNib(nib: UINib(nibName: "DropDownCell", bundle: nil),
                                      forCellReuseIdentifier: "dropDownCell")
        // listView.registerCellString(identifier: "DropDownCell")
        
        //        listView.registerCellNib(nib: UINib(nibName: "CustomDropDownCell", bundle: nil),
        //                                 forCellReuseIdentifier: "customDropDownCell")
        
        //        listView.cellConfiguration { (options, indexPath, cell) in
        //            guard let ddCell = cell as? CustomDropDownCell else {
        //                print("Khong dung kieu CustomDropDownCell")
        //                return
        //            }
        //
        //            // Setup your custom UI components
        //            // cell.logoImageView.image = UIImage(named: "logo_\(index % 10)")
        //            guard let lbltext = ddCell.subLabel else {
        //                print("Khong dung kieu ddCell.subLabel")
        //                return
        //            }
        //
        //            lbltext.text = "\(indexPath.row) - " + options[indexPath.row].title + "- CustomDropDownCell"
        //        }
        
        self.listView.cellConfiguration { (options, indexPath, cell) in
            guard let ddCell = cell as? DropDownCell else {
                print("Khong dung kieu DropDownCell")
                return
            }
            
            // Setup your custom UI components
            // cell.logoImageView.image = UIImage(named: "logo_\(index % 10)")
            guard let lbltext = ddCell.optionLabel else {
                print("Khong dung kieu ddCell.optionLabel")
                return
            }
            
            ddCell.selectedBackgroundColor = UIColor.gray
            ddCell.highlightTextColor = UIColor.red
            
            lbltext.text = "\(indexPath.row) - " + options[indexPath.row].title + "- DropDownCell"
        }
        
        self.listView.didSelect { (options, index) in
            print("You just select: \(options.count) at index: \(index)")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // self.selectViewBottomNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnShowListView_Click(_ sender: AnyObject)
    {
        //self.selectBox.showSelectBox()
        self.listView.showDropDown()
    }
    
    @IBAction func btnHideListView_Click(_ sender: AnyObject)
    {
        //self.selectBox.hideSelectBox()
        self.listView.hideDropDown()
    }
    
    @IBAction func btnShowDownPanel_Click(_ sender: AnyObject)
    {
        // listViewPanel.showDropDown()
        // Define a header - Default: nothing
        // -- Show DbDropDownView same panel style --
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.anchorDbDropDownPanel.frame.width, height: 300))
        // header.backgroundColor = UIColor.cyan //UIColor.lightGray.withAlphaComponent(0.3)
        //        header.textAlignment = .center
        //        header.font = UIFont.systemFont(ofSize: 14)
        //        header.text = "TP Hồ Chí Minh"
        //        header.textColor = UIColor.blue
        header.backgroundColor = UIColor.cyan //UIColor.green.withAlphaComponent(0.5)
        
        let btn = UIButton.init(frame: CGRect(x: 20, y: 20, width: 50, height: 30))
        btn.setTitle("OK", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        header.addSubview(btn)
        header.bringSubview(toFront: btn)
        
        self.listViewPanel = DbDropDownView(withAnchorView: self.anchorDbDropDownPanel)
        self.listViewPanel.showDropDown(WithView: header)
    }
    
    
    @objc func buttonClicked()
    {
        self.listViewPanel.hideDropDown()
    }
    
    @IBAction func btnShowUpPanel_Click(_ sender: AnyObject)
    {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.anchorDbDropDownPanel.frame.width, height: 300))
        header.backgroundColor = UIColor.cyan //UIColor.green.withAlphaComponent(0.5)
        
        let btn = UIButton.init(frame: CGRect(x: 20, y: 20, width: 50, height: 30))
        btn.setTitle("OK", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        header.addSubview(btn)
        header.bringSubview(toFront: btn)
        
        self.listViewPanel = DbDropDownView(withAnchorView: self.anchorDbDropDownPanel)
        self.listViewPanel.displayDirection = .BottomToTop
        self.listViewPanel.showDropDown(WithView: header)
    }
    
    
    @IBAction func btnUp_Click(_ sender: AnyObject)
    {
        let header_2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        header_2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header_2.textAlignment = .center
        header_2.font = UIFont.systemFont(ofSize: 14)
        header_2.text = "btnUp_Click"
        header_2.textColor = UIColor.blue
        header_2.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        
        let view = UIView(frame: header_2.frame)
        view.backgroundColor = UIColor.blue
        view.addSubview(header_2)
        
        let options: [DbSemiModalOption: Any] = [
            DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.slideUp,
            .contentYOffset : 10,
            // DbSemiModalOption.animationDuration: 0.3
        ]
        
        self.db_presentSemiView(view, options: options)
    }
    
    @IBAction func btnCenter_Click(_ sender: AnyObject)
    {
        let header_2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        header_2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header_2.textAlignment = .center
        header_2.font = UIFont.systemFont(ofSize: 14)
        header_2.text = "btnCenter_Click"
        header_2.textColor = UIColor.blue
        header_2.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        
        let view = UIView(frame: header_2.frame)
        view.backgroundColor = UIColor.blue
        
        // -- Add custom background view , Bi loi khong su dung duoc --
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = view.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
        let header_2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        header_2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        header_2.textAlignment = .center
        header_2.font = UIFont.systemFont(ofSize: 14)
        header_2.text = "btnDown_Click"
        header_2.textColor = UIColor.blue
        header_2.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        
        let view = UIView(frame: header_2.frame)
        view.backgroundColor = UIColor.blue
        view.addSubview(header_2)
        
        let options: [DbSemiModalOption: Any] = [
            DbSemiModalOption.transitionStyle: DbSemiModalTransitionStyle.slideDown,
            // .contentYOffset : 20,
            // DbSemiModalOption.animationDuration: 0.3
        ]
        
        self.db_presentSemiView(view, options: options)
    }
    
    private func selectViewBottomNavigationBar()
    {
        let viewBottomNav = DbDropDownView()
        viewBottomNav.hideOptionsWhenTouchOut = true
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: Db.screenWidth(), height: 150))
        header.backgroundColor = UIColor.cyan //UIColor.green.withAlphaComponent(0.5)
        
        let btn = UIButton.init(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        btn.setTitle("Hide", for: .normal)
        btn.backgroundColor = UIColor.red
        // btn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        btn.center = header.center
        btn.onTap { (tapGesture) in
            viewBottomNav.hideDropDown()
        }
        
        header.addSubview(btn)
        
        let rightBarButtonItem_1 = UIBarButtonItem.init(title: "DropDown", style: .plain) { (owner) in
            if viewBottomNav.isShow == false{
                viewBottomNav.showDropDown(WithView: header, BottomNavigationBarOf: self)
            } else {
                viewBottomNav.hideDropDown()
            }
        }
        self.navigationItem.rightBarButtonItems =  [rightBarButtonItem_1]
    }

}
