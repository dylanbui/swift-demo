//
//  DbLocationManager.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation

private let DB_TIMESTAMP_DDMMYYYYHHMMSS = "dd-MM-YYYY HH:mm:ss"

class DbLocationManager : NSObject
{
    var delegate: DbLocationManagerDelegate?
    
    var lastKnownGeocodeAddress: DbLocationInfo?
    var lastKnownGeoLocation: DbLocationInfo?
    
    var desiredAcuracy: Double = 0.0 {
        didSet {
            if self.desiredAcuracy < 50.0 {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            } else if desiredAcuracy >= 50.0 && self.desiredAcuracy < 100.0 {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            } else if desiredAcuracy >= 100.0 && self.desiredAcuracy < 500.0 {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            } else if desiredAcuracy >= 500.0 && self.desiredAcuracy <= 1000.0 {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            } else {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            }
        }
    }
    
    var distanceFilter: CLLocationDistance = 0.0 {
        didSet {
            self.locationManager.distanceFilter = self.distanceFilter
        }
    }
    
    
    private var didStartMonitoringRegion = false
    private var radiousParam: CLLocationDistance = 0
    private var identifierParam: String? = ""
    
    private lazy var locationManager = CLLocationManager()
    private lazy var geocoder: CLGeocoder = CLGeocoder()
    private var geofences: [CLRegion] = []
    private var locationCompletionBlock: LocationUpdateBlock?
    private var geocodeCompletionBlock: GeoCodeUpdateBlock?
    private var activeLocationTaskType: LocationTaskType = .none

    
    class var sharedInstance : DbLocationManager
    {
        struct Static {
            static let instance : DbLocationManager = DbLocationManager()
        }
        
        //setting the default distance filter
        Static.instance.distanceFilter = 100.0 //setting it default to 100 meters
        //initially lets guess its 15 meters
        Static.instance.desiredAcuracy = kDbHorizontalAccuracyThresholdHouse
        
        return Static.instance
    }
    
    fileprivate override init()
    {
        super.init()
        
        // Configure Location Manager
        self.locationManager.delegate = self
        
        self.activeLocationTaskType = .none
        // self.lastKnownGeocodeAddress = @{};
        // self.lastKnownGeoLocation = @;
        
        self.geofences = Array(self.locationManager.monitoredRegions)
        
        self.didStartMonitoringRegion = false
        self.radiousParam = 0
        self.identifierParam = ""
    }
    
    static func locationPermission() -> Bool
    {
        var isPermitted = true
        
        if !CLLocationManager.locationServicesEnabled() {
            //You need to enable Location Services
            return false
        }
        if !CLLocationManager.isMonitoringAvailable(for: CLRegion.self) {
            //Region monitoring is not available for this Class;
        }
        
        let locationPermission: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if (locationPermission == .restricted) || (locationPermission == .denied) {
            isPermitted = false
        }
        
        if isPermitted && locationPermission == .notDetermined {
            isPermitted = Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil || Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil || Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysAndWhenInUseUsageDescription") != nil
        }
        
        return isPermitted
    }
    
    func getPermissionForStartUpdatingLocation() -> Bool
    {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        // -- Dung doan ma nay thay the cho thang thong bao mac dinh location --
        if status == .denied || status == .restricted {
            if let usageDescription = Bundle.main.object(forInfoDictionaryKey: "NSLocationUsageDescription") as? String {
                let title: String = (status == .denied) ?
                    self.localizedText("Location services are off") :
                    self.localizedText("Location Service is not enabled")
                let message: String = (status == .denied) ?
                    usageDescription :
                    self.localizedText("To use location you must turn on 'While Using the App' in the Location Services Settings")
                
                // -- Fix alert view for ios >= 9.0 --
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: localizedText("Cancel"), style: .default, handler: { action in
                })
                
                let btnSettings = UIAlertAction(title: localizedText("Settings"), style: .default, handler: { action in
                    let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
                    let application = UIApplication.shared
                    if let settingsURL = settingsURL {
                        application.openURL(settingsURL)
                    }
                })
                
                alert.addAction(btnCancel)
                alert.addAction(btnSettings)
                alert.preferredAction = btnSettings // Bold title btnSettings
                
                // Show in rootViewController
                let topViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
                topViewController?.present(alert, animated: true)
            } else {
                assert(false, "To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationUsageDescription.")
            }
        }
        
        // As of iOS 8, apps must explicitly request location services permissions. INTULocationManager supports both levels, "Always" and "When In Use".
        // INTULocationManager determines which level of permissions to request based on which description key is present in your app's Info.plist
        // If you provide values for both description keys, the more permissive "Always" level is requested.
        if status == .notDetermined {
            let hasAlwaysKey: Bool = Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil
            let hasWhenInUseKey: Bool = Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil
            if hasAlwaysKey {
                self.locationManager.requestAlwaysAuthorization()
            } else if hasWhenInUseKey {
                self.locationManager.requestWhenInUseAuthorization()
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
                assert(hasAlwaysKey || hasWhenInUseKey, "To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.")
            }
        }
        
        return status == .denied
    }
    
    func getLocationInfo() -> DbLocationInfo?
    {
        guard let location = self.locationManager.location else {
            return nil
        }
        
        let locationDict: DbLocationInfo = [
            DB_LOCATION: location,
            DB_LATITUDE: location.coordinate.latitude,
            DB_LONGITUDE: location.coordinate.longitude,
            DB_ALTITUDE: location.altitude
        ]
        return locationDict
    }
    
    func getCurrentFences() -> [DbFenceInfo]?
    {
        let existingArray = Array(self.locationManager.monitoredRegions)
        
        var existingFenceInfoArray: [DbFenceInfo] = []
        for currentRegion: CLCircularRegion in existingArray as? [CLCircularRegion] ?? [] {
            existingFenceInfoArray.append(fenceInfo(for: currentRegion, fenceEventType: .none))
        }
        
        if existingFenceInfoArray.count == 0 {
            return nil
        }
        
        return existingFenceInfoArray
    }
    
    func deleteCurrentFences()
    {
        let existingArray = Array(locationManager.monitoredRegions)
        
        for currentRegion: CLCircularRegion in existingArray as? [CLCircularRegion] ?? [] {
            //we only want to delete all the fences those we created
            let startRange: NSRange = (currentRegion.identifier as NSString).range(of: "BB: ")
            if Int(startRange.location) != NSNotFound {
                // Stop Monitoring Region
                self.locationManager.stopMonitoring(for: currentRegion)
                
                // Update list
                self.geofences.removeAll(where: { element in element == currentRegion })
            }
        }
    }
    
    func requestLocation(_ completionHandler: @escaping (_ currentLocation: CLLocation) -> Void)
    {
        getCurrentLocation(withCompletion: { success, locationDictionary, error in
            // -- Phai luon luon kiem tra lat, long != 0 de tranh bay ra bien --
            // CLLocationCoordinate2D infiniteLoopCoordinate = CLLocationCoordinate2DMake([locationDictionary[DB_LATITUDE] floatValue], [locationDictionary[DB_LONGITUDE] floatValue]);
            if success {
                completionHandler(locationDictionary[DB_LOCATION] as! CLLocation)
            }
        })
    }
    
    func getCurrentLocation(withDelegate delegate: DbLocationManagerDelegate)
    {
        self.delegate = delegate
        self.activeLocationTaskType = .getCurrentLocation
        //dont get confused between [self startUpdatingLocation] and [self.locationManager startUpdatingLocation]...I got confused once, and paid the price :(
        self.startUpdatingLocation()
    }
    
    func getCurrentLocationSkipAuthAlert(withCompletion completion: @escaping LocationUpdateBlock)
    {
        self.locationCompletionBlock = completion
        self.activeLocationTaskType = .getCurrentLocation
        self.startUpdatingLocationSkipAuthAlert(true)
    }
    
    func getCurrentLocation(withCompletion completion: @escaping LocationUpdateBlock)
    {
        self.locationCompletionBlock = completion
        self.activeLocationTaskType = .getCurrentLocation
        self.startUpdatingLocation()
    }
    
    func getCurrentGeocodeAddress(withDelegate delegate: DbLocationManagerDelegate)
    {
        self.delegate = delegate
        self.activeLocationTaskType = .getGeoCodeAddress
        self.startUpdatingLocation()
    }
    
    func getCurrentGeoCodeAddress(withCompletion completion: @escaping GeoCodeUpdateBlock)
    {
        self.geocodeCompletionBlock = completion
        self.activeLocationTaskType = .getGeoCodeAddress
        self.startUpdatingLocation()
    }
    
    func getContiniousLocation(withDelegate delegate: DbLocationManagerDelegate)
    {
        self.delegate = delegate
        self.activeLocationTaskType = .getContiniousLocation
        self.startUpdatingLocation()
    }
    
    func getSignificantLocationChange(withDelegate delegate: DbLocationManagerDelegate)
    {
        self.delegate = delegate
        self.activeLocationTaskType = .getSignificantChangeLocation
        self.startUpdatingLocation()
    }
    
    func stopGettingLocation()
    {
        if activeLocationTaskType == .getContiniousLocation {
            self.locationManager.stopUpdatingLocation()
        } else if activeLocationTaskType == .getSignificantChangeLocation {
            self.locationManager.stopMonitoringSignificantLocationChanges()
        }
        self.activeLocationTaskType = .none
    }
    
    func addGeofenceAtCurrentLocation()
    {
        self.addGeofenceAtCurrentLocation(withRadious: DB_DEFAULT_FENCE_RADIOUS)
    }
    
    func addGeofenceAtCurrentLocation(withRadious radious: CLLocationDistance)
    {
        self.desiredAcuracy = radious
        self.addGeofenceAtCurrentLocation(withRadious: radious, withIdentifier: nil)
    }
    
    func addGeofenceAtCurrentLocation(withRadious radious: CLLocationDistance, withIdentifier identifier: String?)
    {
        //store the radious and identifier
        self.radiousParam = radious
        self.identifierParam = identifier
        
        // Update Helper
        self.didStartMonitoringRegion = false
        
        // Start Updating Location, once we get a location, we'll add a fence
        activeLocationTaskType = .addFenceToCurrentLocation
        self.startUpdatingLocation()
    }
    
    func addGeofenceAtlatitude(_ latitude: Double, andLongitude longitude: Double, withRadious radious: Double, withIdentifier identifier: String?)
    {
        self.addGeofence(atCoordinates: CLLocationCoordinate2DMake(latitude, longitude),
                         withRadious: CLLocationDistance(radious), withIdentifier: identifier)
    }
    
    func addGeofence(atCoordinates coordinate: CLLocationCoordinate2D, withRadious radious: CLLocationDistance, withIdentifier identifier: String?)
    {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.addGeofence(at: location, withRadious: radious, withIdentifier: identifier)
    }
    
    func addGeofence(at location: CLLocation, withRadious radious: CLLocationDistance, withIdentifier identifier: String?)
    {
        //------------------first check if we already have these coordinates inside existing regions----------
        if let currentRegion: CLCircularRegion = self.isFenceExists(forCoordinates: location.coordinate) {
            print("[DbLocationManager] Fence already exist for area: \(identifier ?? "") ---- inside: \(currentRegion.identifier)")
            self.delegate?.dbLocationManagerDidAddFence(self.fenceInfo(for: currentRegion, fenceEventType: .repeated))
            return

        }
        //------------------if this coordinates doesnot already added to a geofence, start the fence---------------------
        
        //if there is a identifier provided, don't try to geocode the location
        if let strIden = identifier, strIden.isEmpty == false {
            self.startMonitoringRegion(withCeter: location.coordinate, radious: radious, identifier: strIden)
        }
        
        else {
            
            let loc: CLLocationCoordinate2D = location.coordinate
            let rad: Double = radious
            
            self.geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                
                // read the most confident one
                guard let mark = placemarks?.first else {
                    self.startMonitoringRegion(withCeter: loc, radious: rad, identifier: String(format: "%lf_%lf_%lf", loc.latitude, loc.longitude, rad))
                    return
                }
                
                // got a adddress
                let name = mark.name ?? "$"
                let thoroughfare = mark.thoroughfare ?? "$"
                let subLocality = mark.subLocality ?? "$"
                let locality = mark.locality ?? "$"
                let subAdministrativeArea = mark.subAdministrativeArea ?? "$"
                let administrativeArea = mark.administrativeArea ?? "$"
                let postalcode = mark.postalCode ?? "$"
                let ISOcountryCode = mark.isoCountryCode ?? "$"
                
                var address = "\(name),\(thoroughfare),\(subLocality),\(locality),\(subAdministrativeArea),\(administrativeArea),\(postalcode),\(ISOcountryCode)"
                address = address.replacingOccurrences(of: "$,", with: "")
                
                self.startMonitoringRegion(withCeter: loc, radious: rad,
                                           identifier: address != "$" ? address : String(format: "%lf_%lf_%lf", loc.latitude, loc.longitude, rad))
            })
        }
    }
    
    func getGeoCode(at location: CLLocation)
    {
        self.geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            self.lastKnownGeocodeAddress = [
                DB_LOCATION: NSNull(),
                DB_LATITUDE: 0.0,
                DB_LONGITUDE: 0.0,
                DB_ALTITUDE: 0.0,
                DB_ADDRESS_NAME: "Unknown",
                DB_ADDRESS_STREET: "Unknown",
                DB_ADDRESS_CITY: "Unknown",
                DB_ADDRESS_STATE: "Unknown",
                DB_ADDRESS_ZIPCODE: "Unknown",
                DB_ADDRESS_COUNTY: "Unknown",
                DB_ADDRESS_DICTIONARY: [:]
            ]
            
            // read the most confident one
            if let mark = placemarks?.first {
                let name = mark.name ?? ""
                let thoroughfare = mark.thoroughfare ?? ""
                let locality = mark.locality ?? ""
                let administrativeArea = mark.administrativeArea ?? "0"
                let postalcode = mark.postalCode ?? ""
                let country = mark.country ?? mark.subAdministrativeArea ?? ""
                //NSLog(@"Updated Address:%@", mark.addressDictionary.description);
                self.lastKnownGeocodeAddress = [
                    DB_LOCATION: location,
                    DB_LATITUDE: location.coordinate.latitude,
                    DB_LONGITUDE: location.coordinate.longitude,
                    DB_ALTITUDE: location.altitude,
                    DB_ADDRESS_NAME: name,
                    DB_ADDRESS_STREET: thoroughfare,
                    DB_ADDRESS_CITY: locality,
                    DB_ADDRESS_STATE: administrativeArea ,
                    DB_ADDRESS_ZIPCODE: postalcode,
                    DB_ADDRESS_COUNTY: country,
                    DB_ADDRESS_DICTIONARY: mark.addressDictionary ?? [:]
                ]
            }
            
            //send through delegate
            // -- Call delegate --
            self.delegate?.dbLocationManagerDidUpdateGeocodeAdress(self.lastKnownGeocodeAddress)
            // -- Call closure --
            self.geocodeCompletionBlock?(error != nil ? false : true, self.lastKnownGeocodeAddress!, error)
        })
    }
    
    func addGeoFence(using fenceInfo: DbFenceInfo)
    {
        let coordinate: CLLocationCoordinate2D = self.locationCoordinate2d(from: fenceInfo)
        self.addGeofence(atCoordinates: coordinate,
                         withRadious: fenceInfo.fenceCoordinate[DB_RADIOUS] as? Double ?? 0.0,
                         withIdentifier: fenceInfo.fenceIDentifier)
    }
    
    func deleteGeoFence(withIdentifier identifier: String)
    {
        let existingArray = Array(locationManager.monitoredRegions)
        for currentRegion: CLCircularRegion in existingArray as? [CLCircularRegion] ?? [] {
            let startRange: NSRange = (currentRegion.identifier as NSString).range(of: identifier)
            if Int(startRange.location) != NSNotFound {
                // Stop Monitoring Region
                self.locationManager.stopMonitoring(for: currentRegion)
                // Update list
                self.geofences.removeAll(where: { element in element == currentRegion })
            }
        }
    }
    
    func deleteGeoFence(_ fenceInfo: DbFenceInfo)
    {
        self.deleteGeoFence(withIdentifier: "BB: \(fenceInfo.fenceIDentifier)")
    }
    
    // MARK: - Private function
    // MARK: -
    
    private func startUpdatingLocation()
    {
        self.startUpdatingLocationSkipAuthAlert(false)
    }
    
    private func startUpdatingLocationSkipAuthAlert(_ skipAlert: Bool)
    {
        // -- Chuyen dung cho chay ngam --
        if !skipAlert {
            if self.getPermissionForStartUpdatingLocation() {
                return // Dont allow access location
            }
        }
        
        if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil || Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysAndWhenInUseUsageDescription") != nil {
            if Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") != nil {
                var hasLocationBackgroundMode = false
                if let bgmodesArray = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] {
                    for str: String in bgmodesArray {
                        if (str == "location") {
                            hasLocationBackgroundMode = true
                            break
                        }
                    }
                }
                if !hasLocationBackgroundMode {
                    NSException(name: NSExceptionName("[DbLocationManager] UIBackgroundModes not enabled"), reason: "Your apps info.plist does not contain 'UIBackgroundModes' key with a 'location' string in it, which is required for background location access 'NSLocationAlwaysAndWhenInUseUsageDescription' for iOS 11 or 'NSLocationAlwaysUsageDescription' for iOS 10", userInfo: nil).raise()
                } else {
                    self.locationManager.allowsBackgroundLocationUpdates = true
                }
            } else {
                NSException(name: NSExceptionName("[DbLocationManager] UIBackgroundModes not enabled"), reason: "Your apps info.plist does not contain 'UIBackgroundModes' key with a 'location' string in it, which is required for background location access 'NSLocationAlwaysAndWhenInUseUsageDescription' for iOS 11 or 'NSLocationAlwaysUsageDescription' for iOS 10", userInfo: nil).raise()
            }
        }
        
        if self.activeLocationTaskType == .getSignificantChangeLocation {
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
        } else {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func startMonitoringRegion(withCeter center: CLLocationCoordinate2D, radious: CLLocationDistance, identifier: String?)
    {
        // var region: CLRegion?
        let region: CLRegion = CLCircularRegion(center: center, radius: radious, identifier: "BB: \(identifier ?? "")")
        
        // Start Monitoring Region
        self.locationManager.startMonitoring(for: region)
        
        //update array
        self.geofences.append(region)
    }
    
    private func fenceInfo(for fenceRegion: CLRegion, fenceEventType type: DbFenceEventType) -> DbFenceInfo
    {
        let region = fenceRegion as! CLCircularRegion
        let info = DbFenceInfo()
        info.eventTimeStamp = self.currentTimeStamp(withFormat: DB_TIMESTAMP_DDMMYYYYHHMMSS)
        info.eventType = type.strValue()
        info.fenceIDentifier = region.identifier
        info.fenceCoordinate = [
            DB_LATITUDE: region.center.latitude,
            DB_LONGITUDE: region.center.longitude,
            DB_RADIOUS: region.radius
        ]
        return info
    }
    
    private func isFenceExists(forCoordinates coordinate: CLLocationCoordinate2D) -> CLCircularRegion?
    {
        let existingArray = Array(locationManager.monitoredRegions)
        for currentRegion: CLCircularRegion in existingArray as? [CLCircularRegion] ?? [] {
            if currentRegion.contains(coordinate) {
                return currentRegion
            }
        }
        return nil
    }
    
    private func calculateDistance(inMetersBetweenCoord coord1: CLLocationCoordinate2D, coord coord2: CLLocationCoordinate2D) -> Double
    {
        let nRadius: Int = 6371 // Earth's radius in Kilometers
        let latDiff: Double = (coord2.latitude - coord1.latitude) * (.pi / 180)
        let lonDiff: Double = (coord2.longitude - coord1.longitude) * (.pi / 180)
        let lat1InRadians: Double = coord1.latitude * (.pi / 180)
        let lat2InRadians: Double = coord2.latitude * (.pi / 180)
        let nA: Double = pow(sin(latDiff / 2), 2) + cos(lat1InRadians) * cos(lat2InRadians) * pow(sin(lonDiff / 2), 2)
        let nC: Double = 2 * atan2(sqrt(nA), sqrt(1 - nA))
        let nD = Double(nRadius) * nC
        // convert to meters
        return (nD * 1000)
    }
    
    private func locationCoordinate2d(from fenceInfo: DbFenceInfo?) -> CLLocationCoordinate2D
    {
        return CLLocationCoordinate2DMake(
            fenceInfo?.fenceCoordinate[DB_LATITUDE] as? Double ?? 0.0,
            fenceInfo?.fenceCoordinate[DB_LONGITUDE] as? Double ?? 0.0)
    }

    private func currentTimeStamp(withFormat format: String) -> String
    {
        let dateFormattter = DateFormatter()
        dateFormattter.dateFormat = format
        return dateFormattter.string(from: Date())
    }
    
    private func localizedText(_ key: String?) -> String
    {
        let path = Bundle.main.path(forResource: "DbLocationManager", ofType: "bundle")
        let myBundle = Bundle(path: path ?? "")
        
        return myBundle?.localizedString(forKey: key ?? "", value: "", table: "Root") ?? ""
    }
}

extension DbLocationManager: CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // Fetch Current Location
        guard let location: CLLocation = locations.last else {
            return
        }
        
        if activeLocationTaskType == .getGeoCodeAddress {
            // Initialize Region/fence to Monitor
            self.getGeoCode(at: location)

            //stop getting/updating location data, means stop the GPS :)
            self.locationManager.stopUpdatingLocation()
            self.activeLocationTaskType = .none
        }
        
        else if activeLocationTaskType == .addFenceToCurrentLocation {
            if !self.didStartMonitoringRegion {
                // Update Helper
                self.didStartMonitoringRegion = true

                // Initialize Region/fence to Monitor
                self.addGeofence(at: location, withRadious: radiousParam, withIdentifier: identifierParam)

                //stop getting/updating location data, means stop the GPS :)
                self.locationManager.stopUpdatingLocation()
                self.activeLocationTaskType = .none
            }
        }
        
        else if activeLocationTaskType == .getCurrentLocation {
            let locationDict: DbLocationInfo = [
                DB_LOCATION: location,
                DB_LATITUDE: location.coordinate.latitude,
                DB_LONGITUDE: location.coordinate.longitude,
                DB_ALTITUDE: location.altitude
            ]
            self.lastKnownGeoLocation = locationDict
            
            self.delegate?.dbLocationManagerDidUpdateLocation(locationDict)
            
            if self.locationCompletionBlock != nil {
                self.locationCompletionBlock?(true, locationDict, nil)
            }
            
            //stop getting/updating location data, means stop the GPS
            self.locationManager.stopUpdatingLocation()
            activeLocationTaskType = .none
        }

        else if (self.activeLocationTaskType == .getContiniousLocation)
            || (self.activeLocationTaskType == .getSignificantChangeLocation) {
            let locationDict: DbLocationInfo = [
                DB_LOCATION: location,
                DB_LATITUDE: location.coordinate.latitude,
                DB_LONGITUDE: location.coordinate.longitude,
                DB_ALTITUDE: location.altitude
            ]
            self.lastKnownGeoLocation = locationDict
            
            self.delegate?.dbLocationManagerDidUpdateLocation(locationDict)
        }
        
        else {
            self.activeLocationTaskType = .none
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        guard let error = error as? CLError else {
            return
        }
        
        if error.code == CLError.Code.denied {
            let locationDict: DbLocationInfo = [
                DB_LOCATION: NSNull(),
                DB_LATITUDE: 0.0,
                DB_LONGITUDE: 0.0,
                DB_ALTITUDE: 0.0
            ]
            // -- Call delegate --
            self.delegate?.dbLocationManagerDidUpdateLocation(locationDict)
            // -- Call closure --
            self.locationCompletionBlock?(false, locationDict, error)
        }
    }
    
    // -- Chi can thay doi AuthorizationStatus thi se chay ham nay (bao gom ca Cancel) --
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        // -- DucBui didChangeAuthorizationStatus => didFailWithError --
        if status != .denied && status != .restricted {
            if activeLocationTaskType != .none {
                startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    {
        if let theRegion = region as? CLCircularRegion {
            self.delegate?.dbLocationManagerDidAddFence(self.fenceInfo(for: theRegion, fenceEventType: .added))
        }
        /*NSString *str = [NSString stringWithFormat:@"Added region %@, lat-long-radious:%@", region.identifier,[NSString stringWithFormat:@"%.1f - %.1f - %f", region.center.latitude, region.center.longitude, region.radius]];
         [[[UIAlertView alloc] initWithTitle:@"Gefence Alert" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
         //NSLog(str);*/
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error)
    {
        if let theRegion = region as? CLCircularRegion {
            self.delegate?.dbLocationManagerDidFailedFence(self.fenceInfo(for: theRegion, fenceEventType: .failed))
        }
        /*NSString *str = [NSString stringWithFormat:@"Failed region %@, lat-long-radious:%@", region.identifier,[NSString stringWithFormat:@"%.1f - %.1f - %f", region.center.latitude, region.center.longitude, region.radius]];
         [[[UIAlertView alloc] initWithTitle:@"Gefence Alert" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
         NSLog(str);*/
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        if let theRegion = region as? CLCircularRegion {
            self.delegate?.dbLocationManagerDidEnterFence(self.fenceInfo(for: theRegion, fenceEventType: .enterFence))
        }
        /*NSString *str = [NSString stringWithFormat:@"Entered region %@, lat-long-radious:%@", theRegion.identifier,[NSString stringWithFormat:@"%.1f - %.1f - %f", theRegion.center.latitude, theRegion.center.longitude, theRegion.radius]];
         [[[UIAlertView alloc] initWithTitle:@"Gefence Alert" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
         [BBUtility initiateLocalNotification:str withDate:[NSDate date] badgeCount:1 withEventType:@"Region-Enter"];
         NSLog(str);*/
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        if let theRegion = region as? CLCircularRegion {
            self.delegate?.dbLocationManagerDidExitFence(self.fenceInfo(for: theRegion, fenceEventType: .exitFence))
        }
        /*    NSString *str = [NSString stringWithFormat:@"Exit region %@, lat-long-radious:%@", theRegion.identifier,[NSString stringWithFormat:@"%.1f - %.1f - %f", theRegion.center.latitude, theRegion.center.longitude, theRegion.radius]];
         [[[UIAlertView alloc] initWithTitle:@"Gefence Alert" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
         [BBUtility initiateLocalNotification:str withDate:[NSDate date] badgeCount:1 withEventType:@"Region-exit"];
         NSLog(str);*/
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion)
    {
        if state == .inside {
            //NSLog(@"[DbLocationManager] Entered Region - %@", region.identifier);
        } else if state == .outside {
            //NSLog(@"[DbLocationManager] Exited Region - %@", region.identifier);
        } else {
            //NSLog(@"[DbLocationManager] Unknown state  Region - %@", region.identifier);
        }
        
    }
    
}
