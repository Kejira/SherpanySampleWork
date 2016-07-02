//
//  Company+CoreDataProperties.swift
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

extension Company {

    @NSManaged var bs: String?
    @NSManaged var catchPhrase: String?
    @NSManaged var name: String?
    @NSManaged var users: NSSet?

}
