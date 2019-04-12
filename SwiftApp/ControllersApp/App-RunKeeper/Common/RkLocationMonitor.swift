//
//  RkLocationMonitor.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Methods
public extension CLLocation {
    
    /// - Returns: Calculated bearing degrees in the range 0° ... 360°
    func bearing(to destination: CLLocation) -> Double {
        // http://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0
        
        // Formula: θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
        // Source: http://www.movable-type.co.uk/scripts/latlong.html
        let rads = atan2(
            sin(long2 - long1) * cos(lat2),
            cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
    
    func angle(to destination: CLLocation) -> Double
    {
        let deltaLongitude:Double = destination.coordinate.longitude - self.coordinate.longitude
        let deltaLatitude:Double = destination.coordinate.latitude - self.coordinate.latitude
        let angle:Double = (Double.pi * 0.5) - atan(deltaLatitude / deltaLongitude)
        
        if deltaLongitude > 0 {
            return angle
        } else if (deltaLongitude < 0) {
            return angle + Double.pi
        } else if (deltaLatitude < 0)  {
            return Double.pi
        }
        return Double.pi
    }
    
}

protocol RkLocationMonitorDelegate {
    func locationUpdated(bestLocation:CLLocation, locations: [CLLocation], inBackground: Bool)
    func locationUpdated(Heading newHeading: CLHeading)
    func locationManagerEnabled()
    func locationManagerDisabled()
}

extension RkLocationMonitorDelegate {
    func locationManagerEnabled() { }
    func locationManagerDisabled() { }
    func locationUpdated(Heading newHeading: CLHeading) { }
}


class RkLocationMonitor: NSObject, CLLocationManagerDelegate {
    
    static let instance = RkLocationMonitor()
    
    var delegates : [RkLocationMonitorDelegate] = []
    var locationManagerEnabled = false
    var locationManagerDisabledOnError = false
    var locationManagerEnabledFiredSinceDelegate = false
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var lastLocationTime: Double?
    
    func startIfGrantedByUser() {
        self.initLocationManager(silently: true)
    }
    
    func initLocationManager(silently: Bool) { // silently : tham lang
        let locationServicesAuthorized = (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
            || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways);
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled();
        if (silently && (locationServicesEnabled == false || locationServicesAuthorized == false)) {
            return;
        }
        if (locationManager == nil || locationServicesEnabled == false) {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self;
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.distanceFilter = RkAppConstants.minMetersBetweenLocations
            self.locationManager?.pausesLocationUpdatesAutomatically = false
            if (locationServicesAuthorized) {
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
                    self.locationManager?.requestWhenInUseAuthorization()
                }
                else {
                    self.locationManager?.requestAlwaysAuthorization()
                }
            }
            else {
                self.locationManager?.requestAlwaysAuthorization()
            }
            // start
            self.startMonitoringLocations()
        }
        //
        let locationManagerEnabled = (self.locationManager != nil)
            && locationServicesEnabled
            && locationServicesAuthorized
            && (self.locationManagerDisabledOnError == false);
        //
        if (locationManagerEnabled != self.locationManagerEnabled) {
            self.locationManagerEnabled = locationManagerEnabled
            if (self.locationManagerEnabled) {
                self.notifyLocationManagerEnabled()
            }
            else {
                self.notifyLocationManagerDisabled()
            }
        }
    }
    
    @discardableResult
    func addDelegate(_ delegate:RkLocationMonitorDelegate) -> (locationManagerEnabled:Bool, lastLocation:CLLocation?)
    {
        return self.addDelegate(delegate, silently:false)
    }
    
    @discardableResult
    func addDelegate(_ delegate:RkLocationMonitorDelegate, silently: Bool) -> (locationManagerEnabled:Bool, lastLocation:CLLocation?)
    {
        // if delegate alread added then return
        for d in self.delegates {
            if ((d as? NSObject) == (delegate as? NSObject)) {
                return (locationManagerEnabled:self.locationManagerEnabled, lastLocation:self.lastLocation);
            }
        }
        self.delegates.append(delegate)
        self.initLocationManager(silently: silently)
        self.locationManagerEnabledFiredSinceDelegate = false;
        if (self.locationManager != nil) {
            self.startMonitoringLocations()
        }
        return (locationManagerEnabled:self.locationManagerEnabled, lastLocation:self.lastLocation);
    }
    
    func removeDelegate(_ delegate:RkLocationMonitorDelegate)
    {
        var match: Int? = nil
        for (index,d) in self.delegates.enumerated() {
            if ((d as? NSObject) == (delegate as? NSObject)) {
                match = index
                break
            }
        }
        if (match != nil) {
            self.delegates.remove(at: match!)
        }
        if (delegates.count == 0 && self.locationManager != nil) {
            // no more delegates subscribed to location
            self.stopMonitoringLocations()
        }
    }
    
    func removeAllDelegates() {
        self.delegates.removeAll()
        self.stopMonitoringLocations()
    }
    
    func notifyUpdatedLocation(bestLocation: CLLocation, locations: [CLLocation], inBackground: Bool) {
        for delegate:RkLocationMonitorDelegate in self.delegates {
            delegate.locationUpdated(bestLocation: bestLocation, locations: locations, inBackground: inBackground)
        }
    }
    
    func notifyUpdatedHeading(newHeading: CLHeading) {
        for delegate:RkLocationMonitorDelegate in self.delegates {
            delegate.locationUpdated(Heading: newHeading)
        }
    }
    
    func notifyLocationManagerEnabled() {
        for delegate:RkLocationMonitorDelegate in self.delegates {
            delegate.locationManagerEnabled()
        }
    }
    
    func notifyLocationManagerDisabled() {
        for delegate:RkLocationMonitorDelegate in self.delegates {
            delegate.locationManagerDisabled()
        }
    }
    
    func startMonitoringLocations() {
        if (self.locationManager != nil) {
            // reset last location
            self.lastLocation = nil
            self.lastLocationTime = nil
            
            if (UIApplication.shared.applicationState == .background) {
                // if running in the background then monitor significant location changes only
                // Apple only allows certain types of applications to monitor all locations
                // while running the background (i.e. GPS, Fitness, etc.)
                self.locationManager?.startMonitoringSignificantLocationChanges()
            }
            else {
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func stopMonitoringLocations() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate members
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if ((self.locationManagerEnabled || self.locationManagerEnabledFiredSinceDelegate == false) && self.lastLocation == nil) {
            self.locationManagerEnabledFiredSinceDelegate = true;
            self.locationManagerEnabled = false;
            self.locationManagerDisabledOnError = true;
            self.notifyLocationManagerDisabled();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (self.locationManagerEnabled == false || self.locationManagerEnabledFiredSinceDelegate == false) {
            // if we received a location and delegates haven't been notified that
            // the location manager is enabled then we notify them now
            self.locationManagerEnabledFiredSinceDelegate = true
            self.locationManagerEnabled = true
            self.locationManagerDisabledOnError = false
            self.notifyLocationManagerEnabled()
        }
        
        if let newLocation = locations.last {
            if (UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive) {
                // if we are in the background then just take the first location sent to us
                // this means the significant update service either sent us a message
                // while we were paused (UIApplicationStateInactive)
                // or the app was shutdown (UIApplicationStateBackground)
                if (newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= RkAppConstants.minMetersLocationAccuracyBackground) {
                    self.processLocation(bestLocation: newLocation, locations: locations, inBackground: true)
                }
            }
            else {
                // app is in the foreground
                if (newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= RkAppConstants.minMetersLocationAccuracy) {
                    // process location if within desired accuracy
                    self.processLocation(bestLocation: newLocation, locations: locations, inBackground: false)
                }
            }
        }
    }
    
    
    //func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        if newHeading.headingAccuracy < 0 { return }
        
        // let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        self.notifyUpdatedHeading(newHeading: newHeading)
    }
    
    func processLocation(bestLocation: CLLocation, locations: [CLLocation], inBackground:Bool) {
        var process = false
        if (lastLocation == nil) {
            process = true
        }
        else {
            let secondsPassed = (NSDate().timeIntervalSince1970 - lastLocationTime!)
            let distance = bestLocation.distance(from: lastLocation!)
            let minDistance = (inBackground ? RkAppConstants.minMetersBetweenLocationsBackground : RkAppConstants.minMetersBetweenLocations)
            if (distance >= minDistance && secondsPassed > RkAppConstants.minSecondsBetweenLocations) {
                process = true
            }
        }
        if (process) {
            self.lastLocation = bestLocation
            self.lastLocationTime = NSDate().timeIntervalSince1970
            self.notifyUpdatedLocation(bestLocation: bestLocation, locations: locations, inBackground: inBackground)
        }
    }
    
    // MARK: Application State Changes
    
    func applicationPaused() {
        // switch to monitoring significant locations when moved to the background
        if (self.locationManager != nil) {
            self.locationManager?.stopUpdatingLocation();
            self.locationManager?.startMonitoringSignificantLocationChanges()
        }
    }
    
    func applicationResumed() {
        if (self.locationManager != nil) {
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager?.stopMonitoringSignificantLocationChanges();
            self.startMonitoringLocations()
        }
        else if (self.delegates.count > 0) {
            self.initLocationManager(silently: true)
        }
    }
    
}

