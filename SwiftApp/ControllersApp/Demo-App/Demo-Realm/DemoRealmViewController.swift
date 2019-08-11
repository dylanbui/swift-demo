//
//  DemoRealmViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/8/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import EasyRealm

class DemoRealmViewController: BaseViewController
{
    var arrTask: [TaskItem] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Demo Realm"
        
        let rightBarButtonItem_1 = UIBarButtonItem.init(title: "Add", style: .plain) { (owner) in
            let number = Int.random(in: 0 ... 100)
            let task = TaskItem.initAutoId(forTitle: "Task thu \(number) for Duc")
            task.detail = "Mo ta chi tiet - add ramdom \(number)"
            // try! task.er.save() // Cach 1
            task.er.db_saveOrUpdate()
            self.arrTask.append(task)
            
            // -- Do da add vao array truoc --
            let indexPath = IndexPath.init(row: self.arrTask.count - 1, section: 0)
            
            // finally update the tableview
            self.tblContent.beginUpdates()
            self.tblContent.insertRows(at: [indexPath], with: .automatic)
            self.tblContent.endUpdates()
            // -- Scroll to end --
            self.tblContent.scrollToRow(at: indexPath, at: .bottom, animated: true)

            owner.title = "Add \(self.arrTask.count)"
            
        }
        self.navigationItem.rightBarButtonItems =  [rightBarButtonItem_1]

        // Do any additional setup after loading the view.
        // -- Tao record --
//        for i in 1..<10 {
//            let task = TaskItem.initAutoId(forTitle: "Task thu \(i) for Duc")
//            task.detail = "Mo ta chi tiet cv cho Duc"
//            try! task.er.save() // Cach 1
//
//            // -- Cach 2 --
////            do {
////                try task.er.save()
////            } catch let error as EasyRealmError {
////                if error == .ObjectCantBeResolved {
////                    print("Loi tao")
////                }
////            }
////            catch let unKnownError {
////                print("Khong biet loi gi - \(String(describing: unKnownError))")
////            }
//
//            self.arrTask.append(TaskItem.initAutoId(forTitle: "Task thu \(i) for Duc"))
//        }
        
        // -- Tra ve tat ca --
        // self.arrTask = try! Array(TaskItem.er.all().filter("title LIKE 'Task thu 9*'"))
        // self.arrTask = try! Array(TaskItem.er.all().sorted(byKeyPath: "title"))
        // self.arrTask = TaskItem.er.db_all(WithCondition: nil, sortedByKeyPath: "title")
        // -- Tra ve 1 doi tuong --
//        self.arrTask = try! [TaskItem.er.fromRealm(with: "31395DCE-318E-434F-9F41-AA0C052847F5")]
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // -- Tra ve tat ca --
        self.arrTask = TaskItem.er.db_all(WithCondition: nil, SortedByKeyPath: "title")
        self.tblContent.reloadData()
    }

}


extension DemoRealmViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let task = self.arrTask[indexPath.row]
        
        // Configure your cell:
        cell!.textLabel?.text       = task.title
        cell!.detailTextLabel?.text = task.detail
        
        // let btn = UIButton(type: .roundedRect)
        let btn = UIButton(type: .system)
        btn.frame = CGRect(0, 0, 44, 44)
        btn.setTitle("D", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        // btn.sizeToFit()
        btn.onTap { (tap) in
            print("delete indexPath = \(String(describing: indexPath))")
            
            let task = self.arrTask[indexPath.row]
            task.er.db_delete()
//            do {
//                try task.er.delete()
//            } catch let error {
//                print("\(String(describing: error))")
//            }
            
            self.arrTask.remove(at: indexPath.row)

            // -- Upload uitableview delete row --
            self.tblContent.beginUpdates()
            self.tblContent.deleteRows(at: [indexPath], with: .left)
            self.tblContent.endUpdates()
            // Reload uitableview update IndexPath
            self.tblContent.reloadData()
        }
        
        cell!.accessoryView = btn
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arrTask[indexPath.row]
        print("\(String(describing: item))")
        
        let vcl = EditRealmViewController()
        vcl.autoId = item.autoId
        self.navigationController?.pushViewController(vcl, animated: true)
    }
}


class DemoRealmViewController_BAK: BaseViewController
{
    var arrTask: [TaskItem] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Demo Realm"
        
        let rightBarButtonItem_1 = UIBarButtonItem.init(title: "Add", style: .plain) { (owner) in
            let number = Int.random(in: 0 ... 100)
            let task = TaskItem.initAutoId(forTitle: "Task thu \(number) for Duc")
            task.detail = "Mo ta chi tiet - add ramdom \(number)"
            try! task.er.save() // Cach 1
            self.arrTask.append(task)
            
            // -- Do da add vao array truoc --
            let indexPath = IndexPath.init(row: self.arrTask.count - 1, section: 0)
            
            // finally update the tableview
            self.tblContent.beginUpdates()
            self.tblContent.insertRows(at: [indexPath], with: .automatic)
            self.tblContent.endUpdates()
            // -- Scroll to end --
            self.tblContent.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            owner.title = "Add \(self.arrTask.count)"
            
        }
        self.navigationItem.rightBarButtonItems =  [rightBarButtonItem_1]
        
        // Do any additional setup after loading the view.
        // -- Tao record --
        //        for i in 1..<10 {
        //            let task = TaskItem.initAutoId(forTitle: "Task thu \(i) for Duc")
        //            task.detail = "Mo ta chi tiet cv cho Duc"
        //            try! task.er.save() // Cach 1
        //
        //            // -- Cach 2 --
        ////            do {
        ////                try task.er.save()
        ////            } catch let error as EasyRealmError {
        ////                if error == .ObjectCantBeResolved {
        ////                    print("Loi tao")
        ////                }
        ////            }
        ////            catch let unKnownError {
        ////                print("Khong biet loi gi - \(String(describing: unKnownError))")
        ////            }
        //
        //            self.arrTask.append(TaskItem.initAutoId(forTitle: "Task thu \(i) for Duc"))
        //        }
        
        // -- Tra ve tat ca --
        // self.arrTask = try! Array(TaskItem.er.all().filter("title LIKE 'Task thu 9*'"))
        self.arrTask = try! Array(TaskItem.er.all().sorted(byKeyPath: "title"))
        
        // -- Tra ve 1 doi tuong --
        //        self.arrTask = try! [TaskItem.er.fromRealm(with: "31395DCE-318E-434F-9F41-AA0C052847F5")]
        
    }
    
}


extension DemoRealmViewController_BAK: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let task = self.arrTask[indexPath.row]
        
        // Configure your cell:
        cell!.textLabel?.text       = task.title
        cell!.detailTextLabel?.text = task.detail
        
        // let btn = UIButton(type: .roundedRect)
        let btn = UIButton(type: .system)
        btn.frame = CGRect(0, 0, 44, 44)
        btn.setTitle("D", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        // btn.sizeToFit()
        btn.onTap { (tap) in
            print("delete indexPath = \(String(describing: indexPath))")
            
            let task = self.arrTask[indexPath.row]
            do {
                try task.er.delete()
            } catch let error {
                print("\(String(describing: error))")
            }
            
            self.arrTask.remove(at: indexPath.row)
            
            // -- Upload uitableview delete row --
            self.tblContent.beginUpdates()
            self.tblContent.deleteRows(at: [indexPath], with: .left)
            self.tblContent.endUpdates()
            // Reload uitableview update IndexPath
            self.tblContent.reloadData()
        }
        
        cell!.accessoryView = btn
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arrTask[indexPath.row]
        print("\(String(describing: item))")
        
    }
}

