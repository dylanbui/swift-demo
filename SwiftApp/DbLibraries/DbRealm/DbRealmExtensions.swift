//
//  EasyRealmExtensions.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Da build thanh cong

/* Day la phien ban hoan thanh ket hop EasyRealm. */

import Foundation
import Realm
import RealmSwift
import ObjectMapper
import EasyRealm

typealias DbrmObjectMappable = Object & Mappable

public class DbRealm {
    
    /// Initializate DB default
    ///
    /// - Parameter version: version number of your DB. Increment your version number when you have to update your db file.
    public class func configureDB(version: UInt64){
        DbRealm.configureDB(version: version, migrationBlock: nil)
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
}

/*
 Extensions for EasyRealm
 */

public extension EasyRealmStatic where T:Object {
    
    func db_get<K>(withPrimaryKey key: K) -> T?
    {
        do {
            return try self.fromRealm(with: key)
        } catch {
            
        }
        return nil
    }
    
    func db_delete(withPrimaryKey key: Any)
    {
        var condition : String = ""
        let strPrimaryKey = T.self.primaryKey() ?? "_none_"
        if key is String {
            condition = "\(strPrimaryKey) == '\(key)'"
        }else{
            condition = "\(strPrimaryKey) == \(key)"
        }
        db_delete(WithCondition: condition)
    }
    
    func db_all() -> [T]
    {
        return try! Array(self.all())
    }
    
    func db_all(WithCondition condition: String? = nil, sortedByKeyPath keyPath: String? = nil, ascending: Bool = true) -> [T]
    {
        var objects = try! self.all()
        if condition != nil {
            objects = objects.filter(condition!)
        }
        if keyPath != nil {
            objects = objects.sorted(byKeyPath: keyPath!, ascending: ascending)
        }
        return Array(objects)
    }
    
    func db_delete(WithCondition condition: String)
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

public extension EasyRealm where T:Object
{
    func db_saveOrUpdate()
    {
        let _ = try! self.saved(update: true)
    }
    
    func db_edit(_ closure: @escaping (_ T:T) -> Void) {
        
        try! self.edit(closure)
        
        //self.isManaged ? try managed_edit(closure) : try unmanaged_dit(closure)
    }
    
    func db_delete()
    {
        try! self.delete()
        
    }
}

