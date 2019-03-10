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

//typealias DbObject = Object & Mappable
//
//extension NSObject where T: DbObject{
//
//}

public extension EasyRealmStatic where T:Object {
    
//    public func fromRealm<K>(with primaryKey:K) throws -> T {
//        let realm = try Realm()
//        if let object = realm.object(ofType: self.baseType, forPrimaryKey: primaryKey) {
//            return object
//        } else {
//            throw EasyRealmError.ObjectWithPrimaryKeyNotFound
//        }
//    }
//
//    public func all() throws -> Results<T> {
//        let realm = try Realm()
//        return realm.objects(self.baseType)
//    }
    
    public func db_all() -> [T]
    {
        return try! Array(self.all())
    }

//    public func db_all(WithCondition condition: String) -> [T]
//    {
//        return try! Array(self.all().filter(condition))
//        //self.arrTask = try! Array(TaskItem.er.all().sorted(byKeyPath: "title"))
//    }
    
    //sorted(byKeyPath keyPath: String, ascending: Bool = true)
    public func db_all(WithCondition condition: String? = nil, sortedByKeyPath keyPath: String? = nil, ascending: Bool = true) -> [T]
    {
        var objects = try! self.all()
        if condition != nil {
            objects = objects.filter(condition!)
        }
        if keyPath != nil {
            objects = objects.sorted(byKeyPath: keyPath!, ascending: ascending)
        }
        return Array(objects)
        
        // return try! Array(self.all().filter(condition))
        //self.arrTask = try! Array(TaskItem.er.all().sorted(byKeyPath: "title"))
    }

    public func db_delete(WithCondition condition: String)
    {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(try! self.all().filter(condition))
            }
        } catch let error {
            fatalError("Delete condition: '\(condition)' error => \(String(describing: error))")
        }
    }
    

}

extension EasyRealm where T:Object
{
    public func db_saveOrUpdate()
    {
        let _ = try! self.saved(update: true)
    }
    
    public func db_edit(_ closure: @escaping (_ T:T) -> Void) {
        
        try! self.edit(closure)
        
        //self.isManaged ? try managed_edit(closure) : try unmanaged_dit(closure)
    }
    
    public func db_delete()
    {
        try! self.delete()
        
    }
}

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



