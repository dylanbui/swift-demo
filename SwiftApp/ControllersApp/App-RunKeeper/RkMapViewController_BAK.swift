//
//  RkMapViewController.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import UIKit
import MapKit

class RkMapViewController: BaseViewController
{
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPace: UILabel!
    
    private var distance: Double = 0.0
    private var seconds = 0
    private var timer: Timer?
    private var locationList: [CLLocation] = []
    private var isRunning: Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Run Keeper"
        self.mapView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let rightBarButtonItem_1 = UIBarButtonItem.init(title: "Start", style: .plain) { (owner) in
            if self.isRunning == false {
                // -- Start --
                self.isRunning = true
                owner.title = "Stop"
                self.startRun()
            } else {
                // -- Stop --
                self.isRunning = false
                owner.title = "Start"
                self.stopRun()
            }
        }
        self.navigationItem.rightBarButtonItems =  [rightBarButtonItem_1]
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //33.762126, -118.157929
        let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(33.762126, -118.157929), 1000, 1000)
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.stopRun()
        
        // stop monitoring locations
        RkLocationMonitor.instance.removeDelegate(self)
    }

    private func startRun()
    {
        self.seconds = 0
        self.distance = 0
        locationList.removeAll()
        updateDisplay()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.eachSecond), userInfo: nil, repeats: true)
        
        // subscribe to locations
        RkLocationMonitor.instance.addDelegate(self)
    }
    
    private func stopRun()
    {
//        launchPromptStackView.isHidden = false
//        dataStackView.isHidden = true
//        startButton.isHidden = false
//        stopButton.isHidden = true
//        mapContainerView.isHidden = true
//
//        locationManager.stopUpdatingLocation()
        
        // -- Stop scheduledTimer --
        self.timer?.invalidate()
        // stop monitoring locations
        RkLocationMonitor.instance.removeDelegate(self)
    }
    
    @objc private func eachSecond()
    {
        self.seconds += 1
        self.updateDisplay()
    }
    
    private func updateDisplay()
    {
        let formattedDistance = FormatDisplay.distance(self.distance)
        let formattedTime = FormatDisplay.time(self.seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds)
        
        self.lblDistance.text = "Distance:  \(formattedDistance) m"
        self.lblTime.text = "Time:  \(formattedTime) s"
        self.lblPace.text = "Pace:  \(formattedPace) m/s"
    }
    
}

extension RkMapViewController: RkLocationMonitorDelegate
{
    func locationUpdated(bestLocation: CLLocation, locations: [CLLocation], inBackground: Bool)
    {
        for newLocation in locations {
            // let howRecent = newLocation.timestamp.timeIntervalSinceNow
            // guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation) / 1000 // => convert to meter
                distance = distance + delta //Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                self.mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                
                self.mapView.setCenter(newLocation.coordinate, animated: true)
            }
            
            locationList.append(newLocation)
        }
        
    }

}

// MARK: - Map View Delegate

extension RkMapViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

