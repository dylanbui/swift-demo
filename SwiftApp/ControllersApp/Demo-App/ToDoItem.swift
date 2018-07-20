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

class ToDoItem: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var createDate = Date()
    
//    var text: String = ""
    @objc dynamic var complete: Bool = false
    
//    init(text: String) {
//        super.init()
////        self.text = text
//        self.complete = false
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



