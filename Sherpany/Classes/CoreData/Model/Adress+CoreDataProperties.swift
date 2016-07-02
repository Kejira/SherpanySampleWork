//
//  Adress+CoreDataProperties.swift
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

extension Adress {

    @NSManaged var adress: String?
    @NSManaged var lat: NSNumber?
    @NSManaged var long: NSNumber?
    @NSManaged var suits: NSSet?
    @NSManaged var zip: Zip?

}
