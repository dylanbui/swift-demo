//
//  AppleMapDelegate.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import MapKit

class AppleMapDelegate: NSObject, MapDelegate, MKMapViewDelegate
{
    var mapView: MKMapView
    var polyline: MKPolyline? = nil
    var circle: MKCircle? = nil
    var pinCurrentUser: AppleMapPin? = nil
    
    static let mapDefaultStyleId = "Standard"
    static let mapStyleIds = ["Standard","Satellite","Satellite Flyover","Hybrid","Hybrid Flyover"]
    static let mapStyleTypes: [String:MKMapType] = ["Standard":MKMapType.standard,
                                                    "Satellite":MKMapType.satellite,
                                                    "Satellite Flyover":MKMapType.satelliteFlyover,
                                                    "Hybrid":MKMapType.hybrid,
                                                    "Hybrid Flyover":MKMapType.hybridFlyover]
    
    init(mapView: MKMapView)
    {
        self.mapView = mapView
        // self.mapView.showsUserLocation = true
        // self.mapView.userTrackingMode = .followWithHeading // Auto start
        super.init()
        self.mapView.delegate = self
    }
    
    // MARK: LocationMapViewDelegate Members
    
    func providerId() -> String {
        return "MapKit"
    }
    
    func setStyle(styleId: String) {
        if let mapType = AppleMapDelegate.mapStyleTypes[styleId] {
            self.mapView.mapType = mapType;
        }
    }
    
    func addCurrentUserPin(coordinate: CLLocationCoordinate2D) -> MapPin
    {
        let pin = AppleMapPin(WithType: .currentUser, coordinate: coordinate, title: "", color: UIColor.clear)
        self.pinCurrentUser = pin
        self.mapView.addAnnotation(self.pinCurrentUser!)
        return self.pinCurrentUser!
    }
    
    func updateCurrentLoctionDirection(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
    {
        guard let pin = self.pinCurrentUser else {
            return
        }
        
        let getAngle = self.angle(FromCoordinate: from, toCoordinate: to)
        
        print("From : \(from.latitude) -- \(from.longitude) <==> To : \(to.latitude) -- \(to.longitude)")
        // pin.coordinate = to
        pin.p_coordinate = to
        
        if let annotationView = self.mapView.view(for: pin) {
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
            annotationView.annotation = pin
        }
        
    }
    
    func updateCurrentLoctionDirection(forView view: UIView?, from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
    {
        let getAngle = self.angle(FromCoordinate: from, toCoordinate: to)
        
        print("From : \(from.latitude) -- \(from.longitude) <==> To : \(to.latitude) -- \(to.longitude)")
        
        if let annotationView = view as? MKAnnotationView {
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
            let pin = AppleMapPin(coordinate: to, title: "", color: UIColor.clear)
            annotationView.annotation = pin
        }
        
    }
    
    func getPin(coordinate: CLLocationCoordinate2D, title: String, color: UIColor) -> MapPin
    {
        return AppleMapPin(coordinate: coordinate, title: title, color: color)
    }
    
    func addPin(pin: MapPin)
    {
        self.mapView.addAnnotation(pin as! AppleMapPin)
    }
    
    func removePins(pins: [MapPin])
    {
        self.mapView.removeAnnotations(pins as! [AppleMapPin])
    }
    
    func drawPath(coordinates: [CLLocationCoordinate2D])
    {
        // remove polyline if one exists
        if (self.polyline != nil) {
            self.mapView.remove(self.polyline!)
        }
        // create and add new polyline
        var mutableCoordinates = coordinates;
        self.polyline = MKPolyline(coordinates: &mutableCoordinates, count: coordinates.count)
        self.mapView.add(self.polyline!)
    }
    
    func erasePath() {
        // remove polyline if one exists
        if (self.polyline != nil) {
            self.mapView.remove(self.polyline!)
            self.polyline = nil
        }
    }
    
    func drawRadius(centerCoordinate coordinate: CLLocationCoordinate2D, radiusMeters: CLLocationDistance) {
        // remove circle if one exists
        if (self.circle != nil) {
            self.mapView.remove(self.circle!)
        }
        // create and add new polyline
        self.circle = MKCircle(center: coordinate, radius: radiusMeters)
        self.mapView.add(self.circle!)
    }
    
    func eraseRadius() {
        // remove circle if one exists
        if (self.circle != nil) {
            self.mapView.remove(self.circle!)
            self.circle = nil
        }
    }
    
    func centerAndZoom(centerCoordinate: CLLocationCoordinate2D, radiusMeters: CLLocationDistance, animated: Bool) {
        let region = MKCoordinateRegionMakeWithDistance(centerCoordinate, radiusMeters, radiusMeters)
        self.mapView.setRegion(region, animated: animated)
    }
    
    func angle(FromCoordinate first:CLLocationCoordinate2D, toCoordinate second:CLLocationCoordinate2D) -> Double
    {
        let deltaLongitude:Double = second.longitude - first.longitude
        let deltaLatitude:Double = second.latitude - first.latitude
        let angle:Double = (Double.pi * 0.5) - atan(deltaLatitude / deltaLongitude)
        
        if deltaLongitude > 0 {
            return angle
        } else if (deltaLongitude < 0) {
            return angle + Double.pi
        } else if (deltaLatitude < 0)  {
            return Double.pi
        }
        return Double.pi
        // return 0.0
    }
    
    
    // MARK: MKMapViewDelegate Members
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if (overlay === self.polyline) {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 2
            return polylineRenderer
        }
        else {
            let cirlceRenderer = MKCircleRenderer(overlay: overlay)
            cirlceRenderer.strokeColor = UIColor.green
            cirlceRenderer.fillColor = UIColor.green.withAlphaComponent(0.15)
            cirlceRenderer.lineWidth = 2
            return cirlceRenderer
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationReuseId = "CustomPinAnnotationView"
        var anView = self.mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView?.annotation = annotation
        }
        anView?.image = UIImage(named: "icVCarTopRed")
        anView?.backgroundColor = UIColor.clear
        anView?.canShowCallout = true
        anView?.calloutOffset = CGPoint(0, 32)
        return anView!
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        guard let pin = annotation as? MapPin else {
//            return nil
//        }
//
//        if pin.type == .currentUser {
//
//            let annotationReuseId = "CustomPinAnnotationView"
//            var anView = self.mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
//            if anView == nil {
//                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
//            } else {
//                anView?.annotation = annotation
//            }
//            anView?.image = UIImage(named: "icVCarTopRed")
//            anView?.backgroundColor = UIColor.clear
//            anView?.canShowCallout = true
//            return anView
//
////            var currAnnotation: CurrentAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: "CurrentPinAnnotation") as? CurrentAnnotationView
////            if(currAnnotation == nil) {
////                currAnnotation = CurrentAnnotationView(annotation: self.pinCurrentUser, reuseIdentifier: "CurrentPinAnnotation")
////                // -- Tung loai khac nhau thi xu ly khac nhau --
////                let imgCar = UIImage.init(named: "icCarTopRed")!
////                currAnnotation?.btnInfor = UIButton.init()
////                currAnnotation?.frame = CGRect.init(0.0, 0.0, imgCar.size.width, imgCar.size.height)
////                currAnnotation?.btnInfor?.frame = currAnnotation!.frame
////                currAnnotation?.btnInfor?.setBackgroundImage(imgCar, for: .normal)
////                currAnnotation?.addSubview((currAnnotation?.btnInfor)!)
////                // currAnnotation?.isDraggable = true
////            }
////            else {
////                currAnnotation?.annotation = self.pinCurrentUser
////            }
////
////            currAnnotation?.canShowCallout = true
////            return currAnnotation
//        }
//
//        // -- Kiem tra theo tung loai pin thi tao cac doi tuong khac nhau --
//        let reuseIdentifier = "PinAnnotation"
//        var pinAnnotation: MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
//        if(pinAnnotation == nil) {
//            pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        }
//        else {
//            pinAnnotation?.annotation = annotation
//        }
//        pinAnnotation!.pinTintColor = pin.p_color
//        pinAnnotation?.canShowCallout = true
//        return pinAnnotation
//    }
    
}
