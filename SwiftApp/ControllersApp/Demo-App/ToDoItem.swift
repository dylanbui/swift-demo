//
//  ToDoItem.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/19/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper
import EasyRealm


class TaskItem: Object
{
    @objc dynamic var autoId: String = ""
    
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var createDate = Date()
    @objc dynamic var complete: Bool = false
    
    override class func primaryKey() -> String?
    {
        return "autoId"
    }
    
    static func initAutoId(forTitle : String) -> TaskItem
    {
        return TaskItem.init(autoId: UUID().uuidString, text: forTitle)
    }
    
    convenience init(autoId: String, text: String)
    {
        self.init()
        self.autoId = autoId
        self.title = text
        self.detail = "Detail : ==> " + text
        self.complete = false
    }
    
    
    
}

class ToDoItem: Object
{
    @objc dynamic var id: Int = -1
    
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var createDate = Date()
    @objc dynamic var complete: Bool = false
    
    override class func primaryKey() -> String?
    {
        return "id"
    }
    
    convenience init(id: Int, text: String)
    {
        self.init()
        self.id = id
        self.title = text
        self.detail = "Detail : ==> " + text
        self.complete = false
    }
    
//    init(text: String) {
//        super.init()
//        self.title = text
//        self.complete = false
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
    //
//    init(frame: CGRect) {
//        super.init()
//    }
    

}


// Dog model
class Dog: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var owner: Person? // Properties can be optional
    @objc dynamic var color: String = "Yellow"
    
    @objc dynamic var giongLoai: String = "Ngao Tang"
}

// Person model
class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var age: Int = 10
    @objc dynamic var birthdate = Date(timeIntervalSince1970: 1)
    let dogs = List<Dog>()
}



