//
//  Post+CoreDataProperties.swift
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

extension Post {

    @NSManaged var body: String?
    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var isUpToDate: NSNumber?
    @NSManaged var user: User?

}
