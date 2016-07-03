//
//  DataController+PhotoRemoteInit.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import CoreData

extension DataController {
    func createPhotosFromRemote(collection: NSArray) {
        let context = createPrivateContext()
        
        context.performBlockAndWait {
            do {
                try self.markPhotosAsBeingUpdated(context)
                _ = try collection.map({ (photo) -> Photo in
                    return try self.createPhoto(photo as! NSDictionary, inContext: context)
                })
                try self.deleteOutdatedPhotos(context)
                try context.save()
            }
            catch {
                print("failed to saved data")
            }
        }
    }
    
    func markPhotosAsBeingUpdated(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: photoModel)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let photos = try context.executeFetchRequest(fetchRequest) as? [Photo] {
            for photo in photos {
                photo.isUpToDate = NSNumber(bool: false)
            }
        }
    }
    
    func deleteOutdatedPhotos(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: photoModel)
        fetchRequest.predicate = NSPredicate(format: "isUpToDate == false")
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let outdatedPhotos = try context.executeFetchRequest(fetchRequest) as? [Album] {
            for photo in outdatedPhotos {
                context.deleteObject(photo)
            }
        }
    }
    
    func createPhoto(userDictionary: NSDictionary, inContext context: NSManagedObjectContext) throws -> Photo {
        guard let id =  userDictionary["id"] as? Int,
            let albumId = userDictionary["albumId"] as? Int,
            let title = userDictionary["title"] as? String,
            let url = userDictionary["url"] as? String,
            let thumbnailUrl = userDictionary["thumbnailUrl"] as? String else {
                throw CoreDataInitializationError.invalidPhotoData
        }
        
        let photo = try Photo.createOrUpdatePhoto(id, albumId: albumId, thumbnailUrl: thumbnailUrl, url: url, title: title, inContext: context)
        
        return photo
    }
}
