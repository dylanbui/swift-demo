//
//  DbRealmManagerExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/22/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//  Base on : https://github.com/iMark21/MMRealmWrapper

import Foundation
import Realm
import RealmSwift

public extension DbRealmManager {
    
    /// Initializate DB default
    ///
    /// - Parameter version: version number of your DB. Increment your version number when you have to update your db file.
    public class func configureDB(version: UInt64){
        DbRealmManager.configureDB(version: version, migrationBlock: nil)
//        let config = Realm.Configuration(schemaVersion: version, migrationBlock: { migration, oldSchemaVersion in
//            if (oldSchemaVersion < version) {
//                // Nothing to do!
//                // Realm will automatically detect new properties and removed properties
//                // And will update the schema on disk automatically
//            }
//        })
//        Realm.Configuration.defaultConfiguration = config
    }
    
    /// Initializate DB default
    ///
    /// - Parameter version: version number of your DB. Increment your version number when you have to update your db file.
    public class func configureDB(version: UInt64, migrationBlock: MigrationBlock?){
        let config = Realm.Configuration(schemaVersion: version, migrationBlock: { migration, oldSchemaVersion in
            if let migrationBlock = migrationBlock {
                migrationBlock(migration, oldSchemaVersion)
            }
        })
        Realm.Configuration.defaultConfiguration = config
        print("\(String(describing: Realm.Configuration.defaultConfiguration.fileURL?.absoluteString))")
    }
    
    /// Initializate shared DB
    ///
    /// - Parameters:
    ///   - ApplicationGroupIdentifier: Application Security Group Identifier defined on iTunesConnect account like app.identifier.com
    ///   - version: version number of your DB. Increment your version number when you have to update your db file.
    public class func configureSharedDB(ApplicationGroupIdentifier:String, version: UInt64){
        let AppGroupContainerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: ApplicationGroupIdentifier)
        let realmPath = AppGroupContainerUrl?.appendingPathComponent("db.realm")
        var config = Realm.Configuration(schemaVersion: version, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < version) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        config.fileURL = realmPath
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// Save Object without waiting until finished
    ///
    /// - Parameter T: Realm Object
    public class func save(T: Object)  {
        DbRealmManager.addOrUpdate(model: String(describing: T.self), object: T, completionHandler: { (error) in
        })
    }
    
    /// Save Object waiting until task this is finished
    ///
    /// - Parameters:
    ///   - T: Realm Object
    ///   - completion: returns success or not for this task.
    public class func saveWithCompletion(T: Object?, completion: @escaping (_ success : Bool) -> Void)  {
        if T == nil {
            completion (false)
        }
        DbRealmManager.addOrUpdate(model: String(describing: T.self), object: T, completionHandler: { (error) in
            if (error == nil){
                completion (true)
            }else{
                completion (false)
            }
        })
    }
    
    
    /// Save Array of Objects waiting until this task is finished
    ///
    /// - Parameters:
    ///   - T: Array of Realm Objects
    ///   - completion: Returns success or not for this task.
    public class func saveArrayObjects(T: [Object], completion: @escaping (_ success : Bool) -> Void) {
        let numberObjects : Int = T.count
        var savedObjects : Int = 0
        DbRealmManager.addOrUpdate(model: String(describing: T.self), object: T, completionHandler: { (error) in
            savedObjects = savedObjects+1
            if (savedObjects == numberObjects) {
                completion (true)
            }
        })
    }
    
    
    /// Get array of objects by class
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - completionHandler: Returns array list of objects
    public class func getAllListOf(T: Object, completionHandler: @escaping(_ result:[Object]) -> Void)  {
        //Fetches all objects inside 'Class' model class
        DbRealmManager.fetch(model: String(describing: T.classForCoder), condition: nil, completionHandler: { (result) in
            let arrayMutable : NSMutableArray = []
            for T in result {
                arrayMutable.add(T)
            }
            completionHandler (arrayMutable.copy() as! [Object])
        })
    }
    
    /// Get unique object by Identifier
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectID: Identifier of Object assuming that key of object is 'id'
    ///   - completionHandler: Return object or nil if not exist
    public class func getFetchObject(T: Object, objectID: String, completionHandler: @escaping(_ result:Object?) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "id") as Any
                if primaryKeyValue is String {
                    condition = "id == '\(objectID)'"
                }else{
                    condition = "id == \(objectID)"
                }
                DbRealmManager.fetch(model: String(describing: T.classForCoder), condition: condition, completionHandler: { (result) in
                    let arrayMutable : NSMutableArray = []
                    for T in result {
                        arrayMutable.add(T)
                    }
                    if arrayMutable.count > 0 {
                        let object: Object = arrayMutable.firstObject as! Object
                        completionHandler (object)
                    }else{
                        completionHandler (nil)
                    }
                })
            }else{
                completionHandler (nil)
            }
        }
    }
    
    /// Get unique object by CustomPrimareyKey
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectPrimaryKey: Primary Key defined for Object
    ///   - objectPrimaryKeyValue: Primary Key Value for Object that you want to look for.
    ///   - completionHandler: Return object or nil if not exist
    public class func getFetchObjectWithCustomPrimareyKey(T: Object, objectPrimaryKey: String, objectPrimaryKeyValue: String, completionHandler: @escaping(_ result:Object?) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "id") as Any
                if primaryKeyValue is String {
                    condition = "\(objectPrimaryKey) == \(objectPrimaryKeyValue)"
                }else{
                    condition = "\(objectPrimaryKey) == '\(objectPrimaryKeyValue)'"
                }
                DbRealmManager.fetch(model: String(describing: T.classForCoder), condition:condition, completionHandler: { (result) in
                    let arrayMutable : NSMutableArray = []
                    for T in result {
                        arrayMutable.add(T)
                    }
                    if arrayMutable.count > 0 {
                        let object: Object = arrayMutable.firstObject as! Object
                        completionHandler (object)
                    }else{
                        completionHandler (nil)
                    }
                })
            }else{
                completionHandler (nil)
            }
        }
    }
    
    
    /// Get list of object by condition
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - condition: Optional parameter with condition like -> condition: "keyParam == valueParam AND keyParam == valueParam"
    ///   - completionHandler: Returns array list of objects by condition
    public class func getFetchList(T: Object, condition: String?, completionHandler: @escaping(_ result:[Object]) -> Void)  {
        DbRealmManager.fetch(model: String(describing: T.classForCoder), condition: condition, completionHandler: { (result) in
            let arrayMutable : NSMutableArray = []
            for T in result {
                arrayMutable.add(T)
            }
            completionHandler (arrayMutable as! [Object])
        })
    }
    
    /// Delete object providing Identifier
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectID: Identifier of Object assuming that key of object is 'id'
    ///   - completionHandler: Return if operation is completed properly
    public class func deleteObjectById(T: Object, objectID: String, completionHandler: @escaping(_ success:Bool) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "id") as Any
                if primaryKeyValue is String {
                    condition = "id == '\(objectID)'"
                }else{
                    condition = "id == \(objectID)"
                }
                DbRealmManager.delete(model: String(describing: T.self), condition: condition, completionHandler: { (error) in
                    if (error == nil){
                        completionHandler (true)
                    }else{
                        completionHandler (false)
                    }
                })
            }else{
                completionHandler (true) //all content is deleted
            }
        }
    }
    
    /// Delete object providing your own customPrimareyKey
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - objectPrimaryKey: Primary Key defined for Object
    ///   - objectPrimaryKeyValue: Primary Key Value for Object that you want to look for.
    ///   - completionHandler: Return if operation is completed properly
    public class func deleteObjectByCustomPrimaryKey(T: Object, objectPrimaryKey: String, objectPrimaryKeyValue: String, completionHandler: @escaping(_ success:Bool) -> Void)  {
        getAllListOf(T: T) { (objects) in
            var condition : String = ""
            if objects.count > 0{
                let object : Object = objects.first!
                let primaryKeyValue : Any = object.value(forKey: "objectPrimaryKey") as Any
                if primaryKeyValue is String {
                    condition = "\(objectPrimaryKey) == '\(objectPrimaryKeyValue)'"
                }else{
                    condition = "\(objectPrimaryKey) == '\(objectPrimaryKeyValue)'"
                }
                DbRealmManager.delete(model: String(describing: T.self), condition: condition, completionHandler: { (error) in
                    if (error == nil){
                        completionHandler (true)
                    }else{
                        completionHandler (false)
                    }
                })
            }else{
                completionHandler (true) //all content is deleted
            }
        }
    }
    
    /// Delete object / objects by condition
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - condition: Optional parameter with condition like -> condition: "keyParam == valueParam AND keyParam == valueParam"
    ///   - completionHandler: Return if operation is completed properly
    public class func deleteObjectByCondition(T: Object, condition: String, completionHandler: @escaping(_ success:Bool) -> Void)  {
        getFetchList(T: T, condition: condition) { (objects) in
            if objects.count > 0 {
                let totalObjectToDelete: Int = objects.count
                var counter: Int = 0
                for object in objects{
                    self.deleteObjectWithCompletion(T: object, completionHandler: { (success) in
                        counter = counter+1
                        if counter == totalObjectToDelete{
                            completionHandler (true)
                        }
                    })
                }
            }else{
                completionHandler (true) // all objects deleted
            }
        }
    }
    
    
    /// Delete all objects of class
    ///
    /// - Parameters:
    ///   - T: Realm Object like ObjectNameClass()
    ///   - completionHandler: Return if operation is completed properly
    public class func deleteAllObjectWithCompletion(T: Object, completionHandler: @escaping(_ success:Bool) -> Void)  {
        let realm = try! Realm()
        let allObjects = realm.objects(Object.self)
        do {
            try! realm.write({
                realm.delete(allObjects)
                completionHandler (true)
            })
        }
    }
    
    /// Delete object providing a object
    ///
    /// - Parameters:
    ///   - T: Object to delete
    ///   - completionHandler: Return if operation is completed properly
    public class func deleteObjectWithCompletion(T: Object, completionHandler: @escaping(_ success:Bool) -> Void)  {
        DbRealmManager.deleteObject(object: T) { (error) in
            if error == nil{
                completionHandler (true)
            }else{
                completionHandler (false)
            }
        }
    }
    
}
