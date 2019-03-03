//
//  FlickrPhoto.swift
//  SwiftApp
//
//  Created by Dylan Bui on 3/1/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation
import UIKit

struct FlickrSearchResults {
    let searchTerm : String = ""
    var searchResults = [FlickrPhoto]()
}

class FlickrPhoto : Equatable {
    let photoID : String
    let farm : Int
    let server : String
    let secret : String
    
    init (photoID:String,farm:Int, server:String, secret:String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
    func flickrImageURL(_ size:String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
    
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
    return lhs.photoID == rhs.photoID
}

public class Paging {
    
    // MARK: Properties
    public var totalPages: Int?
    public var numberOfElements: Int32?
    public var currentSize: Int = 20
    public var currentPage: Int?
    
    init(totalPages: Int, elements: Int32, currentPage: Int) {
        self.totalPages = totalPages
        self.numberOfElements = elements
        self.currentPage = currentPage
    }
}
