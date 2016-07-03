//
//  DataController+UserRemoteInit.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import CoreData

extension DataController {
    
    func createUsersFromRemoteCollection(collection: NSArray) {
        let context = createPrivateContext()
        
        context.performBlock {
            do {
                try self.markUsersAsBeigUpdated(context)
                _ = try collection.map({ (user) -> User in
                    return try self.createUser(user as! NSDictionary, inContext: context)
                })
                try self.deleteOutdatedUser(context)
                try self.deleteOutdatedAdresses(context)
                try self.deleteOutdatedWebsites(context)
                try self.deleteOutdatedCompanies(context)
                try context.save()
            }
            catch {
                print("failed to saved data")
            }
            
            // load next
            JsonDownloader.sharedInstance.getPostsJson()
        }
    }
    
    func markUsersAsBeigUpdated(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: userModel)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let users = try context.executeFetchRequest(fetchRequest) as? [User] {
            for user in users {
                user.isUpToDate = NSNumber(bool: false)
            }
        }
    }
    
    func deleteOutdatedUser(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: userModel)
        fetchRequest.predicate = NSPredicate(format: "isUpToDate == false")
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let outdatedUsers = try context.executeFetchRequest(fetchRequest) as? [User] {
            for user in outdatedUsers {
                context.deleteObject(user)
            }
        }
    }
    
    func createUser(userDictionary: NSDictionary, inContext context: NSManagedObjectContext) throws -> User {
        guard let id =  userDictionary["id"] as? Int,
        let name = userDictionary["name"] as? String,
        let userName = userDictionary["username"] as? String,
        let email = userDictionary["email"] as? String,
        let phone = userDictionary["phone"] as? String,
        let adress = userDictionary["address"] as? NSDictionary,
        let company = userDictionary["company"] as? NSDictionary,
        let website = userDictionary["website"] as? String else {
            throw CoreDataInitializationError.invalidUserData
        }
        let user = try User.createOrUpdateUser(id, name: name, userName: userName, email: email, phone: phone, inContext: context)
        let suite = try createAdress(adress, inContext: context)
        let companyObject = try createCompany(company, inContext: context)
        let websiteObject = try Website.createOrUpdateWebsite(website, inContext: context)
        
        user.suite = suite
        user.company = companyObject
        user.website = websiteObject
        
        return user
    }
    
    func createAdress(adressDictionary: NSDictionary, inContext context: NSManagedObjectContext) throws -> Suite {
        guard let street = adressDictionary["street"] as? String,
            let suite = adressDictionary["suite"] as? String,
            let city = adressDictionary["city"] as? String,
            let zipCode = adressDictionary["zipcode"] as? String else {
                throw CoreDataInitializationError.invalidAdressData
        }
        
        var lat: Float? = nil
        var long: Float? = nil
        if let geo = adressDictionary["geo"] as? NSDictionary {
            lat = geo["lan"] as? Float
            long = geo["long"] as? Float
        }
        
        let suiteObject = try Suite.createOrUpdateSuite(suite, inContext: context)
        let adressObject = try Adress.createOrUpdateAdress(street, lat: lat, long: long, inContext: context)
        let zipObject = try Zip.createOrUpdateZip(zipCode, inContext: context)
        let cityObject = try City.createOrUpdateCity(city, inContext: context)
        
        suiteObject.adress = adressObject
        adressObject.zip = zipObject
        zipObject.city = cityObject
        
        return suiteObject
    }
    
    func createCompany(companyDictionary: NSDictionary, inContext context: NSManagedObjectContext) throws -> Company {
        guard let companyName = companyDictionary["name"] as? String else {
            throw CoreDataInitializationError.invalidCompanyData
        }
        let bs: String? = companyDictionary["bs"] as? String
        let catchPhrase: String? = companyDictionary["catchPhrase"] as? String
        
        let company = try Company.createOrUpdateCompany(companyName, catchPhrase: catchPhrase, bs: bs, inContext: context)
        
        return company
    }
    
    func deleteOutdatedAdresses(context: NSManagedObjectContext) throws {
        // begin with deleting suites wich do not have someone living in there
        let suitFetchRequest = NSFetchRequest(entityName: suiteModel)
        suitFetchRequest.predicate = NSPredicate(format: "users.@count == 0")
        suitFetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let suites = try context.executeFetchRequest(suitFetchRequest) as? [Suite] {
            for suite in suites {
                context.deleteObject(suite)
            }
        }
        
        // then search for adresses where no suite exists
        let adressFetchRequest = NSFetchRequest(entityName: adressModel)
        adressFetchRequest.predicate = NSPredicate(format: "suits.@count == 0")
        adressFetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let adresses = try context.executeFetchRequest(adressFetchRequest) as? [Adress] {
            for adress in adresses {
                context.deleteObject(adress)
            }
        }
        
        // after that search for zip codes where no adresses are inside
        let zipFetchRequest = NSFetchRequest(entityName: zipModel)
        zipFetchRequest.predicate = NSPredicate(format: "adresses.@count == 0")
        zipFetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let zipCodes = try context.executeFetchRequest(zipFetchRequest) as? [Zip] {
            for zipCode in zipCodes {
                context.deleteObject(zipCode)
            }
        }
        
        // at last delete the cities where no zip code is
        let citiesFetchRequest = NSFetchRequest(entityName: cityModel)
        citiesFetchRequest.predicate = NSPredicate(format: "postalCodes.@count == 0")
        citiesFetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let cities = try context.executeFetchRequest(citiesFetchRequest) as? [City] {
            for city in cities {
                context.deleteObject(city)
            }
        }
    }
    
    func deleteOutdatedWebsites(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: websiteModel)
        fetchRequest.predicate = NSPredicate(format: "users.@count == 0")
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let websites = try context.executeFetchRequest(fetchRequest) as? [Website] {
            for website in websites {
                context.deleteObject(website)
            }
        }
    }
    
    func deleteOutdatedCompanies(context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest(entityName: companyModel)
        fetchRequest.predicate = NSPredicate(format: "users.@count == 0")
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        if let companies = try context.executeFetchRequest(fetchRequest) as? [Company] {
            for company in companies {
                context.deleteObject(company)
            }
        }
    }
}