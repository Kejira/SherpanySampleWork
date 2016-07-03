//
//  Album+Initialization.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import CoreData

extension Album {
    
    class func createOrUpdateAlbum(id: Int, userId: Int, name: String, inContext context: NSManagedObjectContext) throws -> Album {
        var album: Album!
        
        let fetchRequest = NSFetchRequest(entityName: albumModel)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        if let albums = try context.executeFetchRequest(fetchRequest) as? [Album] where
            albums.count == 1 {
            album = albums[0]
        }
            
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(albumModel, inManagedObjectContext: context)!
            album = Album(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        album.id = NSNumber(integer: id)
        album.name = name
        album.isUpToDate = NSNumber(bool: true)
        
        let userFetchRequest = NSFetchRequest(entityName: userModel)
        userFetchRequest.predicate = NSPredicate(format: "id == \(userId)")
        
        if let users = try context.executeFetchRequest(userFetchRequest) as? [User] where
            users.count == 1 {
            let user = users[0]
            album.user = user
        }
        else {
            // delete this post again as we do not have the corresponding user!
            context.deleteObject(album)
            throw CoreDataInitializationError.userNotFound
        }
        
        return album
    }
    
}