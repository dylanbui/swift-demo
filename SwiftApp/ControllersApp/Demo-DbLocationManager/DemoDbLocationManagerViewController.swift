//
//  DemoDbLocationManagerViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/29/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import MapKit

class DemoDbLocationManagerViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logTextView: UITextView!
    
    var annotation: MKPointAnnotation?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let manager: DbLocationManager = DbLocationManager.shared
        manager.delegate = self //not mandatory here, just to get the delegate calls
        

        self.mapView.layer.cornerRadius = 6.0
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        self.annotation = MKPointAnnotation()
    }

    @IBAction func showAllGeoFences(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.shared
        
        let geoFences = manager.getCurrentFences()
        var allFencetxt = "All fences: "
        for geofence: DbFencemark in geoFences ?? [] {
            let txt: String = "Geofence '\(geofence.fenceIDentifier)' is Active at Coordinates: \(geofence.fenceCentralCoordinate.latitude):\(geofence.fenceCentralCoordinate.longitude) with \(geofence.fenceRadious) meter radious \n"
            allFencetxt = allFencetxt + txt
        }
        self.logtext(allFencetxt)
        if geoFences?.count == 0 {
            self.logtext("No Geofence is added currently")
        }
    }
    
    @IBAction func addFenceGeoatCurrentLocation(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.shared
        manager.delegate = self
        manager.addGeofenceAtCurrentLocation(withRadious: 100)
    }
    
    @IBAction func removeAllGeofence(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.shared
        
        let geoFences = manager.getCurrentFences()
        
        for geofence: DbFencemark in geoFences ?? [] {
            manager.deleteGeoFence(withIdentifier: geofence.fenceIDentifier)
        }
        logtext("All Geofences deleted!")
    }

    @IBAction func getCurrentLocation(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.shared
        
        // Simple request location. Only run when get location sucessfully
        manager.requestSuccessLocation { (location) in
            self.logtext("Current Location: \(location.description)")
            self.showInMaps(with: location.coordinate, title: "Current Location")
        }
        
//        manager.getCurrentLocation(withCompletion: { cllocation, error in
//            if let location = cllocation {
//                self.logtext("Current Location: \(location.description)")
//                self.showInMaps(with: location.coordinate, title: "Current Location")
//            }
//        })
    }
    
    @IBAction func getCurrentGeoCodeAddress(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.shared
        manager.getCurrentGeoCodeAddress(withCompletion: { dbPlacemark, error in
            //access the dict using BB_LATITUDE, BB_LONGITUDE, BB_ALTITUDE
            if let dbPlacemark = dbPlacemark {
                self.logtext("Current Location GeoCode/Address: \(dbPlacemark.addressFullData.description)")
                // self.showInMaps(withDictionary: addressDictionary, title: "Geocode/Address")
            }
        })
    }

    @IBAction func getContiniousLocation(_ sender: Any)
    {
        print("getContiniousLocation ----")
        let manager: DbLocationManager = DbLocationManager.shared
        manager.getContiniousLocation(withDelegate: self)
    }
    
    @IBAction func getSignificantLocationChange(_ sender: Any)
    {
        print("getSignificantLocationChange ----")
        let manager: DbLocationManager = DbLocationManager.shared
        manager.getSignificantLocationChange(withDelegate: self)
    }
    
    @IBAction func stopGettingLocation(_ sender: Any)
    {
        print("stopGettingLocation ----")
        let manager: DbLocationManager = DbLocationManager.shared
        manager.stopGettingLocation()
    }
    
    // MARK: - Private Functions
    
    func showInMaps(with coordinate: CLLocationCoordinate2D, title: String)
    {
//        let infiniteLoopCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(
//            (locationDict[DB_LATITUDE] as? NSNumber)!.doubleValue,
//            (locationDict[DB_LONGITUDE] as? NSNumber)!.doubleValue)
        
        self.annotation?.coordinate = coordinate
        self.annotation?.title = title
        self.mapView.addAnnotation(self.annotation!)
        
        self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 3000.0, 3000.0)
    }

    private func logtext(_ text: String?)
    {
        self.logTextView.text = text
    }

    private func showLocalNotification(_ notificationBody: String?, with notificationDate: Date?)
    {
        let app = UIApplication.shared
        let notification = UILocalNotification()
        
        notification.fireDate = notificationDate
        notification.timeZone = NSTimeZone.default
        notification.alertBody = notificationBody
        notification.soundName = UILocalNotificationDefaultSoundName
        
        let userInfo: [AnyHashable : Any] = [:]
        notification.userInfo = userInfo
        app.scheduleLocalNotification(notification)
    }
    

}


extension DemoDbLocationManagerViewController: DbLocationManagerDelegate
{
    func dbLocationManager(DidUpdateBestLocation location: CLLocation)
    {
        print("Current Location: \(location.description)")
        self.logtext("Current Location: \(location.description) at time: \(Date().description)")
        self.showInMaps(with: location.coordinate, title: "Current Location")
    }

    func dbLocationManager(DidUpdateListLocations locations: [CLLocation])
    {
        // Fetch Current Location
        guard let location: CLLocation = locations.last else {
            print("Khong tim thay LOCTION NAO")
            return
        }
        print("location.description = \(location.description)")
        print("DidUpdateListLocations = \(locations.count)")
    }
    
    func dbLocationManager(DidAddFence fenceInfo: DbFencemark?)
    {
        let text = "Added GeoFence: \(fenceInfo!.dictionary.description)"
        print("\(text)")
        self.logtext(text)
        self.showInMaps(with: fenceInfo!.fenceCentralCoordinate, title: "Added GeoFence")
    }
    
    func dbLocationManager(DidFailedFence fenceInfo: DbFencemark?)
    {
        let text = "Failed to add GeoFence: \(fenceInfo!.dictionary.description)"
        print("\(text)")
        self.logtext(text)
        self.showInMaps(with: fenceInfo!.fenceCentralCoordinate, title: "Failed GeoFence")
    }
    
    func dbLocationManager(DidEnterFence fenceInfo: DbFencemark?)
    {
        var text: String? = nil
        if let description = fenceInfo?.dictionary.description {
            text = "Entered GeoFence: \(description)"
        }
        print("\(text ?? "")")
        self.logtext(text)
        self.showLocalNotification("Enter Fence \(text ?? "")", with: Date(timeIntervalSinceNow: 1))
        self.showInMaps(with: fenceInfo!.fenceCentralCoordinate, title: "Enter GeoFence")
    }
    
    func dbLocationManager(DidExitFence fenceInfo: DbFencemark?)
    {
        var text: String? = nil
        if let description = fenceInfo?.dictionary.description {
            text = "Exit GeoFence: \(description)"
        }
        print("\(text ?? "")")
        self.logtext(text)
        self.showLocalNotification("Exit Fence \(text ?? "")", with: Date(timeIntervalSinceNow: 1))
        self.showInMaps(with: fenceInfo!.fenceCentralCoordinate, title: "Exit GeoFence")
    }
    
    func dbLocationManager(DidUpdateGeocodeAdress placemark: DbPlacemark?)
    {
        print("Current Location GeoCode/Address: \(placemark?.addressFullData.description ?? "")")
        self.logtext("Current Location: \(placemark?.location.description ?? "") at time: \(Date().description)")
        self.showInMaps(with: (placemark?.location.coordinate)!, title: "Geocode Updated")
    }
    
    
}
