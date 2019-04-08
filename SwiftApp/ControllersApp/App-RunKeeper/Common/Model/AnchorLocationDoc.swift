//
//  AnchorLocationDoc.swift
//  SwiftApp
//
//  Created by Dylan Bui on 4/8/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import ObjectMapper

class AnchorLocationDoc: DbrmObjectMappable // , CustomStringConvertible
{
    @objc dynamic var anchorId: Int = -1
    @objc dynamic var anchorName: String = ""
    
    override class func primaryKey() -> String?
    {
        return "anchorId"
    }
    
    convenience init(anchorId: Int, anchorName: String)
    {
        self.init()
        self.anchorId = anchorId
        self.anchorName = anchorName
    }
    
    required convenience init?(map: Map)
    {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        anchorId                    <- map["anchorId"]
        anchorName                   <- map["anchorName"]
    }
    
    override public var description: String
    {
        return self.toJSONString()!
        // return "Response data: \(String(describing: representation))"
    }
}
