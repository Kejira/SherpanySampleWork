//
//  Zip+CoreDataProperties.swift
//  
//
//  Created by Ramona Vincenti on 02.07.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Zip {

    @NSManaged var code: String?
    @NSManaged var adresses: NSSet?
    @NSManaged var city: NSManagedObject?

}
