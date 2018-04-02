//
//  DemoTableViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit

class DemoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var tblContent: UITableView!
    
    let arrItems = ["One", "Two", "Three"]
    var toDoItems = [ToDoItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if toDoItems.count > 0 {
            return
        }
        
        toDoItems.append(ToDoItem(text: "feed the cat"))
        toDoItems.append(ToDoItem(text: "buy eggs"))
        toDoItems.append(ToDoItem(text: "watch WWDC videos"))
        toDoItems.append(ToDoItem(text: "rule the Web"))
        toDoItems.append(ToDoItem(text: "buy a new iPhone"))
        toDoItems.append(ToDoItem(text: "darn holes in socks"))
        toDoItems.append(ToDoItem(text: "write this tutorial"))
        toDoItems.append(ToDoItem(text: "master Swift"))
        toDoItems.append(ToDoItem(text: "learn to draw"))
        toDoItems.append(ToDoItem(text: "get more exercise"))
        toDoItems.append(ToDoItem(text: "catch up with Mom"))
        toDoItems.append(ToDoItem(text: "get a hair cut"))
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return toDoItems.count
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
        
        let item = toDoItems[indexPath.row]
        print("--- \(item.text)")
        cell.lblTitle.text = self.formatTitle(title: item.text)
        cell.lblSubTitle?.text = self.formatSubTitle(item.text, titleKey: "My key")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    

}

