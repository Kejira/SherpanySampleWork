//
//  Website+Init.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import CoreData

extension Website {
    class func createOrUpdateWebsite(websiteName: String, inContext context: NSManagedObjectContext) throws -> Website {
        var website: Website!
        
        let fetchRequest = NSFetchRequest(entityName: websiteModel)
        fetchRequest.predicate = NSPredicate(format: "url == '\(websiteName)'")
        
        if let websites = try context.executeFetchRequest(fetchRequest) as? [Website] where
            websites.count == 1 {
            website = websites[0]
        }
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(websiteModel, inManagedObjectContext: context)!
            website = Website(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        website.url = websiteName
        
        return website
    }
}