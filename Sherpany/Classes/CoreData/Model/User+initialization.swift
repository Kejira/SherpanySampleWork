//
//  User+initialization.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    class func createOrUpdateUser(id: Int, name: String, userName: String, email: String, phone: String, inContext context: NSManagedObjectContext) throws -> User {
        var user: User!
        
        let fetchRequest = NSFetchRequest(entityName: userModel)
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        
        if let users = try context.executeFetchRequest(fetchRequest) as? [User] where
            users.count == 1 {
            user = users[0]
        }
        
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(userModel, inManagedObjectContext: context)!
            user = User(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        user.fullName = name
        user.username = userName
        user.id = NSNumber(integer: id)
        user.email = email
        user.phone = phone
        user.isUpToDate = NSNumber(bool: true)
        
        return user
    }
    
}