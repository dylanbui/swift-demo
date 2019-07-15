//
//  PropertySearchParams.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation

enum PropertySearchReturnType
{
    case groupDistrict
    case groupWard
    case listing
}

class PropertySearchParam: NSObject // , CustomStringConvertible
{
    // Extension CustomStringConvertible
    // Debug : print("param = \(String(describing: ListingSearchParam()))")
    
    // var searchResult: (forMap: [GMSMarker], forList: [ListingUnit], totalListItems: Int) = ([], [], 0)
    
    var postData: DictionaryType = [
        "filter": [
            "listingId": NSNull(),
            "listingTypeList": "1", // "1,2"
            "propertyList": "11",
            "directionList": "1,2,3,4,5,6,7,8",
            "minSize": NSNull(),
            "maxSize": NSNull(),
            "minPrice": NSNull(),
            "maxPrice": NSNull(),
            "minBedroom": NSNull(),
            "maxBedroom": NSNull(),
            "minBathroom": NSNull(),
            "maxBathroom": NSNull(),
            "numberFloor": NSNull(),
            "position": NSNull(),
            "minAlley": NSNull(),
            "maxAlley": NSNull(),
            "minYearBuilt": NSNull(),
            "maxYearBuilt": NSNull(),
            "latitude": NSNull(),
            "longitude": NSNull(),
            "statusListing": 0,
            "cityIds": 1,
            "districtIds": NSNull(),
            "wardIds": NSNull(),
            "locations": NSNull(),
            "forMap": true,
            "guaranteed":NSNull(),
            "projectId": NSNull()
        ],
        
        "additional": [
            "paging" : [
                "limit": 10000,
                "page": 1
            ],
            "ordering" : [
                "name": NSNull(),
                "operator": NSNull(),
                "orderType": 1
            ]
        ]
    ]
    
    var returnType: PropertySearchReturnType = .groupDistrict
    
    var listingId: Int? {
        get {
            return self.getParamValue("filter.listingId") as Int?
        }
        set {
            self.setParamValue("filter.listingId", newValue: newValue)
        }
    }
    
    var projectId: Int? {
        get {
            return self.getParamValue("filter.projectId") as Int?
        }
        set {
            self.setParamValue("filter.projectId", newValue: newValue)
        }
    }
    
    var listingTypeList: [Int] {
        get {
            return self.getIntArray("filter.listingTypeList")
        }
        set {
            self.setIntArray("filter.listingTypeList", intArray: newValue)
        }
        
    }
    
    var propertyTypeList: [Int] {
        get {
            return self.getIntArray("filter.propertyList")
        }
        set {
            self.setIntArray("filter.propertyList", intArray: newValue)
        }
    }
    
    var directionList: [Int] {
        get {
            return self.getIntArray("filter.directionList")
        }
        set {
            self.setIntArray("filter.directionList", intArray: newValue)
        }
    }
    
    var minSize: Float? {
        get {
            return self.getParamValue("filter.minSize") as Float?
        }
        set {
            self.setParamValue("filter.minSize", newValue: newValue)
        }
    }
    
    var maxSize: Float? {
        get {
            return self.getParamValue("filter.maxSize") as Float?
        }
        set {
            self.setParamValue("filter.maxSize", newValue: newValue)
        }
    }
    
    var minPrice: Double? {
        get {
            return self.getParamValue("filter.minPrice") as Double?
        }
        set {
            self.setParamValue("filter.minPrice", newValue: newValue)
        }
    }
    
    var maxPrice: Double? {
        get {
            return self.getParamValue("filter.maxPrice") as Double?
        }
        set {
            self.setParamValue("filter.maxPrice", newValue: newValue)
        }
    }
    
    var bedroom: Int? {
        get {
            return self.getParamValue("filter.minBedroom") as Int?
        }
        set {
            self.setParamValue("filter.minBedroom", newValue: newValue)
            self.setParamValue("filter.maxBedroom", newValue: newValue)
        }
    }
    
    var bathroom: Int? {
        get {
            return self.getParamValue("filter.minBathroom") as Int?
        }
        set {
            self.setParamValue("filter.minBathroom", newValue: newValue)
            self.setParamValue("filter.maxBathroom", newValue: newValue)
        }
    }
    
    var numberFloor: Int? {
        get {
            return self.getParamValue("filter.numberFloor") as Int?
        }
        set {
            self.setParamValue("filter.numberFloor", newValue: newValue)
        }
    }
    
    var guaranteed: Int? {
        get {
            return self.getParamValue("filter.guaranteed") as Int?
        }
        set {
            self.setParamValue("filter.guaranteed", newValue: newValue)
        }
    }
    
    var statusListing: Int? {
        get {
            return self.getParamValue("filter.statusListing") as Int?
        }
        set {
            self.setParamValue("filter.statusListing", newValue: newValue)
        }
    }
    
    var position: Int? {
        get {
            return self.getParamValue("filter.position") as Int?
        }
        set {
            self.setParamValue("filter.position", newValue: newValue)
        }
    }
    
    var minAlley: Float? {
        get {
            return self.getParamValue("filter.minAlley") as Float?
        }
        set {
            self.setParamValue("filter.minAlley", newValue: newValue)
        }
    }
    
    var maxAlley: Float? {
        get {
            return self.getParamValue("filter.maxAlley") as  Float?
        }
        set {
            self.setParamValue("filter.maxAlley", newValue: newValue)
        }
    }
    
    var latitude: Double? {
        get {
            return self.getParamValue("filter.latitude") as Double?
        }
        set {
            self.setParamValue("filter.latitude", newValue: newValue)
        }
    }
    
    var longitude: Double? {
        get {
            return self.getParamValue("filter.longitude") as Double?
        }
        set {
            self.setParamValue("filter.longitude", newValue: newValue)
        }
    }
    
    var location: CLLocationCoordinate2D? {
        get {
            return CLLocationCoordinate2D.init(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0)
        }
        set {
            if let val = newValue {
                self.returnType = .listing
                self.latitude = val.latitude
                self.longitude = val.longitude
            } else {
                self.latitude = nil
                self.longitude = nil
            }
            //            self.setParamValue("filter.latitude", newValue: location.latitude)
            //            self.setParamValue("filter.longitude", newValue: location.longitude)
        }
    }
    
    // -- City, District, Ward --
    
    var cityId: Int? {
        get {
            return self.getParamValue("filter.cityIds") as Int?
        }
        set {
            self.returnType = .groupDistrict
            self.setParamValue("filter.cityIds", newValue: newValue)
        }
    }
    
    var districtId: Int? {
        get {
            return self.getParamValue("filter.districtIds") as Int?
        }
        set {
            self.returnType = (newValue == nil ? .groupDistrict : .groupWard)
            self.setParamValue("filter.districtIds", newValue: newValue)
        }
    }
    
    var wardId: Int? {
        get {
            return self.getParamValue("filter.wardIds") as Int?
        }
        set {
            self.returnType = (newValue == nil ? .groupWard : .listing)
            self.setParamValue("filter.wardIds", newValue: newValue)
        }
    }
    
    var locationBounds: [CLLocationCoordinate2D]? {
        get {
            if let locations: [[CLLocationDegrees]] = self.getParamValue("filter.locations") {
                var arr: [CLLocationCoordinate2D] = []
                for location in locations {
                    let coord = CLLocationCoordinate2DMake(location[0], location[1])
                    arr.append(coord)
                }
                return arr
            }
            return nil
        }
        set {
            guard let locations = newValue else {
                // Neu newValue == nil
                self.setParamValue("filter.locations", newValue: newValue)
                return
            }
            var arr: [[CLLocationDegrees]] = []
            for coord in locations {
                let item = [coord.latitude, coord.longitude]
                arr.append(item)
            }
            self.setParamValue("filter.locations", newValue: arr)
            self.returnType = .listing
        }
    }
    
    var forMap: Bool {
        get {
            return self.getParamValue("filter.forMap") as Bool? ?? true
        }
        set {
            self.setParamValue("filter.forMap", newValue: newValue)
        }
    }
    
    var pagingAtPage: Int {
        get {
            return self.getParamValue("additional.paging.page") as Int? ?? 1
        }
        set {
            self.setParamValue("additional.paging.page", newValue: newValue)
        }
    }
    
    var pagingWithLimit: Int {
        get {
            return self.getParamValue("additional.paging.limit") as Int? ?? 10000
        }
        set {
            self.setParamValue("additional.paging.limit", newValue: newValue)
        }
    }
    
    var orderType: Int {
        get {
            return self.getParamValue("additional.ordering.orderType") as Int? ?? 1
        }
        set {
            self.setParamValue("additional.ordering.orderType", newValue: newValue)
        }
    }
    
    override init() {
        
    }
    
//    convenience init(withCopy: PropertySearchParam)
//    {
//        self.init()
//        let serializedUser = Mapper().toJSON(withCopy)
//        self.mapping(map: Map(mappingType: .fromJSON, JSON: serializedUser))
//    }
//
//    convenience init(withCopy: PropertySearchParam, locationBounds: Array<CLLocationCoordinate2D>)
//    {
//        self.init()
//        let serializedUser = Mapper().toJSON(withCopy)
//        self.mapping(map: Map(mappingType: .fromJSON, JSON: serializedUser))
//        self.locationBounds = locationBounds
//    }
    
    public func resetParameterToGroupDistrict() -> Void
    {
        self.districtId = nil
        self.wardId = nil
    }
    
    public func resetParameterToGroupWard() -> Void
    {
        self.wardId = nil
    }
    
    private func getIntArray(_ keyPath: String) -> [Int]
    {
        let str = self.postData[db_keyPath: keyPath] as! String
        return str.components(separatedBy: ",").compactMap { Int($0) }
    }
    
    private func setIntArray(_ keyPath: String, intArray: [Int]) -> Void
    {
        let str = intArray.compactMap { String($0) }.joined(separator: ",")
        self.postData[db_keyPath: keyPath] = str
    }
    
    private func getParamValue<T>(_ keyPath: String) -> T?
    {
        if self.postData[db_keyPath: keyPath] as? NSNull == NSNull() {
            return nil
        }
        return self.postData[db_keyPath: keyPath] as? T
    }
    
    private func setParamValue<T>(_ keyPath: String, newValue: T?) -> Void
    {
        if let value = newValue {
            self.postData[db_keyPath: keyPath] = value
        } else {
            self.postData[db_keyPath: keyPath] = NSNull()
        }
    }
    
    
    
}
