//
//  DemoTableViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
//import Realm
import RealmSwift

public let K_GROUP_ID = "group.com.irekasoft.RealmTodo"
public let K_DB_NAME = "db.realm"

class DemoTableViewController: DbViewController
{

//    @IBOutlet weak var tblContent: UITableView!
    
    let arrItems = ["One", "Two", "Three"]
//    var toDoItems = [ToDoItem]()
    
    var realm : Realm!
    
    var toDoItemsList: Results<ToDoItem> {
        get {
            return realm.objects(ToDoItem.self)
        }
    }
    
    func realmConfig() -> Void
    {
//        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
//        let fileURL = directory.appendingPathComponent(K_DB_NAME)
//        realm = try! Realm(fileURL: fileURL)
        
        realm = try! Realm()
        print("file url \(String(describing: realm.configuration.fileURL))")
    }
    
    @objc func call_Method(sender:UIButton!)
    {
        print("Button tapped tag 22")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let rightBarButtonItem_1 = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.call_Method))
        let rightBarButtonItem_2 = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(self.call_Method))
//        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "EditImage"), style: .done, target: self, action:#selector(self.call_Method))
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem_1
        self.navigationItem.rightBarButtonItems =  [rightBarButtonItem_1, rightBarButtonItem_2]
        
        self.realmConfig()
        
//        for j in 0..<3 {}    
        for i in 11...15 {
            let myDog = Dog()
            myDog.name = "Fido \(i)"
            myDog.age = i
            
            try! realm.write {
                realm.add(myDog)
            }
        }
        
//        let item = ToDoItem()
//        item.title = "Todo 1"
//        item.detail = "Chi tiet cong viec"
//
//        try! realm.write {
//            realm.add(item)
//        }
        
        // Do any additional setup after loading the view.
//        if toDoItems.count > 0 {
//            return
//        }
        
//        self.toDoItems = realm.objects(ToDoItem.self)
        
//        toDoItems.append(ToDoItem(text: "feed the cat"))
//        toDoItems.append(ToDoItem(text: "buy eggs"))
//        toDoItems.append(ToDoItem(text: "watch WWDC videos"))
//        toDoItems.append(ToDoItem(text: "rule the Web"))
//        toDoItems.append(ToDoItem(text: "buy a new iPhone"))
//        toDoItems.append(ToDoItem(text: "darn holes in socks"))
//        toDoItems.append(ToDoItem(text: "write this tutorial"))
//        toDoItems.append(ToDoItem(text: "master Swift"))
//        toDoItems.append(ToDoItem(text: "learn to draw"))
//        toDoItems.append(ToDoItem(text: "get more exercise"))
//        toDoItems.append(ToDoItem(text: "catch up with Mom"))
//        toDoItems.append(ToDoItem(text: "get a hair cut"))
        
    }
    
    func formatTitle(title: String) -> String {
        let str = "Gia tri format: \(title)"
        return str
    }
    
    func formatSubTitle(_ title: String, titleKey: String) -> String {
        let str = "Format sub key : \(titleKey) - \(title)"
        return str
    }
    
    // MARK: - Working with image icon
    // MARK: -
    
    
}

extension DemoTableViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return toDoItemsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: ToDoCell! = tableView.dequeueReusableCell(withIdentifier: "toDoCell") as? ToDoCell
        if(cell == nil) {
            cell = Bundle.main.loadNibNamed("ToDoCell", owner: self, options: nil)? [0] as! ToDoCell
        }
        
        // let item = toDoItems[indexPath.row]
        let item = toDoItemsList[indexPath.row]
        print("--- \(item.title)")
        cell.lblTitle.text = self.formatTitle(title: item.title)
        cell.lblSubTitle?.text = self.formatSubTitle(item.detail, titleKey: "My key")
        return cell
    }
}

extension DemoTableViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = toDoItemsList[indexPath.row]
        print("--- \(item.title)")
    }
}


