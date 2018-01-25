//
//  LocationManager.swift
//  SwiftApp
//
//  Created by Dylan Bui on 1/25/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import Foundation
import INTULocationManager

typealias DbLocationAccuracy = INTULocationAccuracy
typealias DbLocationStatus = INTULocationStatus

extension INTULocationManager {
    func showAlertMessage(_ status: INTULocationStatus) -> Void {
        
//        // These statuses indicate some sort of error, and will accompany a nil location.
//        /** User has not yet responded to the dialog that grants this app permission to access location services. */
//        INTULocationStatusServicesNotDetermined,
//        /** User has explicitly denied this app permission to access location services. */
//        INTULocationStatusServicesDenied,
//        /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
//        INTULocationStatusServicesRestricted,
//        /** User has turned off location services device-wide (for all apps) from the system Settings app. */
//        INTULocationStatusServicesDisabled,
//        /** An error occurred while using the system location services. */
        
        switch status {
        case .servicesDenied: /** User has explicitly denied this app permission to access location services. */
            break
        case .servicesDisabled: /** User has turned off location services device-wide (for all apps) from the system Settings app. */
            break
        case .servicesNotDetermined: /** User has not yet responded to the dialog that grants this app permission to access location services. */
            break
        
        default:
            break
            
        }
        
        
    }
}

class LocationManager: INTULocationManager {
    

    func requestLocationWithDesiredAccuracyHouse(_ block: @escaping INTULocationRequestBlock) {
        
    }
    
//    func requestLocation(withDesiredAccuracy desiredAccuracy: DbLocationAccuracy, timeout: TimeInterval, block: @escaping INTULocationRequestBlock) -> INTULocationRequestID {
//
//        return super.requestLocation(withDesiredAccuracy: desiredAccuracy, timeout: timeout) { (currentLocation, achievedAccuracy, status) in
//            block(currentLocation, achievedAccuracy, status)
//        }
//
//    }
    
    
}
