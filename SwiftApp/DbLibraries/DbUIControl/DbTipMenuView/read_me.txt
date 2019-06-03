=> DbTipMenuView hiển thi menu bên trong tip view, su dung thu vien 

# Dung thang nay de hien thi tips cho guide user, va hien thi Tips aciton
pod 'EasyTipView', '2.0.4'


// Hien thi voi UIBarButtonItem
let menu = DbTipMenuView()

@IBAction func btnBarItem_Click(_ sender: UIBarButtonItem!)
{
if menu.isShow == true {
    return
}

menu.theme = DbTipMenuViewTheme.blueTheme()
menu.selectedIndex = 2

menu.dataSourceStrings(["UIBarButtonItem 1", "UIBarButtonItem 2", "UIBarButtonItem 3", "UIBarButtonItem 4"])
menu.didSelect { (dataSource, index) in
print("dataSource = \(dataSource)")
print("index = \(String(describing: index))")

}

menu.showMenu(forBarItem: sender, withinSuperview: self.view)
}

// Hien thi voi Button
@IBAction func btnMenu_Click(_ sender: UIButton!)
{

let menu = DbTipMenuView()
menu.dataSourceStrings(["Action 1", "Action 2", "Action 3", "Action 4"])
menu.didSelect { (dataSource, index) in
print("dataSource = \(dataSource)")
print("index = \(String(describing: index))")

}

menu.showMenu(forView: sender, withinSuperview: self.view)
}


// Co the xu ly hien thi ben trong 1 uitableviewcell
class TipMenuViewCell: UITableViewCell
{
    var vclParent: UIViewController?
    var indexPath: IndexPath?

    @IBOutlet weak var btnTip: UIButton!
    @IBOutlet weak var lblTitle: UILabel!

    @IBAction func btnTip_Click(_ sender: UIButton)
    {
        let lblH = UILabel.init(frame: CGRect(0 , 0, self.frame.size.width, 50))
        lblH.text = "Header \(indexPath?.row ?? 0)"
        lblH.backgroundColor = UIColor.blue

        let lblF = UILabel.init(frame: CGRect(0 , 0, self.frame.size.width, 50))
        lblF.text = "Footer \(indexPath?.row ?? 0)"
        lblF.backgroundColor = UIColor.red

        let menu = DbTipMenuView()
        menu.menuHeaderView = lblH
        menu.menuFooterView = lblF

        menu.dataSourceStrings(["Action 1", "Action 2", "Action 3", "Action 4"])
        menu.didSelect { (dataSource, index) in
        // print("dataSource = \(dataSource)")
        print("index = \(String(describing: index))")
        print("self.indexPath = \(String(describing: self.indexPath))")
        }

        menu.showMenu(forView: sender, withinSuperview: self.vclParent?.view)
    }


}
