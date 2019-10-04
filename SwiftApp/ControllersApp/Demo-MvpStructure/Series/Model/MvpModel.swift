//
//  MvpModel.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/4/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

struct MvpComic
{
    let name: String
    let coverURL: URL?
}

class MvpSeries
{

    let name: String
    let coverURL: URL?
    let rating: String
    let description: String
    let comics: [MvpComic]

    init(name: String, coverURL: URL? = nil, rating: String = "",
         description: String = "", comics: [MvpComic] = [MvpComic]())
    {
        self.name = name
        self.coverURL = coverURL
        self.rating = rating
        self.description = description
        self.comics = comics
    }
}
