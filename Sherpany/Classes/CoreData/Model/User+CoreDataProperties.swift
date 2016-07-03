//
//  User+CoreDataProperties.swift
//  
//
//  Created by Ramona Vincenti on 03.07.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    @NSManaged var fullName: String?
    @NSManaged var id: NSNumber?
    @NSManaged var phone: String?
    @NSManaged var username: String?
    @NSManaged var isUpToDate: NSNumber?
    @NSManaged var albums: NSSet?
    @NSManaged var company: Company?
    @NSManaged var posts: NSSet?
    @NSManaged var suite: Suite?
    @NSManaged var website: Website?

}
