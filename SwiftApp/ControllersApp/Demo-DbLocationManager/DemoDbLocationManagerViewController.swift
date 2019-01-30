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
        let manager: DbLocationManager = DbLocationManager.sharedInstance
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
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        
        let geoFences = manager.getCurrentFences()
        var allFencetxt = "All fences: "
        for geofence: DbFenceInfo in geoFences ?? [] {
            var txt: String? = nil
            if  let object: Double = geofence.fenceCoordinate[DB_LATITUDE] as? Double,
                let object1: Double = geofence.fenceCoordinate[DB_LONGITUDE] as? Double,
                let object2: Double = geofence.fenceCoordinate[DB_RADIOUS] as? Double {
                txt = "Geofence '\(geofence.fenceIDentifier)' is Active at Coordinates: \(object):\(object1) with \(object2) meter radious \n"
            }
            print("\(txt ?? "")")
            allFencetxt = allFencetxt + (txt ?? "")
        }
        self.logtext(allFencetxt)
        if geoFences?.count == 0 {
            self.logtext("No Geofence is added currently")
        }
    }
    
    @IBAction func addFenceGeoatCurrentLocation(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        manager.delegate = self
        manager.addGeofenceAtCurrentLocation(withRadious: 100)
    }
    
    @IBAction func removeAllGeofence(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        
        let geoFences = manager.getCurrentFences()
        
        for geofence: DbFenceInfo in geoFences ?? [] {
            manager.deleteGeoFence(withIdentifier: geofence.fenceIDentifier)
        }
        logtext("All Geofences deleted!")
    }

    @IBAction func getCurrentLocation(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        manager.getCurrentLocation(withCompletion: { success, latLongAltitudeDictionary, error in
            self.logtext("Current Location: \(latLongAltitudeDictionary.description)")
            self.showInMaps(withDictionary: latLongAltitudeDictionary, title: "Current Location")
        })
        //[manager getCurrentLocationWithDelegate:self]; //can be used
    }
    
    @IBAction func getCurrentGeoCodeAddress(_ sender: Any)
    {
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        manager.getCurrentGeoCodeAddress(withCompletion: { success, addressDictionary, error in
            //access the dict using BB_LATITUDE, BB_LONGITUDE, BB_ALTITUDE
            self.logtext("Current Location GeoCode/Address: \(addressDictionary.description)")
            self.showInMaps(withDictionary: addressDictionary, title: "Geocode/Address")
        })
        //[manager getCurrentLocationWithDelegate:self]; //can be used
    }

    @IBAction func getContiniousLocation(_ sender: Any)
    {
        print("getContiniousLocation ----")
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        manager.getContiniousLocation(withDelegate: self)
    }
    
    @IBAction func getSignificantLocationChange(_ sender: Any)
    {
        print("getSignificantLocationChange ----")
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        manager.getSignificantLocationChange(withDelegate: self)
    }
    
    @IBAction func stopGettingLocation(_ sender: Any)
    {
        print("stopGettingLocation ----")
        let manager: DbLocationManager = DbLocationManager.sharedInstance
        manager.stopGettingLocation()
    }
    
    // MARK: - Private Functions
    
    func showInMaps(withDictionary locationDict: DbLocationInfo, title: String)
    {
        let infiniteLoopCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(
            (locationDict[DB_LATITUDE] as? NSNumber)!.doubleValue,
            (locationDict[DB_LONGITUDE] as? NSNumber)!.doubleValue)
        
        self.annotation?.coordinate = infiniteLoopCoordinate
        self.annotation?.title = title
        self.mapView.addAnnotation(self.annotation!)
        
        self.mapView.region = MKCoordinateRegionMakeWithDistance(infiniteLoopCoordinate, 3000.0, 3000.0)
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
    func dbLocationManagerDidAddFence(_ fenceInfo: DbFenceInfo?)
    {
        let text = "Added GeoFence: \(fenceInfo!.dictionary.description)"
        print("\(text)")
        self.logtext(text)
        self.showInMaps(withDictionary: fenceInfo!.fenceCoordinate, title: "Added GeoFence")
    }
    
    func dbLocationManagerDidFailedFence(_ fenceInfo: DbFenceInfo?)
    {
        let text = "Failed to add GeoFence: \(fenceInfo!.dictionary.description)"
        print("\(text)")
        self.logtext(text)
        self.showInMaps(withDictionary: fenceInfo!.fenceCoordinate, title: "Failed GeoFence")
    }
    
    func dbLocationManagerDidEnterFence(_ fenceInfo: DbFenceInfo?)
    {
        var text: String? = nil
        if let description = fenceInfo?.dictionary.description {
            text = "Entered GeoFence: \(description)"
        }
        print("\(text ?? "")")
        self.logtext(text)
        self.showLocalNotification("Enter Fence \(text ?? "")", with: Date(timeIntervalSinceNow: 1))
        self.showInMaps(withDictionary: fenceInfo!.fenceCoordinate, title: "Enter GeoFence")
    }
    
    func dbLocationManagerDidExitFence(_ fenceInfo: DbFenceInfo?)
    {
        var text: String? = nil
        if let description = fenceInfo?.dictionary.description {
            text = "Exit GeoFence: \(description)"
        }
        print("\(text ?? "")")
        self.logtext(text)
        self.showLocalNotification("Exit Fence \(text ?? "")", with: Date(timeIntervalSinceNow: 1))
        self.showInMaps(withDictionary: fenceInfo!.fenceCoordinate, title: "Exit GeoFence")
    }
    
    func dbLocationManagerDidUpdateLocation(_ latLongAltitudeDictionary: DbLocationInfo)
    {
        print("Current Location: \(latLongAltitudeDictionary.description)")
        self.logtext("Current Location: \(latLongAltitudeDictionary.description) at time: \(Date().description)")
        self.showInMaps(withDictionary: latLongAltitudeDictionary, title: "Current Location")
    }
    
    func dbLocationManagerDidUpdateGeocodeAdress(_ addressDictionary: DbLocationInfo?)
    {
        print("Current Location GeoCode/Address: \(addressDictionary?.description ?? "")")
        self.logtext("Current Location: \(addressDictionary?.description ?? "") at time: \(Date().description)")
        self.showInMaps(withDictionary: addressDictionary!, title: "Geocode Updated")
    }
    
    
}
