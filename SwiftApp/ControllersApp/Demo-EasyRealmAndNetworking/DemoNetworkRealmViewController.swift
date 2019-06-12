//
//  DemoNetworkRealmViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoNetworkRealmViewController: BaseViewController
{
    var arrContent: [Int] = []
    var arrDictrict: [DistrictRmUnit] = []
    var arrWard: [WardRmUnit] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblContent.separatorStyle = .none
        
        let loadData = {
            PzAdminApi.getDistrictList { (arrDistrict, response) in
                if let arr = arrDistrict {
                    print("Da load = \(arr.count) - District")
                    self.arrDictrict = arr
                }
            }
        }
        
        // -- Right --
        let btnAdd = UIBarButtonItem(
            title: "Phường",
            style: .plain,
            target: self,
            action: #selector(loadWardByDistrict(sender:))
        )
        self.navigationItem.rightBarButtonItem = btnAdd
        // -- Left --
        let btnReload = UIBarButtonItem.init(title: "Reload", style: .plain) { (button) in
            loadData()
        }
        self.navigationItem.leftBarButtonItem = btnReload
        
        loadData()
        
//        PzAdminApi.getDistrictList { (arrDistrict, response) in
//            if let arr = arrDistrict {
//                print("Da load = \(arr.count) - District")
//                self.arrDictrict = arr
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    @objc func loadWardByDistrict(sender: UIBarButtonItem)
    {
        let picker = DbSheetPicker.initWithTitle(title: "Load dữ liệu phường",
                                                 rows: self.arrDictrict,
                                                 initialSelections: nil,
                                                 okTitle: "Đồng ý",
                                                 cancelTitle: "Bỏ qua")
        // picker.anchorControl = sender // Lay topviewcontroller
        picker.customButtonsAxis = .horizontal
        picker.doneBlock = { (_ picker: DbSheetPicker, _ selectedIndex: Int, _ selectedValue: DbItemProtocol) in
            print("Gia tri vua chon : \(selectedValue.dbItemTitle)")
            PzAdminApi.getWardBy(District: selectedValue.dbItemId, completionHandler: { (arrWard, response) in
                if let arr = arrWard {
                    print("Da load = \(arr.count) - Ward")
                    self.arrWard = arr
                    if arr.count > 0 {
                        self.tblContent.separatorStyle = .singleLineEtched
                        self.tblContent.reloadData()
                    }
                }
            })
        }

        picker.cancelBlock = { (_ picker: DbSheetPicker) in
            print("Bo qua chon")
        }

        picker.didSelectRowBlock = { (_ picker: DbSheetPicker, _ didSelectRow: Int) in
            print("VUA MOI CHON DONG : \(didSelectRow)")
        }
        picker.show()
    }



}

extension DemoNetworkRealmViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrWard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        let item = self.arrWard[indexPath.row]
        
        cell!.textLabel?.text = item.wardName
        cell!.detailTextLabel?.text = "Id - \(item.wardId) - Name - \(item.wardName) "
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        // let item = self.arr[indexPath.row] as? [String:AnyObject]
    }
}
