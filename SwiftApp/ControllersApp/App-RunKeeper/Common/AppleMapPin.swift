//
//  AppleMapPin.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import MapKit

class CurrentAnnotationView: MKAnnotationView
{
    var btnInfor: UIButton?
    
}


class AppleMapPin: MapPin, MKAnnotation
{
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
    
//    var coordinate: CLLocationCoordinate2D {
//        return self.p_coordinate
//    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return self.p_coordinate
        }
        set {
            self.p_coordinate = newValue
        }
    }
    
    var title: String? {
        return self.p_title
    }

//    var subtitle: String? {
//        return "subtitle"
//    }
    
//    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//    }
    
}


