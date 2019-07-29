//
//  PropertyUnit.swift
//  SwiftApp
//
//  Created by Dylan Bui on 7/15/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation
import MapKit

class DateTransformUnit: TransformType
{
    public typealias Object = Date
    public typealias JSON = Double
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt / 1000))
        }
        
        if let timeStr = value as? String {
            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> Double? {
        if let date = value {
            return Double(date.timeIntervalSince1970 * 1000)
        }
        return nil
    }
}

let ERR_LOCATION = CLLocationCoordinate2DMake(0, 0)

//class MapKitPin : NSObject, MKAnnotation
//{
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//
//    var unitProperty: PropertyUnit?
//
//    convenience init(property: PropertyUnit)
//    {
//        self.init(coordinate: property.unitLocation?.coordinate ?? ERR_LOCATION, title: property.title ?? "", subtitle: "")
//        self.unitProperty = property
//    }
//
//    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String)
//    {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//    }
//}

class MapKitPin : NSObject, Mappable, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var unitProperty: PropertyUnit?
    
    required convenience init?(map: Map)
    {
        guard let unitProperty = PropertyUnit.init(map: map) else {
            return nil
        }
        self.init(property: unitProperty)
    }
    
    convenience init(property: PropertyUnit)
    {
        self.init(coordinate: property.unitLocation?.coordinate ?? ERR_LOCATION, title: property.title ?? "", subtitle: "")
        self.unitProperty = property
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    func mapping(map: Map)
    {
        
    }
}



class PropertyUnit: Mappable
{
    var listingId: Int = 0
    var rlistingId: Int = 0
    var diyId: Int = 0
    
    var title: String?
    var listingTypeId: Int?
    var listingTypeName: String?
    var propertyTypeId: Int?
    var propertyTypeName: String?
    
    var description: String?
    var price: Int64?
    var currency: String?
    
    
    var bathRooms: Int?
    var bedRooms: Int?
    
    var priceVnd: Int?
    var lotSize: Float?
    var floorSize: Float?

    var sizeWidth: Float?
    var sizeLength: Float?
    var formatPrice: String?
    var formatSize: String?
    var formatLotSize: String?
    var displayFormatSize: String?
    var directionId: Int?
    var directionName: String?
    
    var isDeleted: Bool?
    var isPrivate: Bool?
    var isShowFull: Bool?
    var isCart: Bool?
    var isMyListing: Bool?
    var isGuaranteed: Bool?
    
    var timeToLive: Double?
    var moveInDate: Date?
    var createdDate: Date?
    var updatedDate: Date?
    
    var photo: PhotoUnit? // Chi co 1 tam anh, dung cho mylisting
    var photos: [PhotoUnit]?
    var photoGcns: [PhotoUnit]?
    
    //link share fb
    var link: String?
    
    var unitLocation: PropertyLocationUnit?
    
    required convenience init?(map: Map)
    {
        self.init()
        self.mapping(map: map)
    }
    
    func formatTimeToLive() -> String
    {
        let timeToLive = Int(self.timeToLive ?? 0)
        
        var strFormat = ""
        let secondInDay: Int = 24*3600
        if (timeToLive > secondInDay) {
            let totalDays = timeToLive/(24*3600)
            let days = totalDays % 30
            var months = totalDays / 30
            var str = String(format: "%d ngày đăng", days)
            if months > 2 {
                months = months + (days > 21 ? 1 : 0);
                str = String(format: "%d tháng đăng", months)
            }
            strFormat = str;
        } else {
            if timeToLive <= 3600 { // 1h = 3600
                strFormat = "1 giờ trước"
            } else {
                let totalHour = timeToLive/3600
                strFormat = String(format: "%d giờ đăng", totalHour)
            }
        }
        return strFormat
    }
    
    func mapping(map: Map)
    {
        listingId              <- map["listingId"]
        rlistingId              <- map["rlistingId"]
        diyId              <- map["diyId"]
        
        listingTypeId           <- map["listingTypeId"]
        listingTypeName         <- map["listingTypeName"]
        
        propertyTypeId        <- map["propertyTypeId"]
        propertyTypeName        <- map["propertyTypeName"]
        
        
        description             <- map["description"]
        price                   <- map["price"]
        currency                <- map["currency"]
        isDeleted               <- map["isDeleted"]
        isPrivate               <- map["isPrivate"]
        isShowFull              <- map["isShowFull"]
        isCart                  <- map["isCart"]
        isMyListing             <- map["isMyListing"]
        link                    <- map["link"]
        
        
        title                   <- map["title"]
        bathRooms               <- map["bathRooms"]
        bedRooms                <- map["bedRooms"]
        priceVnd                <- map["priceVnd"]
        lotSize                 <- map["lotSize"]
        floorSize               <- map["floorSize"]
        
        sizeWidth               <- map["sizeWidth"]
        sizeLength              <- map["sizeLength"]
        formatPrice             <- map["formatPrice"]
        formatSize              <- map["formatSize"]
        formatLotSize           <- map["formatLotSize"]
        displayFormatSize       <- map["displayFormatSize"]
        directionId             <- map["directionId"]
        directionName           <- map["directionName"]
        
        isGuaranteed            <- map["isGuaranteed"]
        
        timeToLive              <- map["timeToLive"] // Thoi gian da ton tai
        moveInDate              <- (map["moveInDate"], DateTransformUnit())
        createdDate             <- (map["createdDate"], DateTransformUnit())
        updatedDate             <- (map["updatedDate"], DateTransformUnit())
        
        unitLocation  = PropertyLocationUnit(map: map)
        photo                   <- map["photo"]
        photos                  <- map["photos"]
        photoGcns               <- map["photoGcns"]
    }
}

class PropertyLocationUnit: Mappable //, CustomStringConvertible
{
    var address: String?
    var shortAddress: String?
    var houseNumberRoad: String?
    
    var latitude: Double?
    var longitude: Double?
    var cityId: Int?
    var cityName: String?
    var districtId: Int?
    var districtName: String?
    var wardId: Int?
    var wardName: String?
    
    var unitCity: CityUnit? {
        didSet {
            self.cityId = self.unitCity?.cityId
            self.cityName = self.unitCity?.cityName
        }
    }
    
    var unitDistrict: DistrictUnit? {
        didSet {
            self.districtId = self.unitDistrict?.districtId
            self.districtName = self.unitDistrict?.districtName
        }
    }
    
    var unitWard: WardUnit? {
        didSet {
            self.wardId = self.unitWard?.wardId
            self.wardName = self.unitWard?.wardShortName
        }
    }
    
    var coordinate: CLLocationCoordinate2D = DEF_LOCATION {
        didSet {
            self.latitude = self.coordinate.latitude
            self.longitude = self.coordinate.longitude
        }
    }
    
    required convenience init?(map: Map)
    {
        self.init()
        self.mapping(map: map)
    }
    
    @discardableResult
    func makeAddress() -> String
    {
        // -- Join address --
        var strAddress = self.shortAddress ?? ""
        if let objWard = self.unitWard {
            self.wardId = objWard.wardId
            strAddress += ", \(objWard.wardName)"
        }
        if let objDistrict = self.unitDistrict {
            self.districtId = objDistrict.districtId
            strAddress += ", \(objDistrict.districtName)"
        }
        if let objCity = self.unitCity {
            self.cityId = objCity.cityId
            strAddress += ", \(objCity.cityName)"
        }
        self.address = strAddress
        return strAddress
    }
    
    func mapping(map: Map)
    {
        address                     <- map["address"]
        shortAddress                <- map["shortAddress"]
        houseNumberRoad                <- map["houseNumberRoad"]
        latitude                    <- map["latitude"]
        longitude                   <- map["longitude"]
        cityId                      <- map["cityId"]
        cityName                    <- map["cityName"]
        districtId                  <- map["districtId"]
        districtName                <- map["districtName"]
        wardId                      <- map["wardId"]
        wardName                    <- map["wardName"]
        
        if let lat = map.JSON["latitude"] as? CLLocationDegrees,
            let long = map.JSON["longitude"] as? CLLocationDegrees {
            self.coordinate = CLLocationCoordinate2DMake(lat, long)
        }
        
//        if let cityId = map.JSON["cityId"] as? Int {
//            unitCity = CityUnit.getCityById(cityId)
//        }
//
//        if let districtId = map.JSON["districtId"] as? Int {
//            unitDistrict = DistrictUnit.getDistrictById(districtId)
//        }
//
//        if let wardId = map.JSON["wardId"] as? Int {
//            unitWard = WardUnit.getWardById(wardId)
//        }
        
    }
    
    //    func printVariables()
    //    {
    //        let serializedUser = Mapper().toJSON(self)
    //        debugPrint(serializedUser)
    //    }
    //
    //    public var description: String
    //    {
    //        return "LocationUnit == " + (self.toJSONString() ?? "-none-")
    //        // return "Response data: \(String(describing: representation))"
    //    }
    
}

class PhotoUnit: Mappable {
    
    var link: String?
    var isPrivate: Bool?
    var isApprove:Bool?
    var source: String?
    var thumb375x250Link: String?
    var thumb500x375Link: String?
    var thumb887x500Link: String?
    
    var caption: String?
    var alt: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    var distance: Float?
    
    required convenience init?(map: Map)
    {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        link                        <- map["link"]
        isPrivate                   <- map["isPrivate"]
        isApprove                   <- map["isApprove"]
        source                      <- map["source"]
        
        thumb375x250Link            <- map["thumb375x250Link"]
        thumb500x375Link            <- map["thumb500x375Link"]
        thumb887x500Link            <- map["thumb887x500Link"]
        
        caption                     <- map["caption"]
        alt                         <- map["alt"]
        longitude                   <- map["longitude"]
        latitude                    <- map["latitude"]
        distance                    <- map["distance"]
    }
}
