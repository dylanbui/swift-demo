//
//  Post.swift
//  SwiftApp
//
//  Created by Dylan Bui on 9/27/17.
//  Copyright © 2017 Propzy Viet Nam. All rights reserved.
//

import UIKit
import ObjectMapper

class Post: Mappable
{
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
    
    required init?(map: Map)
    {
        
    }
    
    // Mappable
    func mapping(map: Map)
    {
        id                  <- map["id"]
        userId              <- map["userId"]
        title               <- map["title"]
        body                <- map["body"]
    }
    
    static func getAll(_ complete: @escaping ([Post]) -> ())
    {
        DbHttp.get(Url: "https://jsonplaceholder.typicode.com/posts") { (response) in
            
            if response.error != nil {
                // print("error.debugDescription = \(err.debugDescription)")
                return
            }
            
            guard let anyObject = response.rawData else {
                print("AnyObject = nil")
                return
            }

            var arr: [Post] = []
            for obj in anyObject as! [AnyObject] {
                let u:Post = Post(JSON: obj as! [String: Any])!
                arr.append(u)
            }
            complete(arr)
        }
        
//        DbWebConnection.shared.get(Url: "https://jsonplaceholder.typicode.com/posts", params: nil) { (anyObject, error) in
//            if error != nil {
//                print("error.debugDescription = \(error.debugDescription)")
//                return
//            }
//
//            guard let anyObject = anyObject else {
//                print("AnyObject = nil")
//                return
//            }
//
//            var arr: [Post] = []
//            for obj in anyObject as! [AnyObject] {
//                let u:Post = Post(JSON: obj as! [String: Any])!
//                arr.append(u)
//            }
//            complete(arr)
//        }
        
    }
    
    static func getByUser(_ user: User, complete: @escaping ([Post]) -> ())
    {
        let url = "https://jsonplaceholder.typicode.com/posts?userId=\(user.id!)"// + String(user.id!)
        print("url = " + url)
        
        DbHttp.get(Url: url) { (response) in
            
            if response.error != nil {
                // print("error.debugDescription = \(err.debugDescription)")
                return
            }
            
            guard let anyObject = response.rawData else {
                print("AnyObject = nil")
                return
            }

            var arr: [Post] = []
            for obj in anyObject as! [AnyObject] {
                let u:Post = Post(JSON: obj as! [String: Any])!
                arr.append(u)
            }
            complete(arr)
        }
        
//        DbWebConnection.shared.get(Url: url, params: nil) { (anyObject, error) in
//            if error != nil {
//                print("error.debugDescription = \(error.debugDescription)")
//                return
//            }
//
//            guard let anyObject = anyObject else {
//                print("AnyObject = nil")
//                return
//            }
//
//            var arr: [Post] = []
//            for obj in anyObject as! [AnyObject] {
//                let u:Post = Post(JSON: obj as! [String: Any])!
//                arr.append(u)
//            }
//            complete(arr)
//        }
    }
    
    static func getPostDetai(_ post: Post, complete: @escaping (Post) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts/\(post.id!)"// + String(post.id!)
        print("url = " + url)
        
        DbHttp.get(Url: url) { (response) in
            
            if response.error != nil {
                // print("error.debugDescription = \(err.debugDescription)")
                return
            }
            
            if response.rawData != nil {
                // print("response.rawData = nil")
                return
            }

            let post:Post = Post(JSON: response.rawData as! [String: Any])!
            complete(post)
        }
        
//        DbWebConnection.shared.get(Url: url, params: nil) { (anyObject, error) in
//            if error != nil {
//                print("error.debugDescription = \(error.debugDescription)")
//                return
//            }
//            
//            guard let anyObject = anyObject else {
//                print("AnyObject = nil")
//                return
//            }
//            
//            let post:Post = Post(JSON: anyObject as! [String: Any])!
//            complete(post)            
//        }
    }

}
