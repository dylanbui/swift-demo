//
//  MapPin.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class MapPin : NSObject
{
    var p_coordinate: CLLocationCoordinate2D
    var p_title: String?
    var p_color: UIColor?
    
    init(coordinate: CLLocationCoordinate2D, title: String, color: UIColor) {
        self.p_coordinate = coordinate
        self.p_title = title
        self.p_color = color
    }
    
}

protocol MapDelegate
{
    func providerId() -> String
    func setStyle(styleId: String)
    func getPin(coordinate: CLLocationCoordinate2D, title: String, color: UIColor) -> MapPin
    func addPin(pin: MapPin)
    func removePins(pins: [MapPin])
    func drawPath(coordinates: [CLLocationCoordinate2D])
    func erasePath()
    func drawRadius(centerCoordinate: CLLocationCoordinate2D, radiusMeters: CLLocationDistance)
    func eraseRadius()
    func centerAndZoom(centerCoordinate: CLLocationCoordinate2D, radiusMeters: CLLocationDistance, animated: Bool)
}
