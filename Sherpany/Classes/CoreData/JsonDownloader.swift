//
//  JsonDownloader.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import Alamofire

class JsonDownloader {
    
    static let sharedInstance = JsonDownloader()
    
    func loadData() {
        getUserJson() // other stuff will be loaded when finished!
    }
    
    func getUserJson() {
        getJson("http://jsonplaceholder.typicode.com/users") { response in
            if let error = response.result.error {
                // print error
            }
            if let JSON = response.result.value as? NSArray {
//                print("JSON: \(JSON)")
                // load JSON into Core Data
                DataController.sharedInstance.createUsersFromRemoteCollection(JSON)
            }
        }
    }
    
    func getPostsJson() {
        getJson("http://jsonplaceholder.typicode.com/posts/") { response in
            if let JSON = response.result.value as? NSArray {
//                print("JSON: \(JSON)")
                // load JSON into Core Data
                DataController.sharedInstance.createPostsFromRemote(JSON)
            }
        }
    }
    
    func getAlbumsJson() {
        getJson("http://jsonplaceholder.typicode.com/albums/") { response in
            if let JSON = response.result.value as? NSArray {
//                print("JSON: \(JSON)")
                // load JSON into Core Data
                DataController.sharedInstance.createAlbumsFromRemote(JSON)
            }
        }
    }
    
    func getPhotosJson() {
        getJson("http://jsonplaceholder.typicode.com/photos/") { response in
            if let JSON = response.result.value as? NSArray{
//                print("JSON: \(JSON)")
                // load JSON into Core Data
                DataController.sharedInstance.createPhotosFromRemote(JSON)
                
                // finished loading everything!
            }
        }
    }
    
    func getJson(url: String, completionHandler: Response<AnyObject, NSError> -> Void) {
        Alamofire.request(.GET, url).responseJSON(completionHandler: completionHandler)
    }
}