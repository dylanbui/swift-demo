//
//  DbCache.swift
//  SwiftApp
//
//  Created by Dylan Bui on 5/10/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//  Get on v1.3.0 : https://github.com/huynguyencong/DataCache/

import Foundation

internal extension Dictionary {
    func keysSortedByValue(_ isOrderedBefore: (Value, Value) -> Bool) -> [Key] {
        return Array(self).sorted{ isOrderedBefore($0.1, $1.1) }.map{ $0.0 }
    }
}

public enum DbDataCacheImageFormat {
    case unknown, png, jpeg
}

open class DbDataCache {
    static let cacheDirectoryPrefix = "com.dbdatacache.cache."
    static let ioQueuePrefix = "com.dbdatacache.queue."
    static let defaultMaxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7         // a week
    
    public static var instance = DbDataCache(name: "default")
    
    var cachePath: String
    
    let memCache = NSCache<AnyObject, AnyObject>()
    let ioQueue: DispatchQueue
    let fileManager: FileManager
    
    /// Name of cache
    open var name: String = ""
    
    /// Life time of disk cache, in second. Default is a week
    open var maxCachePeriodInSecond = DbDataCache.defaultMaxCachePeriodInSecond
    
    /// Size is allocated for disk cache, in byte. 0 mean no limit. Default is 0
    open var maxDiskCacheSize: UInt = 0
    
    /// Specify distinc name param, it represents folder name for disk cache
    public init(name: String, path: String? = nil) {
        self.name = name
        
        cachePath = path ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        cachePath = (cachePath as NSString).appendingPathComponent(DbDataCache.cacheDirectoryPrefix + name)
        
        ioQueue = DispatchQueue(label: DbDataCache.ioQueuePrefix + name)
        
        self.fileManager = FileManager()
        
        #if !os(OSX) && !os(watchOS)
        NotificationCenter.default.addObserver(self, selector: #selector(DbDataCache.cleanExpiredDiskCache), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DbDataCache.cleanExpiredDiskCache), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Store data

extension DbDataCache {
    
    /// Write data for key. This is an async operation.
    public func write(data: Data, forKey key: String) {
        memCache.setObject(data as AnyObject, forKey: key as AnyObject)
        writeDataToDisk(data: data, key: key)
    }
    
    func writeDataToDisk(data: Data, key: String) {
        ioQueue.async {
            if self.fileManager.fileExists(atPath: self.cachePath) == false {
                do {
                    try self.fileManager.createDirectory(atPath: self.cachePath, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    print("Error while creating cache folder")
                }
            }
            
            self.fileManager.createFile(atPath: self.cachePath(forKey: key), contents: data, attributes: nil)
        }
    }
    
    /// Read data for key
    public func readData(forKey key:String) -> Data? {
        var data = memCache.object(forKey: key as AnyObject) as? Data
        
        if data == nil {
            if let dataFromDisk = readDataFromDisk(forKey: key) {
                data = dataFromDisk
                memCache.setObject(dataFromDisk as AnyObject, forKey: key as AnyObject)
            }
        }
        
        return data
    }
    
    /// Read data from disk for key
    public func readDataFromDisk(forKey key: String) -> Data? {
        return self.fileManager.contents(atPath: cachePath(forKey: key))
    }
    
    
    // MARK: Read & write utils
    
    
    /// Write an object for key. This object must inherit from `NSObject` and implement `NSCoding` protocol. `String`, `Array`, `Dictionary` conform to this method.
    ///
    /// NOTE: Can't write `UIImage` with this method. Please use `writeImage(_:forKey:)` to write an image
    public func write(object: NSCoding, forKey key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        write(data: data, forKey: key)
    }
    
    /// Write a string for key
    public func write(string: String, forKey key: String) {
        write(object: string as NSCoding, forKey: key)
    }
    
    /// Write a dictionary for key
    public func write(dictionary: Dictionary<AnyHashable, Any>, forKey key: String) {
        write(object: dictionary as NSCoding, forKey: key)
    }
    
    /// Write an array for key
    public func write(array: Array<Any>, forKey key: String) {
        write(object: array as NSCoding, forKey: key)
    }
    
    /// Read an object for key. This object must inherit from `NSObject` and implement NSCoding protocol. `String`, `Array`, `Dictionary` conform to this method
    public func readObject(forKey key: String) -> NSObject? {
        let data = readData(forKey: key)
        
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSObject
        }
        
        return nil
    }
    
    /// Read a string for key
    public func readString(forKey key: String) -> String? {
        return readObject(forKey: key) as? String
    }
    
    /// Read an array for key
    public func readArray(forKey key: String) -> Array<Any>? {
        return readObject(forKey: key) as? Array<Any>
    }
    
    /// Read a dictionary for key
    public func readDictionary(forKey key: String) -> Dictionary<AnyHashable, Any>? {
        return readObject(forKey: key) as? Dictionary<AnyHashable, Any>
    }
    
    // MARK: Read & write image
    
    /// Write image for key. Please use this method to write an image instead of `writeObject(_:forKey:)`
    public func write(image: UIImage, forKey key: String, format: DbDataCacheImageFormat? = nil) {
        var data: Data? = nil
        
        if let format = format, format == .png {
            data = UIImagePNGRepresentation(image)
        }
        else {
            data = UIImageJPEGRepresentation(image, 0.9)
        }
        
        if let data = data {
            write(data: data, forKey: key)
        }
    }
    
    /// Read image for key. Please use this method to write an image instead of `readObjectForKey(_:)`
    public func readImageForKey(key: String) -> UIImage? {
        let data = readData(forKey: key)
        if let data = data {
            return UIImage(data: data, scale: 1.0)
        }
        
        return nil
    }
}

// MARK: Utils

extension DbDataCache {
    
    /// Check if has data on disk
    public func hasDataOnDisk(forKey key: String) -> Bool {
        return self.fileManager.fileExists(atPath: self.cachePath(forKey: key))
    }
    
    /// Check if has data on mem
    public func hasDataOnMem(forKey key: String) -> Bool {
        return (memCache.object(forKey: key as AnyObject) != nil)
    }
}

// MARK: Clean

extension DbDataCache {
    
    /// Clean all mem cache and disk cache. This is an async operation.
    public func cleanAll() {
        cleanMemCache()
        cleanDiskCache()
    }
    
    /// Clean cache by key. This is an async operation.
    public func clean(byKey key: String) {
        memCache.removeObject(forKey: key as AnyObject)
        
        ioQueue.async {
            do {
                try self.fileManager.removeItem(atPath: self.cachePath(forKey: key))
            } catch {}
        }
    }
    
    public func cleanMemCache() {
        memCache.removeAllObjects()
    }
    
    public func cleanDiskCache() {
        ioQueue.async {
            do {
                try self.fileManager.removeItem(atPath: self.cachePath)
            } catch {}
        }
    }
    
    /// Clean expired disk cache. This is an async operation.
    @objc public func cleanExpiredDiskCache() {
        cleanExpiredDiskCache(completion: nil)
    }
    
    // This method is from Kingfisher
    /**
     Clean expired disk cache. This is an async operation.
     
     - parameter completionHandler: Called after the operation completes.
     */
    open func cleanExpiredDiskCache(completion handler: (()->())? = nil) {
        
        // Do things in cocurrent io queue
        ioQueue.async {
            
            var (URLsToDelete, diskCacheSize, cachedFiles) = self.travelCachedFiles(onlyForCacheSize: false)
            
            for fileURL in URLsToDelete {
                do {
                    try self.fileManager.removeItem(at: fileURL)
                } catch _ { }
            }
            
            if self.maxDiskCacheSize > 0 && diskCacheSize > self.maxDiskCacheSize {
                let targetSize = self.maxDiskCacheSize / 2
                
                // Sort files by last modify date. We want to clean from the oldest files.
                let sortedFiles = cachedFiles.keysSortedByValue {
                    resourceValue1, resourceValue2 -> Bool in
                    
                    if let date1 = resourceValue1.contentAccessDate,
                        let date2 = resourceValue2.contentAccessDate
                    {
                        return date1.compare(date2) == .orderedAscending
                    }
                    
                    // Not valid date information. This should not happen. Just in case.
                    return true
                }
                
                for fileURL in sortedFiles {
                    
                    do {
                        try self.fileManager.removeItem(at: fileURL)
                    } catch { }
                    
                    URLsToDelete.append(fileURL)
                    
                    if let fileSize = cachedFiles[fileURL]?.totalFileAllocatedSize {
                        diskCacheSize -= UInt(fileSize)
                    }
                    
                    if diskCacheSize < targetSize {
                        break
                    }
                }
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                handler?()
            })
        }
    }
}

// MARK: Helpers

extension DbDataCache {
    
    // This method is from Kingfisher
    fileprivate func travelCachedFiles(onlyForCacheSize: Bool) -> (urlsToDelete: [URL], diskCacheSize: UInt, cachedFiles: [URL: URLResourceValues]) {
        
        let diskCacheURL = URL(fileURLWithPath: cachePath)
        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
        let expiredDate: Date? = (maxCachePeriodInSecond < 0) ? nil : Date(timeIntervalSinceNow: -maxCachePeriodInSecond)
        
        var cachedFiles = [URL: URLResourceValues]()
        var urlsToDelete = [URL]()
        var diskCacheSize: UInt = 0
        
        for fileUrl in (try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)) ?? [] {
            
            do {
                let resourceValues = try fileUrl.resourceValues(forKeys: resourceKeys)
                // If it is a Directory. Continue to next file URL.
                if resourceValues.isDirectory == true {
                    continue
                }
                
                // If this file is expired, add it to URLsToDelete
                if !onlyForCacheSize,
                    let expiredDate = expiredDate,
                    let lastAccessData = resourceValues.contentAccessDate,
                    (lastAccessData as NSDate).laterDate(expiredDate) == expiredDate
                {
                    urlsToDelete.append(fileUrl)
                    continue
                }
                
                if let fileSize = resourceValues.totalFileAllocatedSize {
                    diskCacheSize += UInt(fileSize)
                    if !onlyForCacheSize {
                        cachedFiles[fileUrl] = resourceValues
                    }
                }
            } catch _ { }
        }
        
        return (urlsToDelete, diskCacheSize, cachedFiles)
    }
    
    func cachePath(forKey key: String) -> String {
        let fileName = key.md5
        return (cachePath as NSString).appendingPathComponent(fileName)
    }
}

// -- Use source: https://gist.github.com/MihaelIsaev/f913d84b918d2b2c067d

import CommonCrypto

extension String {
    
    var md5: String {
        return HMAC.hash(self, algo: .MD5)
    }
    
    var sha1: String {
        return HMAC.hash(self, algo: .SHA1)
    }
    
    var sha224: String {
        return HMAC.hash(self, algo: .SHA224)
    }
    
    var sha256: String {
        return HMAC.hash(self, algo: .SHA256)
    }
    
    var sha384: String {
        return HMAC.hash(self, algo: .SHA384)
    }
    
    var sha512: String {
        return HMAC.hash(self, algo: .SHA512)
    }
}

private struct HMAC {
    
    static func hash(_ inp: String, algo: HMACAlgo) -> String {
        
        if let stringData = inp.data(using: .utf8, allowLossyConversion: false) {
            
            return hexStringFromData(digest(stringData as NSData, algo: algo))
        }
        
        return ""
    }
    
    private static func digest(_ input: NSData, algo: HMACAlgo) -> NSData {
        
        let digestLength = algo.digestLength()
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch algo {
        case .MD5: CC_MD5(input.bytes, UInt32(input.length), &hash)
        case .SHA1: CC_SHA1(input.bytes, UInt32(input.length), &hash)
        case .SHA224: CC_SHA224(input.bytes, UInt32(input.length), &hash)
        case .SHA256: CC_SHA256(input.bytes, UInt32(input.length), &hash)
        case .SHA384: CC_SHA384(input.bytes, UInt32(input.length), &hash)
        case .SHA512: CC_SHA512(input.bytes, UInt32(input.length), &hash)
        }
        return NSData(bytes: hash, length: digestLength)
    }
    
    private static func hexStringFromData(_ input: NSData) -> String {
        
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

private enum HMACAlgo {
    
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func digestLength() -> Int {
        
        var result: CInt = 0
        switch self {
        case .MD5: result = CC_MD5_DIGEST_LENGTH
        case .SHA1: result = CC_SHA1_DIGEST_LENGTH
        case .SHA224: result = CC_SHA224_DIGEST_LENGTH
        case .SHA256: result = CC_SHA256_DIGEST_LENGTH
        case .SHA384: result = CC_SHA384_DIGEST_LENGTH
        case .SHA512: result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

// MARK: - DbCache
// MARK: -

open class DbCache
{
    public static var instance = DbCache(uniqueName: "defaultDbCache")
    private var dataCache: DbDataCache!
    private var uniqueName: String!
    
    /// Specify distinc name param, it represents folder name for disk cache
    public init(uniqueName: String)
    {
        // Unique in UserDefaults
        self.uniqueName = "DbCache_\(uniqueName)"
        self.dataCache = DbDataCache(name: self.uniqueName)
        self.dataCache.maxCachePeriodInSecond = 60 * 60 * 24 * 7 * 2         // 2 week
    }
    
    /// Write data for key. This is an async operation.
    // Default age = 1 days
    public func write(data: Data, forKey key: String, withAge age: TimeInterval = 86400)
    {
        self.dataCache.write(data: data, forKey: key)
        self.setLastUpdateCacheFor(Key: key, with: ["key": key, "timeInterval": age, "lastUpdate": Date()])
    }
    
    /// Read data for key
    public func readData(forKey key:String) -> Data?
    {
        if self.expired(Key: key) {
            return nil
        }
        return self.dataCache.readData(forKey: key)
    }
    
    /// Clean cache by key. This is an async operation.
    public func clean(byKey key: String)
    {
        self.setLastUpdateCacheFor(Key: key, with: [:])
        self.dataCache.clean(byKey: key)
    }
    
    /// Clean all mem cache and disk cache. This is an async operation.
    public func cleanAll()
    {
        UserDefaults.setObject(key: self.uniqueName, value: [:])
        self.dataCache.cleanAll()
    }

    // MARK: Read & write utils
    
    /// Write an object for key. This object must inherit from `NSObject` and implement `NSCoding` protocol. `String`, `Array`, `Dictionary` conform to this method.
    ///
    /// NOTE: Can't write `UIImage` with this method. Please use `writeImage(_:forKey:)` to write an image
    public func write(object: NSCoding, forKey key: String, withAge age: TimeInterval = 86400)
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        self.write(data: data, forKey: key, withAge: age)
    }
    
    /// Write a string for key
    public func write(string: String, forKey key: String, withAge age: TimeInterval = 86400)
    {
        write(object: string as NSCoding, forKey: key, withAge: age)
    }
    
    /// Write a dictionary for key
    public func write(dictionary: Dictionary<AnyHashable, Any>, forKey key: String, withAge age: TimeInterval = 86400)
    {
        write(object: dictionary as NSCoding, forKey: key, withAge: age)
    }
    
    /// Write an array for key
    public func write(array: Array<Any>, forKey key: String, withAge age: TimeInterval = 86400)
    {
        write(object: array as NSCoding, forKey: key, withAge: age)
    }
    
    /// Read an object for key. This object must inherit from `NSObject` and implement NSCoding protocol. `String`, `Array`, `Dictionary` conform to this method
    public func readObject(forKey key: String) -> NSObject?
    {
        let data = readData(forKey: key)
        
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? NSObject
        }
        
        return nil
    }
    
    /// Read a string for key
    public func readString(forKey key: String) -> String?
    {
        return readObject(forKey: key) as? String
    }
    
    /// Read an array for key
    public func readArray(forKey key: String) -> Array<Any>?
    {
        return readObject(forKey: key) as? Array<Any>
    }
    
    /// Read a dictionary for key
    public func readDictionary(forKey key: String) -> Dictionary<AnyHashable, Any>?
    {
        return readObject(forKey: key) as? Dictionary<AnyHashable, Any>
    }
    
    // MARK: Read & write image
    
    /// Write image for key. Please use this method to write an image instead of `writeObject(_:forKey:)`
    public func write(image: UIImage, forKey key: String,
                      format: DbDataCacheImageFormat? = nil,
                      withAge age: TimeInterval = 86400)
    {
        var data: Data? = nil
        
        if let format = format, format == .png {
            data = UIImagePNGRepresentation(image)
        }
        else {
            data = UIImageJPEGRepresentation(image, 0.9)
        }
        
        if let data = data {
            write(data: data, forKey: key, withAge: age)
        }
    }
    
    /// Read image for key. Please use this method to write an image instead of `readObjectForKey(_:)`
    public func readImageForKey(key: String) -> UIImage?
    {
        let data = readData(forKey: key)
        if let data = data {
            return UIImage(data: data, scale: 1.0)
        }
        
        return nil
    }
    
    // MARK: - Private functions
    // MARK: -

    private func getLastUpdateCacheWith(Key key: String) -> DictionaryType?
    {
        if let cacheGlobal = UserDefaults.getDictionary(key: self.uniqueName) as? [String: DictionaryType],
            let cache = cacheGlobal[key] {
            return cache
        }
        return nil
    }
    
    private func setLastUpdateCacheFor(Key key: String, with cacheInfo: DictionaryType)
    {
        var cacheGlobal = UserDefaults.getDictionary(key: self.uniqueName) as? [String: DictionaryType]
        if cacheGlobal != nil {
            cacheGlobal?[key] = cacheInfo
        } else {
            cacheGlobal = [key: cacheInfo]
        }
        UserDefaults.setObject(key: self.uniqueName, value: cacheGlobal)
    }
    
    private func expired(Key key: String) -> Bool
    {
        guard let lastAccessData = self.getLastUpdateCacheWith(Key: key),
            let timeInterval = lastAccessData["timeInterval"] as? TimeInterval,
            let lastUpdate = lastAccessData["lastUpdate"] as? Date else {
                return true
        }
        
        let expiredDate: Date? = (timeInterval <= 0) ? nil : Date(timeIntervalSinceNow: -timeInterval)
        // If this file is expired
        if let expiredDate = expiredDate,
            (lastUpdate as NSDate).laterDate(expiredDate) == expiredDate
        {
            // -- this key is expired --
            return true
        }
        
        return false
    }
    
}
