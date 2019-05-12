//
//  DemoNavBarViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

// -- Cach nay dung, chi dung duoc cho duoi 11 --
//extension UINavigationBar {
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width, height: 70)
//    }
//}

// -- Duoi thang ios 11 thi dung cai nay --
//private var AssociatedObjectHandle: UInt8 = 0
//extension UINavigationBar {
//
//    var height: CGFloat {
//        get {
//            if let h = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? CGFloat {
//                return h
//            }
//            return 0
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        if self.height > 0 {
//            return CGSize(width: UIScreen.main.bounds.width, height: self.height)
//        }
//        return super.sizeThatFits(size)
//    }
//}

// -- tren ios 11 thi phai dung --
// https://stackoverflow.com/questions/44387285/ios-11-navigation-bar-height-customizing
// https://forums.developer.apple.com/thread/88202

/* De chinh content hien thi duoi UINavigationBar cao hon
 //Important!
 if #available(iOS 11.0, *) {
 //Default NavigationBar Height is 44. Custom NavigationBar Height is 66. So We should set additionalSafeAreaInsets to 66-44 = 22
 self.additionalSafeAreaInsets.top = 26
 }
 */


class DemoNavBarViewController: DbViewController
{
    var nav: MyCustomNavigationBarView?
    
    override init()
    {
        super.init()
        self.nav = MyCustomNavigationBarView(WithViewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        //self.navigationController?.navigationBar.navHeight = 70

        //Important!
//        if #available(iOS 11.0, *) {
//            //Default NavigationBar Height is 44. Custom NavigationBar Height is 66. So We should set additionalSafeAreaInsets to 66-44 = 22
//            self.additionalSafeAreaInsets.top = 26
//        }
        
        // self.nav?.updateNav_ShowAll("Day la top", bottom: "Dat la bottom")
//        self.nav?.updateNav_NoBackAndTop("Trang chu")
//        self.nav?.updateNav_NoTop("Khong co top, chi co back")
        // self.nav?.updateNav_NoBack("Day la top", bottom: "Dat la bottom")
        
        let statusModel = NavBarViewModel(isHiddenBackButton: true, topTitle: "Day la TOP title",
                                     bottomTitle: "Day la BOTTOM title")
        self.nav?.navBarModel = statusModel

        // Do any additional setup after loading the view.
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let height = CGFloat(70)
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
//    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.nav?.lblTop.text = "Thay doi tai viewWillAppear"
    }

}

extension DemoNavBarViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        // (cell is non-optional; no need to use ?. or !)
        // Configure your cell:
        cell!.textLabel?.text       = "Key   :----- \(indexPath.row)"
        cell!.detailTextLabel?.text = "Value :----- \(indexPath.row)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.pushViewController(NavBarPushOneViewController(), animated: true)
        
//        if indexPath.row == 0 {
//            self.nav?.updateNav_NoBack("Day la top", bottom: "Dat la bottom")
//        } else if indexPath.row == 1 {
//            self.nav?.updateNav_NoTop("Dat la bottom")
//        } else if indexPath.row == 2 {
//            self.nav?.updateNav_NoBackAndTop("Dat la bottom")
//        }
    }
}

