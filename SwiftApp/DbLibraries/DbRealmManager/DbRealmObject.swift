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
    
//    override class func primaryKey() -> String? {
//        return "username"
//    }
    
//    func className() -> String? {
//        return "username"
//    }
    
    func mapping(map: Map) {
//        username              <- map["username"]
//        friends               <- (map["friends"], ListTransform<User>())
    }
    
    func update() -> Void {
        
    }
    
    func save() -> Void {
        // -- Realm save --
        DbRealmManager.save(T: self)
    }
    
    func load(objectID: String) -> Void
    {
        let primaryKey = type(of: self).primaryKey()!
        let condition : String =  "\(primaryKey) == \(objectID)"
        
        let realm = try! Realm()
        
        let results = realm.objects(type(of: self)).filter(condition)
        if (results.count > 0) {
            let object: DbRealmObject = results.first! // as! DbRealmObject
            
            // object.toJSONString(prettyPrint: true)
            print(String(describing: object.toJSONString(prettyPrint: true)))
            
            // Convert Object to JSON
//            let serializedUser = Mapper().toJSONString(object)
//            print(serializedUser)

            
//            print(object.toJSONString())
            print("-------")
//
            self.mapping(map: Map(mappingType: .fromJSON, JSON: object.toJSON()))
            
        }
//        completionHandler (object)
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
//        return (realm.objects(self..self).max(ofProperty: DbRealmObject.primaryKey()) as Int? ?? 0) + 1
//        UUID().uuidString
        
    }
}
