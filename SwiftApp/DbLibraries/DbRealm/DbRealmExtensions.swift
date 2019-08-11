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

public typealias DbrmSelecteManyCompleted<T:Object> = ([T]?, Error?) -> Void
public typealias DbrmSelecteCompleted<T:Object> = (T?, Error?) -> Void
public typealias DbrmCompleted = (Error?) -> Void

public extension EasyRealmStatic where T:Object {
    
    // -- Only change try ... catch by closure --
    
    // MARK: - Get row functions
    // MARK: -
    
    func db_get<K>(WithPrimaryKey key: K) -> T?
    {
        do {
            return try self.fromRealm(with: key)
        } catch {
        }
        return nil
    }
    
    func db_get(WithCondition condition: String) -> T?
    {
        do {
            return try self.all().filter(condition).first
        } catch {
        }
        return nil
    }
    
    // -- For detail error --
    func db_get<K>(WithPrimaryKey key: K, Complete complete: DbrmSelecteCompleted<T>)
    {
        do {
            let result = try self.fromRealm(with: key)
            complete(result, nil)
        } catch let error {
            complete(nil, error)
        }
    }
    
    // -- For detail error --
    func db_get(WithCondition condition: String, Complete complete: DbrmSelecteCompleted<T>)
    {
        self.db_all(WithCondition: condition) { (results, error) in
            if let error = error {
                complete(nil, error)
                return
            }
            // -- co truong hop khong tim thay du lieu, result = nil, error = nil --
            complete(results?.first, nil)
        }
    }
    
    // MARK: - Get all rows functions
    // MARK: -
    
    func db_all(WithCondition condition: String? = nil,
                SortedByKeyPath keyPath: String? = nil,
                Ascending ascending: Bool = true) -> [T]
    {
        do {
            var objects = try self.all()
            if condition != nil {
                objects = objects.filter(condition!)
            }
            if keyPath != nil {
                objects = objects.sorted(byKeyPath: keyPath!, ascending: ascending)
            }
            return Array(objects)
        } catch {
        }
        return []
    }

    // -- For detail error --
    func db_all(WithCondition condition: String? = nil,
                SortedByKeyPath keyPath: String? = nil,
                Ascending ascending: Bool = true,
                WithComplete complete: DbrmSelecteManyCompleted<T>)
    {
        do {
            var objects = try self.all()
            if condition != nil {
                objects = objects.filter(condition!)
            }
            if keyPath != nil {
                objects = objects.sorted(byKeyPath: keyPath!, ascending: ascending)
            }
            complete(Array(objects), nil)
        } catch let error {
//            fatalError("Delete condition: '\(condition)' error => \(String(describing: error))")
            complete(nil, error)
        }
    }
    
    // MARK: - Delete row functions
    // MARK: -
    
    func db_delete(WithPrimaryKey key: Any, WithComplete complete: DbrmCompleted? = nil)
    {
        var condition : String = ""
        let strPrimaryKey = T.self.primaryKey() ?? "_none_"
        if key is String {
            condition = "\(strPrimaryKey) == '\(key)'"
        }else{
            condition = "\(strPrimaryKey) == \(key)"
        }
        db_delete(WithCondition: condition, WithComplete: complete)
    }
    
    func db_delete(WithCondition condition: String, WithComplete complete: DbrmCompleted? = nil)
    {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(try! self.all().filter(condition))
                complete?(nil)
            }
        } catch let error {
            // fatalError("Delete condition: '\(condition)' error => \(String(describing: error))")
            complete?(error)
        }
    }
}

public extension EasyRealm where T:Object
{
    // MARK: - Save Or Update row functions
    // MARK: -
    
    func db_saveOrUpdate(WithComplete complete: DbrmCompleted? = nil)
    {
        // -- If exsited record with primary key, it will run update --
        // let _ = try! self.saved(update: true)
        do {
            let _ = try self.saved(update: true)
            complete?(nil)
        } catch let error {
            // fatalError("saveOrUpdate")
            complete?(error)
        }
    }
    
    // MARK: - Edit row functions
    // MARK: -
    
    func db_edit(_ closure: @escaping (_ T:T) -> Void, WithComplete complete: DbrmCompleted? = nil)
    {
        // try! self.edit(closure)
        do {
            try self.edit(closure)
            complete?(nil)
        } catch let error {
            // fatalError("edit")
            complete?(error)
        }
    }
    
    // MARK: - Delete row functions
    // MARK: -
    
    func db_delete(WithComplete complete: DbrmCompleted? = nil)
    {
        // try! self.delete()
        do {
            try self.delete()
            complete?(nil)
        } catch let error {
            // fatalError("saveOrUpdate")
            complete?(error)
        }
    }
}

