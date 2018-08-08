//
//  pzListingItem.swift
//  SwiftApp
//
//  Created by Dylan Bui on 8/6/18.
//  Copyright © 2018 Propzy Viet Nam. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON


class PzListingPhotoItem: Mappable {
    var link: String?
    var caption: String?
    var thumb1200Link: String?
    var thumb830Link: String?
    var thumb375Link: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        link    <- map["link"]
        caption         <- map["caption"]
        thumb1200Link      <- map["thumb1200Link"]
        thumb830Link       <- map["thumb830Link"]
        thumb375Link  <- map["thumb375Link"]
    }
}

class PzListingItem: DbRealmObject
{
    // -- Realm field --
    @objc dynamic var diyId: Int = -1
    @objc dynamic var rlistingId: Int = -1
    @objc dynamic var latitude: Float = 0
    @objc dynamic var longitude: Float = 0
    
    @objc dynamic var listingTypeId: Int = -1
    @objc dynamic var propertyTypeId: Int = -1
    
    @objc dynamic var address: String = ""
    @objc dynamic var houseNumberRoad: String = ""
    
    @objc dynamic var jsonPhotos: String = "[]"
    
    // -- Dont save Realm --
    var arrPhotos: [PzListingPhotoItem] = []
    
    override class func primaryKey() -> String? {
        return "diyId"
    }
    
//    convenience required init() {
//        self.init()
//    }
    
    required convenience init?(map: Map) {
        //fatalError("init(map:) has not been implemented")
        self.init()
        
//        print("-----------")
//        print(map["photos"])
//        print("-----------")
        
        self.mapping(map: map)
    }
    
    /// Initializes object from a JSON Dictionary
//    public init?(JSON: [String: Any], context: MapContext? = nil) {
//        super.init(JSON, context)
////        if let obj: Self = Mapper(context: context).map(JSON: JSON) {
////            self = obj
////        } else {
////            return nil
////        }
//    }


    
    override func mapping(map: Map)
    {

//        map["photos"].JSON
//        print( Mapper.toJSONString(map["photos"], prettyPrint: true)!)
//        let a = Map(mappingType: .toJSON, JSON: map["photos"].JSON)
        
//        let json = JSON(map["photos"].JSON)
//        print("json.rawString() = " + json.rawString()!)
        
//        let a = Mapper<ImmutableMappable>(map["photos"].JSON)
        
        
        
        
        super.mapping(map: map)
        // -- Chi co 1 cach nay de cuu do loi primaryKey --
        if map.mappingType == .fromJSON {
            diyId                       <- map["diyId"]
            rlistingId                  <- map["rlistingId"]
            latitude                    <- map["latitude"]
            longitude                   <- map["longitude"]
            listingTypeId               <- map["listingTypeId"]
            propertyTypeId              <- map["propertyTypeId"]
            address                     <- map["address"]
            houseNumberRoad             <- map["houseNumberRoad"]
            arrPhotos                   <- map["photos"]

            // -- Convert array -> json --
            jsonPhotos = arrPhotos.toJSONString() ?? "[]"
            
//            jsonPhotos                      <- Mapper.toJSONString(map["photos"].JSON, prettyPrint: true)!
//            jsonPhotos                  <- (map["photos"], JsonStringTransform())
        } else { // .toJSON
            // -- Convert json -> array --
            arrPhotos = Array<PzListingPhotoItem>(JSONString: jsonPhotos) ?? []
            
            diyId                       >>> map["diyId"]
            rlistingId                  >>> map["rlistingId"]
            latitude                    >>> map["latitude"]
            longitude                   >>> map["longitude"]
            listingTypeId               >>> map["listingTypeId"]
            propertyTypeId              >>> map["propertyTypeId"]
            address                     >>> map["address"]
            houseNumberRoad             >>> map["houseNumberRoad"]
            arrPhotos                   >>> map["photos"]
        }
        
//        let j = JSON(arrPhotos)
//        jsonPhotos = j.rawString(.utf8, options: .prettyPrinted) ?? "[none]"
//
////        arrPhotos.toJSONString(prettyPrint: true)
//
//        let aaa = ["so 1": "soooooo", "so 2": "soooooo", "so 3": "soooooo", "so 4": "soooooo"]
//        let bbb = ["so 1", "so 2"]
//        let ccc = [
//            ["so 1": "soooooo", "so 2": "soooooo", "so 3": "soooooo", "so 4": "soooooo"],
//            ["so 1": "soooooo", "so 2": "soooooo", "so 3": "soooooo", "so 4": "soooooo"],
//            ["so 1": "soooooo", "so 2": "soooooo", "so 3": "soooooo", "so 4": "soooooo"]
//        ]
//        
//        print(aaa.db_jsonString()!)
//        print(bbb.db_jsonString(prettify: true)!)
//        print(ccc.db_jsonString()!)
//
//
//        let json = arrPhotos.toJSONString() ?? "[]"
//
//        print("-----------")
//        print(json)
//        print("-----------")
//
//        let photos = Array<PzListingPhotoItem>(JSONString: json)
//        print("-----photosphotosphotos ------")
//        print(photos ?? "[none mang]")
//        print("-----photosphotosphotos ------")
        
        
//        let parsedMapperString = Mapper<PzListingPhotoItem>.parseJSONString(JSONString: jsonPhotos) //result is string from json serializer
//
//        let str = j.rawString(.utf8, options: .prettyPrinted)
//
//        print("-----------")
//        print(str)
//        print("-----------")
        
//        let a = Mapper.toJSONString(arrPhotos, prettyPrint: true)
        
        
//        print(Mapper.toJSONString(arrPhotos, prettyPrint: true)?)
        
//        -- Chuyen cac loai wa json
//        let j = JSON(arrPhotos)
//        jsonPhotos = j.rawString(.utf8, options: .prettyPrinted) ?? "[none]"
        
    }

}
