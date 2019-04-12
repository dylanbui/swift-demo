//
//  MapKitDelegate.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/11/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import MapKit

enum AnnotationType {
    case currentUser
    case anchorPoint
    case defaultPoint
}

class MapKitAnnotation: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D

    var title: String?
    var subtitle: String?
    var image: UIImage?
    var color: UIColor
    var annotationType: AnnotationType //  = .defaultPoint
    
    override init()
    {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.color = UIColor.white
        self.annotationType = .defaultPoint
    }
    
    convenience init(withCoordinate coordinate: CLLocationCoordinate2D)
    {
        self.init()
        self.coordinate = coordinate
    }
    
    convenience init(withCoordinate coordinate: CLLocationCoordinate2D, title: String, color: UIColor)
    {
        self.init()
        self.coordinate = coordinate
        self.title = title
        self.color = color
    }
    
}


class MapKitDelegate: NSObject
{
    var mapView: MKMapView
    var polyline: MKPolyline? = nil
    var circle: MKCircle? = nil
    var pinCurrentUser: MapKitAnnotation? = nil
    var imgArrowHeading: UIImageView?
    
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
        self.mapView.showsCompass = true
        
        // -- Co 2 cach xu ly lay location o day --
        // C1 : lay location binh thuong tu thiet bi, roi gan cho map, dung centerAndZoom de move map theo location
        // C2 : Cho map tu lay location, minh se dung location cua map lam chuan
        /* Phai set
              self.mapView.showsUserLocation = true
              self.mapView.userTrackingMode = .followWithHeading // Auto start
         
         Set frame hien thi tu dau
             let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
             let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
             mapView.setRegion(region, animated: true)
         
         Khi do chung ta se lay location tu delegate va move map
             func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
                    mapView.setCenter(userLocation.coordinate, animated: true)
             }
         */
        
        // self.mapView.showsUserLocation = true
        // self.mapView.userTrackingMode = .followWithHeading // Auto start
        super.init()
        self.mapView.delegate = self
    }
    
    // MARK: LocationMapViewDelegate Members
    
    func providerId() -> String
    {
        return "MapKit"
    }
    
    func setStyle(styleId: String)
    {
        if let mapType = AppleMapDelegate.mapStyleTypes[styleId] {
            self.mapView.mapType = mapType;
        }
    }
    
    func showsUserLocation(status: Bool)
    {
        self.mapView.showsUserLocation = status
    }
    
    func makeAnnotation(coordinate: CLLocationCoordinate2D, title: String, color: UIColor) -> MapKitAnnotation
    {
        return MapKitAnnotation(withCoordinate: coordinate, title: title, color: color)
    }
    
    func drawAnnotation(annotation: MapKitAnnotation)
    {
        self.mapView.addAnnotation(annotation)
    }
    
    func removePins(pins: [MapKitAnnotation])
    {
        self.mapView.removeAnnotations(pins)
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
    
    func erasePath()
    {
        // remove polyline if one exists
        if (self.polyline != nil) {
            self.mapView.remove(self.polyline!)
            self.polyline = nil
        }
    }
    
    func drawRadius(centerCoordinate coordinate: CLLocationCoordinate2D, radiusMeters: CLLocationDistance)
    {
        // remove circle if one exists
        if (self.circle != nil) {
            self.mapView.remove(self.circle!)
        }
        // create and add new polyline
        self.circle = MKCircle(center: coordinate, radius: radiusMeters)
        self.mapView.add(self.circle!)
    }
    
    func eraseRadius()
    {
        // remove circle if one exists
        if (self.circle != nil) {
            self.mapView.remove(self.circle!)
            self.circle = nil
        }
    }
    
    func addCurrentUserPin(coordinate: CLLocationCoordinate2D) -> MapKitAnnotation
    {
        let pin = MapKitAnnotation(withCoordinate: coordinate)
        pin.annotationType = .currentUser
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
        pin.coordinate = to
        
        if let annotationView = self.mapView.view(for: pin) {
            annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
            annotationView.annotation = pin
        }
    }
    
    func updateArrowHeadingCurrentLoctionDirection(_ userHeading: CLLocationDirection?)
    {
        if let heading = userHeading, let arrow = self.imgArrowHeading {
            arrow.isHidden = false
            let rotation = CGFloat(heading/180 * Double.pi)
            arrow.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    func updateArrowHeadingCurrentLoctionDirection(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D)
    {
        guard let arrow = self.imgArrowHeading else {
            return
        }
        
        arrow.isHidden = false
        
        print("From : \(from.latitude) -- \(from.longitude) <==> To : \(to.latitude) -- \(to.longitude)")
        
        let getAngle = self.angle(FromCoordinate: from, toCoordinate: to)
        arrow.transform = CGAffineTransform(rotationAngle: CGFloat(getAngle))
    }
    
    
    func centerAndZoom(centerCoordinate: CLLocationCoordinate2D, radiusMeters: CLLocationDistance, animated: Bool)
    {
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
    }
    
}


extension MapKitDelegate: MKMapViewDelegate
{

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
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView])
    {
        if views.last?.annotation is MKUserLocation {
            self.addHeadingView(toAnnotationView: views.last!)
        }
    }
    
    func addHeadingView(toAnnotationView annotationView: MKAnnotationView)
    {
//        if let locationView = annotationView as? MKModernUserLocationView {
//        
//        }
        
        if self.imgArrowHeading == nil {
            
            print("annotationView = \(String(describing: type(of: annotationView)))")
            
            annotationView.image = nil
            
            // let image = UIImage.init(named: "icBlueArrowUp") //#YOUR BLUE ARROW ICON#
            let image = UIImage(named: "icVCarTopRed")
            
            print("annotationView = \(String(describing: annotationView.frame))")
            print("image?.size = \(String(describing: image?.size))")
            print("annotationView.center = \(String(describing: annotationView.center))")
            
            let width = annotationView.frame.size.width //*3/2
            let height = annotationView.frame.size.height //*3
            
            self.imgArrowHeading = UIImageView(image: image)
            self.imgArrowHeading!.frame = CGRect(x: (annotationView.frame.size.width - width)/2,
                                                 y: (annotationView.frame.size.height - height)/2,
                                                 width: width,
                                                 height: height)
            
            annotationView.addSubview(self.imgArrowHeading!)
            // annotationView.sendSubview(toBack: self.imgArrowHeading!)
            annotationView.bringSubview(toFront: self.imgArrowHeading!)
            self.imgArrowHeading!.isHidden = true
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {
            return nil
        }
    
        guard let pin = annotation as? MapKitAnnotation else {
            return nil
        }
        
        if pin.annotationType == .currentUser {
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
            return anView
        }
    
        // -- Kiem tra theo tung loai pin thi tao cac doi tuong khac nhau --
        let reuseIdentifier = "PinAnnotation"
        var pinAnnotation: MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if(pinAnnotation == nil) {
            pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        else {
            pinAnnotation?.annotation = annotation
        }
        pinAnnotation!.pinTintColor = pin.color
        pinAnnotation?.canShowCallout = true
        return pinAnnotation
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
    
}
