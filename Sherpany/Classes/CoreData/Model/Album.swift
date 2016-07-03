//
//  Album.swift
//  
//
//  Created by Ramona Vincenti on 02.07.16.
//
//

import Foundation
import CoreData

let albumModel = "Album"

class Album: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func sortedPhotos() -> [Photo] {
        if let unsortedPhotos = photos as? Set<Photo> {
            return unsortedPhotos.sort({ (photo1, photo2) -> Bool in
                return photo1.id?.integerValue < photo2.id?.integerValue
            })
        }
        return [Photo]()
    }
}
