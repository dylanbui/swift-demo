//
//  AppleMapPin.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import MapKit

class AppleMapPin: MapPin, MKAnnotation
{
    public var coordinate: CLLocationCoordinate2D {
        return self.p_coordinate
    }
    
    var title: String? {
        return "title"
    }

    var subtitle: String? {
        return "subtitle"
    }
    
}


