//
//  RkMonitorConstants.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

class RkAppConstants: NSObject {
    
    // MARK: Server Information
    
    static let baseUrl: String = "http://location-tracker-XXXX.mybluemix.net"
    
    // MARK: App Settings
    
    // -- Location monitor settings --
    static let minMetersLocationAccuracy : Double = 100 //25 max
    static let minMetersLocationAccuracyBackground : Double = 20 // 100
    
    static let minMetersBetweenLocations : Double = 5.0 //15
    static let minMetersBetweenLocationsBackground : Double = 5 // 100
    
    static let minSecondsBetweenLocations : Double = 0.8 //15
    
    // -- Map settings --
    static let locationDisplayCount = 100
    static let initialMapZoomRadiusMiles : Double = 1.5 //2.5
    static let offlineMapRadiusMiles: Double = 5
    static let placeRadiusMeters: Double = (2.5 * RkAppConstants.metersPerMile)
    
    static let metersPerMile = 1609.34
    
    // MARK: Map Providers
    
    static let mapProviders = ["MapKit"]
    static let mapProviderDefaultStyleIds: [String:String] = ["MapKit":AppleMapDelegate.mapDefaultStyleId]
}
