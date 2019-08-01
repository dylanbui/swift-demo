//
//  DbLocationManager.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation

let DB_DEFAULT_FENCE_RADIOUS = 100.0
let kDbHorizontalAccuracyThresholdCity = CLLocationAccuracy(5000.0)         // in meters
let kDbHorizontalAccuracyThresholdNeighborhood = CLLocationAccuracy(1000.0) // in meters
let kDbHorizontalAccuracyThresholdBlock = CLLocationAccuracy(100.0) // in meters
let kDbHorizontalAccuracyThresholdHouse = CLLocationAccuracy(15.0) // in meters
let kDbHorizontalAccuracyThresholdRoom = CLLocationAccuracy(5.0) // in meters

public enum DbFenceEventType : String {
    case added      = "DbFenceEventAdded"
    case removed    = "DbFenceEventRemoved"
    case failed     = "DbFenceEventFailed"
    case repeated   = "DbFenceEventRepeated"
    case enterFence = "DbFenceEventEnterFence"
    case exitFence  = "DbFenceEventExitFence"
    case none       = "DbFenceEventNone"
}

public enum DbLocationTaskType : Int {
    case getCurrentLocation
    case getContiniousLocation
    case getSignificantChangeLocation
    case addFenceToCurrentLocation
    case getGeoCodeAddress
    case none
}

public struct DbFencemark
{
    var eventType: DbFenceEventType = .none
    var eventTimeStamp: String = ""
    var fenceIDentifier: String = ""
    var fenceCentralCoordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    var fenceRadious: CLLocationDistance = 0.0
    
    //uses DB_LATITUDE,  DB_LONGITUDE, DB_RADIOUS to wrap data for debug
    var dictionary: DictionaryType {
        get {
            return [
                "eventType"             : self.eventType,
                "eventTimeStamp"        : self.eventTimeStamp,
                "fenceIDentifier"       : self.fenceIDentifier,
                "fenceCentralCoordinate": self.fenceCentralCoordinate,
                "fenceRadious"          : self.fenceRadious
            ]
        }
    }
}

public struct DbPlacemark
{
    var name: String {
        get {
            return self.clPlacemark.name ?? ""
        }
    }
    var street: String {
        get {
            return self.clPlacemark.thoroughfare ?? ""
        }
    }
    var city: String {
        get {
            return self.clPlacemark.locality ?? ""
        }
    }
    var state: String {
        get {
            return self.clPlacemark.administrativeArea ?? ""
        }
    }
    var county: String {
        get {
            return self.clPlacemark.country ?? self.clPlacemark.subAdministrativeArea ?? "" // Quan
        }
    }
    var zipcode: String {
        get {
            return self.clPlacemark.postalCode ?? ""
        }
    }
    var addressFullData: DictionaryType {
        get {
            return self.clPlacemark.addressDictionary as? DictionaryType ?? [:]
        }
    }
    
    let location: CLLocation
    let clPlacemark: CLPlacemark
    
    init(location: CLLocation, placemark: CLPlacemark)
    {
        self.location = location
        self.clPlacemark = placemark
    }
}

public typealias LocationUpdateBlock = (CLLocation?, Error?) -> Void
public typealias GeoCodeUpdateBlock = (DbPlacemark?, Error?) -> Void

public protocol DbLocationManagerDelegate {    
    /**
     *   Raw get locations
     */
    func dbLocationManager(DidUpdateListLocations locations: [CLLocation])
    /**
     *   Gives an Location Dictionary using keys "latitude", "longitude" and "altitude". You can use these macros: DB_LATITUDE, DB_LONGITUDE and DB_ALTITUDE.
     *   Sample output dictionary @{ @"latitude" : 23.6850, "longitude" : 90.3563, "altitude" : 10.4604}
     */
    func dbLocationManager(DidUpdateBestLocation location: CLLocation)
    /**
     *   Fail get location
     */
    func dbLocationManager(DidFailLocation withError: CLError)
    /**
     *   Gives an DbFenceInfo Object of the Fence which just added
     */
    func dbLocationManager(DidAddFence fencemark: DbFencemark?)
    /**
     *   Gives an DbFenceInfo Object of the Fence which just failed to monitor
     */
    func dbLocationManager(DidFailedFence fencemark: DbFencemark?)
    /**
     *   Gives an DbFenceInfo Object of a Fence just entered
     */
    func dbLocationManager(DidEnterFence fencemark: DbFencemark?)
    /**
     *   Gives an DbFenceInfo Object of a Exited Fence
     */
    func dbLocationManager(DidExitFence fencemark: DbFencemark?)
    /**
     *   Gives an Dictionary using current geocode or adress information with DB_ADDRESS_* keys
     */
    func dbLocationManager(DidUpdateGeocodeAdress placemark: DbPlacemark?)
}

// -- Optional --
extension DbLocationManagerDelegate {
    func dbLocationManager(DidUpdateListLocations locations: [CLLocation]) {}
    func dbLocationManager(DidFailLocation withError: CLError) {}
    func dbLocationManager(DidAddFence fencemark: DbFencemark?) {}
    func dbLocationManager(DidFailedFence fencemark: DbFencemark?) {}
    func dbLocationManager(DidEnterFence fencemark: DbFencemark?) {}
    func dbLocationManager(DidExitFence fencemark: DbFencemark?) {}
    func dbLocationManager(DidUpdateGeocodeAdress placemark: DbPlacemark?) {}
}
