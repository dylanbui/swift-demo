//
//  DbRealmObject.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/23/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class DbRealmObject: Object, Mappable {
//    dynamic var username: NSString?
//    var friends: List<User>?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    // -- Khong duoc khai bao san o day --
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
//    func className() -> String? {
//        return "username"
//    }
    
    func mapping(map: Map) {
//        username              <- map["username"]
//        friends               <- (map["friends"], ListTransform<User>())
    }
    
//    func defaultPrimaryKey() -> String {
//        return "id"
//    }
    
    func save() -> Void {
        // -- Realm save --
        DbRealmManager.save(T: self)
    }
    
    func saveWithIncrementID() -> Void
    {
        self.saveWithIncrementID { (newId) in }
    }
    
    // Generate auto-increment id manually
    func saveWithIncrementID(completionHandler: @escaping(_ newId: Int) -> Void) -> Void
    {
        // Get the default Realm
        // String(describing: self.classForCoder)
        DbRealmManager.fetch(model: String(describing: self.classForCoder), condition: nil) { (results) in
            
            print("primaryKey = \(type(of: self).primaryKey()!)")
            let primaryKey = type(of: self).primaryKey()!
            
//            var id: Int = 1
//            if results.count > 0 {
//                id = (results.max(ofProperty: primaryKey) as Int? ?? 0) + 1
//            }
            
            let id: Int = (results.max(ofProperty: primaryKey) as Int? ?? 0) + 1
            // -- Set id for primary key --
            self.setValue(id, forKey: primaryKey)
            // -- Realm save --
            DbRealmManager.save(T: self)
            // -- Callback --
            completionHandler(id)
        }
        
        //DbRealmManager.getFetchList(T: self, condition: <#T##String?#>, completionHandler: <#T##([Object]) -> Void#>)
//        let realm = try! Realm()
//        return (realm.objects(self).max(ofProperty: DbRealmObject.primaryKey()) as Int? ?? 0) + 1
//        UUID().uuidString
    }
    
    
    // MARK: - Su dung Realm trong Thread vua tao doi duong
    // MARK: -
    
    // -- Khong su dung thang nay, nen tra ve doi duong luon --
//    func load(_ idVal: Any) -> Void
//    {
        //let primaryKey = type(of: self).primaryKey()!
//        let primaryKey = self.defaultPrimaryKey()
//        let condition : String =  "\(primaryKey) == \(objectID)"
//
//        let realm = try! Realm()
//        let results = realm.objects(type(of: self)).filter(condition)
//        if (results.count > 0) {
//            let object: DbRealmObject = results.first! // as! DbRealmObject
//
//            // object.toJSONString(prettyPrint: true)
//            //            print(String(describing: object.toJSONString(prettyPrint: true)))
//
//            // Convert Object to JSON
//            //            let serializedUser = Mapper().toJSONString(object)
//            //            print(serializedUser)
//            //            print(object.toJSONString())
//            //            print("-------")
//            //
//            self.mapping(map: Map(mappingType: .fromJSON, JSON: object.toJSON()))
//        }
    
    // Chay tot
//        if let obj = self.getObjectById(idVal) {
//            self.mapping(map: Map(mappingType: .fromJSON, JSON: obj.toJSON()))
//        }
//    }
    
//    func getAll() -> Results<DbRealmObject>
//    {
//        return self.getAll(nil)
//    }

    func getAll<T: DbRealmObject>(fromClass cls: T.Type, condition: String? = nil, orderField: String? = nil) -> Results<T>
    {
        // All object inside the model passed.
        let realm = try! Realm()
        var fetchedObjects = realm.objects(cls)
        if let cond = condition {
            // filters the result if condition exists
            fetchedObjects = fetchedObjects.filter(cond)
        }
        if let order = orderField {
            // sorted the result if orderField exists
            fetchedObjects = fetchedObjects.sorted(byKeyPath: order)
        }
        return fetchedObjects
    }
    
//    func getAll(_ condition: String?) -> Results<DbRealmObject>
//    {
//        // All object inside the model passed.
//        let realm = try! Realm()
//        var fetchedObjects = realm.objects(type(of: self))
//        if let cond = condition {
//            // filters the result if condition exists
//            fetchedObjects = fetchedObjects.filter(cond)
//        }
//
//        return fetchedObjects
//    }
    
    func getObjectById(_ idVal: Any) -> Self?
    {
        var condition : String = ""
        let primaryKey = type(of: self).primaryKey()!
        if idVal is String {
            condition = "\(primaryKey) == '\(idVal)'"
        }else{
            condition = "\(primaryKey) == \(idVal)"
        }
        return self.getObjectByCondition(condition)
    }
    
    func getObjectByCondition(_ cond: String) -> Self?
    {
        // All object inside the model passed.
        let realm = try! Realm()
        let fetchedObjects = realm.objects(type(of: self)).filter(cond)
        return fetchedObjects.count > 0 ? fetchedObjects.first : nil
    }
    
    func deleteByCondition(_ condition: String)
    {
        DbRealmManager.deleteObjectByCondition(T: self, condition: condition, completionHandler: { (success) in })        
    }

    func deleteByCondition(_ condition: String, completionHandler: @escaping(_ success:Bool) -> Void)
    {
        DbRealmManager.deleteObjectByCondition(T: self, condition: condition, completionHandler: completionHandler)
    }
    
    
}
