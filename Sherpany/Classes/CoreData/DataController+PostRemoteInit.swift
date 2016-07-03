//
//  DataController+PostRemoteInit.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 03.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import CoreData

extension DataController {
    //    func createPostsFromRemote
    func createPostsFromRemote(collection: NSArray) {
        let context = createPrivateContext()
        
        context.performBlockAndWait {
            do {
                try self.markPostsAsBeingUpdated(context)
                _ = try collection.map({ (post) -> Post in
                    return try self.createPost(post as! NSDictionary, inContext: context)
                })
                try self.deleteOutdatedPosts(context)
                try context.save()
            }
            catch {
                print("failed to saved data")
            }
        }
    }
    
    func markPostsAsBeingUpdated(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: postModel)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let posts = try context.executeFetchRequest(fetchRequest) as? [Post] {
            for post in posts {
                post.isUpToDate = NSNumber(bool: false)
            }
        }
    }
    
    func deleteOutdatedPosts(context: NSManagedObjectContext) throws {            let fetchRequest = NSFetchRequest(entityName: postModel)
        fetchRequest.predicate = NSPredicate(format: "isUpToDate == false")
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let outdatedPosts = try context.executeFetchRequest(fetchRequest) as? [Post] {
            for post in outdatedPosts {
                context.deleteObject(post)
            }
        }
    }
    
    func createPost(userDictionary: NSDictionary, inContext context: NSManagedObjectContext) throws -> Post {
        guard let id =  userDictionary["id"] as? Int,
            let userId = userDictionary["userId"] as? Int,
            let title = userDictionary["title"] as? String,
            let body = userDictionary["body"] as? String else {
                throw CoreDataInitializationError.invalidPostData
        }
        
        let post = try Post.createOrUpdatePost(id, userId: userId, title: title, body: body, inContext: context)
        
        return post
    }
}