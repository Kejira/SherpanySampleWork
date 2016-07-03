//
//  Post+initialization.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import CoreData

extension Post {
    
    class func createOrUpdatePost(id: Int, userId: Int, title: String, body: String, inContext context: NSManagedObjectContext) throws -> Post {
        var post: Post!
        
        let fetchRequest = NSFetchRequest(entityName: postModel)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        if let posts = try context.executeFetchRequest(fetchRequest) as? [Post] where
            posts.count == 1 {
            post = posts[0]
        }
            
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(postModel, inManagedObjectContext: context)!
            post = Post(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        post.id = NSNumber(integer: id)
        post.title = title
        post.body = body
        post.isUpToDate = NSNumber(bool: true)
        
        let userFetchRequest = NSFetchRequest(entityName: userModel)
        userFetchRequest.predicate = NSPredicate(format: "id == \(userId)")
        
        if let users = try context.executeFetchRequest(userFetchRequest) as? [User] where
            users.count == 1 {
            let user = users[0]
            post.user = user
        }
        else {
            // delete this post again as we do not have the corresponding user!
            context.deleteObject(post)
            throw CoreDataInitializationError.userNotFound
        }
        
        return post
    }
    
}