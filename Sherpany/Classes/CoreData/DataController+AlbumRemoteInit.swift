//
//  DataController+AlbumRemoteInit.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import CoreData

extension DataController {
    func createAlbumsFromRemote(collection: NSArray) {
        let context = createPrivateContext()
        
        context.performBlockAndWait {
            do {
                try self.markAlbumsAsBeingUpdated(context)
                _ = try collection.map({ (album) -> Album in
                    return try self.createAlbum(album as! NSDictionary, inContext: context)
                })
                try self.deleteOutdatedAlbums(context)
                try context.save()
            }
            catch {
                print("failed to saved data")
            }
        }
    }
    
    func markAlbumsAsBeingUpdated(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: albumModel)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let albums = try context.executeFetchRequest(fetchRequest) as? [Album] {
            for album in albums {
                album.isUpToDate = NSNumber(bool: false)
            }
        }
    }
    
    func deleteOutdatedAlbums(context: NSManagedObjectContext) throws {            let fetchRequest = NSFetchRequest(entityName: albumModel)
        fetchRequest.predicate = NSPredicate(format: "isUpToDate == false")
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let outdatedAlbums = try context.executeFetchRequest(fetchRequest) as? [Album] {
            for album in outdatedAlbums {
                context.deleteObject(album)
            }
        }
    }
    
    func createAlbum(userDictionary: NSDictionary, inContext context: NSManagedObjectContext) throws -> Album {
        guard let id =  userDictionary["id"] as? Int,
            let userId = userDictionary["userId"] as? Int,
            let title = userDictionary["title"] as? String else {
                throw CoreDataInitializationError.invalidAlbumData
        }
        
        let album = try Album.createOrUpdateAlbum(id, userId: userId, name: title, inContext: context)
        
        return album
    }
}
