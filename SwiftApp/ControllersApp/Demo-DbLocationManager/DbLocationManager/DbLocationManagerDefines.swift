//
//  DbLocationManager.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation

public typealias DbLocationInfo = [String: Any]

let kDbHorizontalAccuracyThresholdCity = CLLocationAccuracy(5000.0)         // in meters
let kDbHorizontalAccuracyThresholdNeighborhood = CLLocationAccuracy(1000.0) // in meters
let kDbHorizontalAccuracyThresholdBlock = CLLocationAccuracy(100.0) // in meters
let kDbHorizontalAccuracyThresholdHouse = CLLocationAccuracy(15.0) // in meters
let kDbHorizontalAccuracyThresholdRoom = CLLocationAccuracy(5.0) // in meters

let DB_FENCE_EVENT_TYPE_KEY = "DBeventType"
let DB_FENCE_EVENT_TIMESTAMP_KEY = "DBeventTimeStamp"
let DB_FENCE_IDENTIFIER_KEY = "DBfenceIDentifier"
let DB_FENCE_COORDINATE_KEY = "DBfenceCoordinate"

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

public class DbFenceInfo: NSObject {
    var eventType = ""
    var eventTimeStamp = ""
    var fenceIDentifier = ""
    var fenceCoordinate: DbLocationInfo = [:]
    
    //uses DB_LATITUDE,  DB_LONGITUDE, DB_RADIOUS to wrap data
    var dictionary: DbLocationInfo {
        get {
            return [
                DB_FENCE_EVENT_TYPE_KEY         : self.eventType,
                DB_FENCE_EVENT_TIMESTAMP_KEY    : self.eventTimeStamp,
                DB_FENCE_IDENTIFIER_KEY         : self.fenceIDentifier,
                DB_FENCE_COORDINATE_KEY         : self.fenceCoordinate
            ]
        }
    }
}

let DB_DEFAULT_FENCE_RADIOUS = 100.0
let DB_LOCATION = "location"
let DB_LATITUDE = "latitude"
let DB_LONGITUDE = "longitude"
let DB_ALTITUDE = "altitude"
let DB_RADIOUS = "radious"

let DB_ADDRESS_NAME = "address_name"
let DB_ADDRESS_STREET = "address_street"
let DB_ADDRESS_CITY = "address_city"
let DB_ADDRESS_STATE = "address_state"
let DB_ADDRESS_COUNTY = "address_county"
let DB_ADDRESS_ZIPCODE = "address_zipcode"
let DB_ADDRESS_COUNTRY = "address_country"
let DB_ADDRESS_DICTIONARY = "address_full_dictionary"

public typealias LocationUpdateBlock = (Bool, DbLocationInfo, Error?) -> Void
public typealias GeoCodeUpdateBlock = (Bool, DbLocationInfo, Error?) -> Void

public protocol DbLocationManagerDelegate {
    /**
     *   Gives an Location Dictionary using keys "latitude", "longitude" and "altitude". You can use these macros: DB_LATITUDE, DB_LONGITUDE and DB_ALTITUDE.
     *   Sample output dictionary @{ @"latitude" : 23.6850, "longitude" : 90.3563, "altitude" : 10.4604}
     */
    func dbLocationManagerDidUpdateLocation(_ latLongAltitudeDictionary: DbLocationInfo)

    /**
     *   Fail get location
     */
    func dbLocationManagerDidFailLocation(_ withError: CLError)
    
    /**
     *   Gives an DbFenceInfo Object of the Fence which just added
     */
    func dbLocationManagerDidAddFence(_ fenceInfo: DbFenceInfo?)
    /**
     *   Gives an DbFenceInfo Object of the Fence which just failed to monitor
     */
    func dbLocationManagerDidFailedFence(_ fenceInfo: DbFenceInfo?)
    /**
     *   Gives an DbFenceInfo Object of a Fence just entered
     */
    func dbLocationManagerDidEnterFence(_ fenceInfo: DbFenceInfo?)
    /**
     *   Gives an DbFenceInfo Object of a Exited Fence
     */
    func dbLocationManagerDidExitFence(_ fenceInfo: DbFenceInfo?)
    /**
     *   Gives an Dictionary using current geocode or adress information with DB_ADDRESS_* keys
     */
    func dbLocationManagerDidUpdateGeocodeAdress(_ addressDictionary: DbLocationInfo?)
}

// -- Optional --
extension DbLocationManagerDelegate {
    func dbLocationManagerDidFailLocation(_ withError: CLError) {}
    func dbLocationManagerDidAddFence(_ fenceInfo: DbFenceInfo?) {}
    func dbLocationManagerDidFailedFence(_ fenceInfo: DbFenceInfo?) {}
    func dbLocationManagerDidEnterFence(_ fenceInfo: DbFenceInfo?) {}
    func dbLocationManagerDidExitFence(_ fenceInfo: DbFenceInfo?) {}
    func dbLocationManagerDidUpdateGeocodeAdress(_ addressDictionary: DbLocationInfo?) {}
}
