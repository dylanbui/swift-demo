//
//  FormatDisplay.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/2/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

struct FormatDisplay
{
    static func distance(_ distance: Double) -> String
    {
        return String(format: "%.1f", distance)
//        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
//        return FormatDisplay.distance(distanceMeasurement)
    }
    
//    static func distance(_ distance: Measurement<UnitLength>) -> String {
//        let formatter = MeasurementFormatter()
//        return formatter.string(from: distance)
//    }
    
    static func time(_ seconds: Int) -> String
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    static func pace(distance: Double, seconds: Int) -> String {
        let speedMagnitude = seconds != 0 ? distance / Double(seconds) : 0
        return String(format: "%.1f", speedMagnitude)
        // -- Support ios 10 --
//        let formatter = MeasurementFormatter()
//        formatter.unitOptions = [.providedUnit] // 1
//        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
//        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
//        return formatter.string(from: speed.converted(to: outputUnit))
    }
    
    static func date(_ timestamp: Date?) -> String
    {
        guard let timestamp = timestamp as Date? else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
}
