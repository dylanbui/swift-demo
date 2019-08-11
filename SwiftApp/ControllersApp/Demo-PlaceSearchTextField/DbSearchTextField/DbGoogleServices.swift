//
//  DbGoogleServices.swift
//  Alamofire
//
//  Created by Dylan Bui on 7/29/19.
//  Tham khao neu muon tao them chuc nang https://github.com/tryWabbit/Google-Api-Helper
//  Da ho tro: the restrictions by bundle id same GooglePlaces (GMSPlacesClient)
/* => Khi dang ky su dung cac Library API
 Places API => Search Adrresss, auto complete address by text use Http
 Geocoding API => Convert coordinater to address
 Maps SDK for iOS => Show map for ios
 Places SDK for iOS => use GooglePlaces (GMSPlacesClient)
 
 Khi tao key tai muc "Application restrictions" => chon "iOS app", them cac bundle id app duoc phep su dung key nay
 */


import Foundation
import UIKit
import CoreLocation

public let ErrorDomain: String! = "GooglePlacesAutocompleteErrorDomain"

public struct GgLocationBias
{
    public let latitude: Double
    public let longitude: Double
    public let radius: Int
    
    public init(latitude: Double = 0, longitude: Double = 0, radius: Int = 20000000) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
    }
    
    public var location: String {
        return "\(latitude),\(longitude)"
    }
}

public enum GgPlaceType: CustomStringConvertible
{
    case All
    case Geocode
    case Address
    case Establishment
    case Regions
    case Cities
    
    public var description : String {
        switch self {
        case .All: return ""
        case .Geocode: return "geocode"
        case .Address: return "address"
        case .Establishment: return "establishment"
        case .Regions: return "(regions)"
        case .Cities: return "(cities)"
        }
    }
}

open class GgPlace: CustomStringConvertible
{
    public var placeId: String {
        get {
            return rawData["place_id"] as? String ?? ""
        }
    }
    
    public var name: String {
        get {
            guard let terms = rawData["terms"] as? [[String: Any]] else {
                return "noname"
            }
            return terms.first?["value"] as? String ?? ""
        }
    }
    
    public var descriptionPlace: String {
        get {
            return rawData["description"] as? String ?? ""
        }
    }
    
    public var mainAddress: String {
        get {
            return rawData[db_keyPath: "structured_formatting.main_text"] as? String ?? ""
        }
    }
    
    public var secondaryAddress: String {
        get {
            return rawData[db_keyPath: "structured_formatting.secondary_text"] as? String ?? ""
        }
    }
    
    public let rawData: [String: Any]
    
    public init(prediction: [String: Any])
    {
        self.rawData = prediction
    }
    
    // CustomStringConvertible
    public var description: String
    {
        return String(describing: self.rawData)
    }
}

public enum GgPlaceDetailAddressType: String
{
    case kGGPlaceDetailCustomWard = "custom_ward" // Lay ward tu component va formattedAddress
    case kGGPlaceDetailAddress = "custom_address" // My custom variable
    
    case kGGPlaceDetailPoint = "establishment|point_of_interest|premise" // or ["establishment","point_of_interest", "premise"]
    case kGGPlaceDetailStreetNumber = "street_number"
    case kGGPlaceDetailRouter = "route"
    case kGGPlaceDetailWard = "administrative_area_level_3|sublocality_level_1"
    case kGGPlaceDetailDistrict = "administrative_area_level_2"
    case kGGPlaceDetailCity = "administrative_area_level_1"
    case kGGPlaceDetailCountry = "country"
}

open class GgPlaceDetail: CustomStringConvertible
{
    public var placeId: String {
        get {
            return rawData["place_id"] as? String ?? ""
        }
    }
    
    public var name: String {
        get {
            return rawData["name"] as? String ?? "noname"
        }
    }
    
    public var formattedAddress: String {
        get {
            return rawData["formatted_address"] as? String ?? "no_formattedAddress"
        }
    }
    
    public var addressComponents: [[String: Any]] {
        get {
            return rawData["address_components"] as? [[String: Any]] ?? []
        }
    }
    
    public var location: CLLocation {
        get {
            // Mac dinh la 0 => bay ra bien
            let latitude = rawData[db_keyPath: "geometry.location.lat"] as? Double ?? 0
            let longitude = rawData[db_keyPath: "geometry.location.lng"] as? Double ?? 0
            return CLLocation.init(latitude: latitude, longitude: longitude)
        }
    }
    
    public let rawData: [String: Any]
    
    public init(json: [String: Any])
    {
        self.rawData = json
    }
    
    /* 3 dang tra ve khac nhau
     https://maps.googleapis.com/maps/api/geocode/json?language=vi&latlng=10.764261,106.656312&key=AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg&sensor=true
     https://maps.googleapis.com/maps/api/geocode/json?latlng=10.76405330,106.66534580&sensor=true&key=AIzaSyD3EsqI4t_sH7GK1Il8fcG6rEe2EKxdPDQ
     https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyDiMjnPpWQWVXndV-E1WnfEuW1g593BLhg&language=vi&sensor=true&latlng=10.763821,106.656317
     */
    public func getAddressComponentsWithDefines(_ keyType: GgPlaceDetailAddressType) -> String
    {
        if keyType == .kGGPlaceDetailAddress {
            let router = self.getAddressComponentsWithDefines(.kGGPlaceDetailRouter)
            let point = self.getAddressComponentsWithDefines(.kGGPlaceDetailPoint)
            if point != "" {
                return (router != "") ? "\(point), \(router)" : point
            }
            // -- StreetNumber --
            let number = self.getAddressComponentsWithDefines(.kGGPlaceDetailStreetNumber)
            return (router != "") ? "\(number) \(router)" : number
        }
        
        if keyType == .kGGPlaceDetailCustomWard {
            let wardName = self.getAddressComponentsWithDefines(.kGGPlaceDetailWard)
            if wardName.isEmpty {
                let fullAddressComponent: [String] = self.formattedAddress.components(separatedBy: ", ")
                if fullAddressComponent.count > 2 {
                    return fullAddressComponent[1] // lay ra phuong neu khong tim duoc tu address_components
                }
                return ""
            }
            
            return wardName
        }
        
        for dictComponents in self.addressComponents {
            let types: [String] = dictComponents["types"] as? [String] ?? []
            let keysSet: Set<String> = Set(keyType.rawValue.components(separatedBy: ["|"]))
            
            let temp = keysSet.intersection(types)
            if temp.count > 0 {
                return dictComponents["long_name"] as? String ?? ""
            }
        }
        
        return ""
    }
    
    // CustomStringConvertible
    public var description: String
    {
        return "PlaceDetails: " + String(describing: self.rawData)
    }
}

// MARK: - DbGoogleServices
// MARK: -

open class DbGoogleServices
{
    public var placeType: GgPlaceType
    
    public static var shared: DbGoogleServices
    {
        struct Singleton {
            static let instance = DbGoogleServices()
        }
        return Singleton.instance
    }
    
    private init()
    {
        self.placeType = .All
    }
    
    private static var apiKey: String?
    private static var securityByBundleId: String?
    
    public static func provideAPI(Key key:String, BundleId: String? = nil)
    {
        DbGoogleServices.apiKey = key
        DbGoogleServices.securityByBundleId = BundleId
    }
    
    public func requestPlaces(_ searchString: String, result: @escaping (([GgPlace]) -> Void))
    {
        self.requestPlaces(searchString, locationBias: nil, result: result)
    }
    
    public func requestPlaces(_ searchString: String, locationBias: GgLocationBias?, result: @escaping (([GgPlace]) -> Void))
    {
        if (searchString == "") {
            return
        }
        
        var params = [
            "input": searchString,
            "types": self.placeType.description,
            "components": "country:VN"
        ]
        
        if let bias = locationBias {
            params["location"] = bias.location
            params["radius"] = bias.radius.description
        }
        
        self.doRequest(
            url: "https://maps.googleapis.com/maps/api/place/autocomplete/json",
            params: params as [String : Any]
        ) { json, error in
            if let json = json {
                if let predictions = json["predictions"] as? Array<[String: Any]> {
                    let places = predictions.map { (prediction: [String: Any]) -> GgPlace in
                        return GgPlace(prediction: prediction)
                    }
                    // self.delegate?.placesFound?(self.places)
                    result(places)
                }
            }
        }
        
    }
    
    public func requestPlaceDetail(_ placeId: String, result: @escaping ((GgPlaceDetail) -> Void))
    {
        self.doRequest(
            url: "https://maps.googleapis.com/maps/api/place/details/json",
            params: [
                "placeid": placeId,
                "components": "country:VN"
            ]
        ) { json, error in
            if let json = json {
                if let resultJson = json["result"] as? [String: Any] {
                    result(GgPlaceDetail(json: resultJson))
                }
            }
            if let error = error {
                // TODO: We should probably pass back details of the error
                print("Error fetching google place details: \(error)")
            }
        }
    }
    
    public func retrieveAddressInfoFromAddress(_ strAddress: String, withCompletion result: @escaping ((GgPlaceDetail) -> Void))
    {
        self.doRequest(
            url: "https://maps.googleapis.com/maps/api/geocode/json",
            params: [
                "address": strAddress
            ]
        ) { json, error in
            if let json = json {
                if let resultJson = json["results"] as? [[String: Any]] {
                    result(GgPlaceDetail(json: resultJson.first!))
                }
            }
            if let error = error {
                // TODO: We should probably pass back details of the error
                print("Error fetching google place details: \(error)")
            }
        }
    }
    
    public func retrieveAddressInfoFromLocation(_ location: CLLocationCoordinate2D, withCompletion result: @escaping ((GgPlaceDetail) -> Void))
    {
        self.doRequest(
            url: "https://maps.googleapis.com/maps/api/geocode/json",
            params: [
                "latlng": "\(location.latitude),\(location.longitude)"
            ]
        ) { json, error in
            if let json = json {
                if let resultJson = json["results"] as? [[String: Any]] {
                    result(GgPlaceDetail(json: resultJson.first!))
                }
            }
            if let error = error {
                // TODO: We should probably pass back details of the error
                print("Error fetching google place details: \(error)")
            }
        }
    }
    
    /**
     Build a query string from a dictionary
     - parameter parameters: Dictionary of query string parameters
     - returns: The properly escaped query string
     */
    private func query(_ parameters: [String: Any]) -> String
    {
        let escape = { (str: String) -> String in
            return str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        
        var components: [(String, String)] = []
        for key in Array(parameters.keys) {
            if let value = parameters[key] as? String {
                components += [(escape(key), escape("\(value)"))]
            }
            //let value: Any! = parameters[key]
        }
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator:"&")
    }
    
//    private func escape(_ string: String) -> String
//    {
//        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//    }
    
    public func doRequest(url: String, params: [String: Any], completion: @escaping ([String: Any]?, Error?) -> ())
    {
        guard let apiKey = DbGoogleServices.apiKey else {
            fatalError("Enter Google API Key.")
        }
        
        // -- Default value --
        var paramsVal = params
        paramsVal["key"] = apiKey
        paramsVal["language"] = "vi"
        paramsVal["sensor"] = "true"
        
        var request = URLRequest(url: URL(string: url + "?" + self.query(paramsVal))!)
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        if let bundleId = DbGoogleServices.securityByBundleId {
            request.httpMethod = "POST"
            request.addValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
            // request.addValue("servicecontrol.googleapis.com/vn.propzy.SwiftApp", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        }
        
        print("absoluteString = \(request.url?.absoluteString ?? "")")
        print("method = \(request.httpMethod ?? "")")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            self.handleResponse(data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    private func handleResponse(_ data: Data!, response: URLResponse!, error: Error!,
                                      completion: @escaping ([String: Any]?, Error?) -> ())
    {
        // Always return on the main thread...
        let done: (([String: Any]?, Error?) -> Void) = { (json, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(json, error)
            }
        }
        
        if let error = error {
            print("GooglePlaces Error: \(error.localizedDescription)")
            done(nil,error)
            return
        }
        
        if response == nil {
            print("GooglePlaces Error: No response from API")
            let error = NSError(domain: ErrorDomain, code: 1001, userInfo: [NSLocalizedDescriptionKey:"No response from API"])
            done(nil,error)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                print("GooglePlaces Error: Invalid status code \(httpResponse.statusCode) from API")
                let error = NSError(domain: ErrorDomain, code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                done(nil, error)
                return
            }
        }
        
        let json: [String: Any]?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any]
            
        } catch {
            print("Serialisation error")
            let serialisationError = NSError(domain: ErrorDomain, code: 1002, userInfo: [NSLocalizedDescriptionKey:"Serialization error"])
            done(nil, serialisationError)
            return
        }
        
        if let status = json?["status"] as? String {
            if status != "OK" {
                print("GooglePlaces API Error: \(status)")
                let error = NSError(domain: ErrorDomain, code: 1002, userInfo: [NSLocalizedDescriptionKey:status])
                done(nil, error)
                return
            }
        }
        
        done(json, nil)
    }
}




