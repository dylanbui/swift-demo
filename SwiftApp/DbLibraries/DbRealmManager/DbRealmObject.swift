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

/*
 Realm luon co 1 khoa chinh khai bao trong ham
 
 override class func primaryKey() -> String?
 {
    return "wardId"
 }
 */

class DbRealmObject: Object, Mappable
{
//    dynamic var username: NSString?
//    var friends: List<User>?
    
    required convenience init?(map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map)
    {
//        username              <- map["username"]
//        friends               <- (map["friends"], ListTransform<User>())
    }
    
    // -- Update when exist row --
    func save() -> Void
    {
        // -- Realm save --
        DbRealmManager.save(T: self)
    }
    
    // Khong su dung
//    func incID(_ primaryKey: String) -> Int
//    {
//        // let primaryKey = type(of: self).primaryKey()!
//        // All object inside the model passed.
//        let realm = try! Realm()
//        return (realm.objects(type(of: self)).max(ofProperty: primaryKey) as Int? ?? 0) + 1
//    }
//
//    func saveWithIncId(_ completion: @escaping (_ success : Bool, _ incId: Int) -> Void)
//    {
//        let primaryKey = type(of: self).primaryKey()!
////        let primaryKey = "incId"
//
//        let id = self.incID(primaryKey)
//        // -- Set id for primary key --
//        self.setValue(id, forKey: primaryKey)
//        // -- Realm save --
//        // DbRealmManager.save(T: self)
//        DbRealmManager.saveWithCompletion(T: self, completion: { (done) in
//            completion(done, id)
//        })
//
//    }

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
            // print("primaryKey = \(type(of: self).primaryKey()!)")
            let primaryKey = type(of: self).primaryKey()!
            
//            var id: Int = 1
//            if results.count > 0 {
//                id = (results.max(ofProperty: primaryKey) as Int? ?? 0) + 1
//            }
            
            let id: Int = (results.max(ofProperty: primaryKey) as Int? ?? 0) + 1
            // -- Set id for primary key --
            self.setValue(id, forKey: primaryKey)
            // -- Realm save --
            // DbRealmManager.save(T: self)
            DbRealmManager.saveWithCompletion(T: self, completion: { (done) in
                // -- Callback --
                completionHandler(id)
            })
        }
    }
    
    /*
     let arrObj = DistrictUnit().getAll(fromClass: DistrictUnit.self)
     for district: DistrictUnit in arrObj {
        print("districtName = \(district.districtName)")
     }
     */
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
    
    /*
     // Cach 1
     let obj: CityUnit = CityUnit().getObjectById(1) as! CityUnit
     print("obj.cityName = \(obj.cityName)")
     // Cach 2
     guard let obj: CityUnit = CityUnit().getObjectByCondition("cityId = 1") else {
        print("Khong tim thay du lieu")
        return
     }
     print("obj.cityName = \(obj.description)")
     */
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
