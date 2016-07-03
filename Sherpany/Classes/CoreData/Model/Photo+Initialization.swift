//
//  Photo+Initialization.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import UIKit
import CoreData

extension Photo {
    
    class func createOrUpdatePhoto(id: Int, albumId: Int, thumbnailUrl: String, url: String, title: String, inContext context: NSManagedObjectContext) throws -> Photo {
        var photo: Photo!
        
        let fetchRequest = NSFetchRequest(entityName: photoModel)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        if let photos = try context.executeFetchRequest(fetchRequest) as? [Photo] where
            photos.count == 1 {
            photo = photos[0]
        }
            
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(photoModel, inManagedObjectContext: context)!
            photo = Photo(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        photo.id = NSNumber(integer: id)
        photo.thumbnailUrl = thumbnailUrl
        photo.url = url
        photo.title = title
        photo.isUpToDate = NSNumber(bool: true)
        
        if let thumbnail = photo.thumbnail where
            UIImage(named: thumbnail) == nil {
            photo.thumbnail = nil
        }
        
        let albumFetchRequest = NSFetchRequest(entityName: albumModel)
        albumFetchRequest.predicate = NSPredicate(format: "id == \(albumId)")
        
        if let albums = try context.executeFetchRequest(albumFetchRequest) as? [Album] where
            albums.count == 1 {
            let album = albums[0]
            photo.album = album
        }
        else {
            // delete this post again as we do not have the corresponding user!
            context.deleteObject(photo)
            throw CoreDataInitializationError.albumNotFound
        }
        
        return photo
    }
    
}
