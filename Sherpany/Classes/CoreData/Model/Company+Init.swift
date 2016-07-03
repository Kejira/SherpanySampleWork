//
//  Company+Init.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import CoreData

extension Company {
    class func createOrUpdateCompany(companyName: String, catchPhrase: String?, bs: String?, inContext context: NSManagedObjectContext) throws -> Company {
        var company: Company!
        
        let fetchRequest = NSFetchRequest(entityName: companyModel)
        fetchRequest.predicate = NSPredicate(format: "name == '\(companyName)'")
        
        if let companies = try context.executeFetchRequest(fetchRequest) as? [Company] where
            companies.count == 1 {
            company = companies[0]
        }
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(companyModel, inManagedObjectContext: context)!
            company = Company(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        company.name = companyName
        company.catchPhrase = catchPhrase
        company.bs = bs
        
        return company
    }
}