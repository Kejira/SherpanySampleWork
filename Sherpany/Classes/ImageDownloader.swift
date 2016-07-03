//
//  ImageDownloader.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import Alamofire

class ImageDownloader {
    
    static let sharedInstance = ImageDownloader()
    
    func loadImage(url: String, completion: (image: UIImage?) -> Void) {
        request(.GET,url).response(){
            (_, _, data, _) in
            let image = UIImage(data: data! as NSData)
            // save image to disk in cache
            completion(image: image)
        }
    }
    
    func saveImageToCache(data: NSData?, imageName: String) {
        if let data = data {
            
            let urlString = fileInCachesDirectory(imageName)
            
            do {
                try data.writeToFile(urlString, options: NSDataWritingOptions.AtomicWrite)
            }
            catch {
                print("save image failed")
            }
        }
    }
    
    
    func getCachesURL() -> NSURL {
        let cacheURL = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
        return cacheURL
    }
    
    func fileInCachesDirectory(filename: String) -> String {
        let fileURL = getCachesURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
}