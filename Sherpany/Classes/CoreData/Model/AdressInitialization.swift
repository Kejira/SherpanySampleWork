//
//  AdressInitialization.swift
//  Sherpany
//
//  Created by Ramona Vincenti on 02.07.16.
//  Copyright © 2016 rvi. All rights reserved.
//

import Foundation
import CoreData

extension Suite {
    class func createOrUpdateSuite(suiteName: String, inContext context: NSManagedObjectContext) throws -> Suite {
        var suite: Suite!
        
        let fetchRequest = NSFetchRequest(entityName: suiteModel)
        fetchRequest.predicate = NSPredicate(format: "suite == '\(suiteName)'")
        
        if let suites = try context.executeFetchRequest(fetchRequest) as? [Suite] where
            suites.count == 1 {
            suite = suites[0]
        }
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(suiteModel, inManagedObjectContext: context)!
            suite = Suite(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        suite.suite = suiteName
        
        return suite
    }
}

extension Adress {
    class func createOrUpdateAdress(adressName: String, lat: Float?, long: Float?, inContext context: NSManagedObjectContext) throws -> Adress {
        var adress: Adress!
        
        let fetchRequest = NSFetchRequest(entityName: adressModel)
        fetchRequest.predicate = NSPredicate(format: "adress == '\(adressName)'")
        
        if let adresses = try context.executeFetchRequest(fetchRequest) as? [Adress] where
            adresses.count == 1 {
            adress = adresses[0]
        }
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(adressModel, inManagedObjectContext: context)!
            adress = Adress(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        adress.adress = adressName
        if let lat = lat {
            adress.lat = NSNumber(float: lat)
        }
        if let long = long {
            adress.long = NSNumber(float: long)
        }
        
        return adress
    }
}

extension Zip {
    class func createOrUpdateZip(zipCode: String, inContext context: NSManagedObjectContext) throws -> Zip {
        var zip: Zip!
        
        let fetchRequest = NSFetchRequest(entityName: zipModel)
        fetchRequest.predicate = NSPredicate(format: "code == '\(zipCode)'")
        
        if let zipCodes = try context.executeFetchRequest(fetchRequest) as? [Zip] where
            zipCodes.count == 1 {
            zip = zipCodes[0]
        }
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(zipModel, inManagedObjectContext: context)!
            zip = Zip(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        zip.code = zipCode
        
        return zip
    }
}

extension City {
    class func createOrUpdateCity(cityName: String, inContext context: NSManagedObjectContext) throws -> City {
        var city: City!
        
        let fetchRequest = NSFetchRequest(entityName: cityModel)
        fetchRequest.predicate = NSPredicate(format: "name == '\(cityName)'")
        
        if let cities = try context.executeFetchRequest(fetchRequest) as? [City] where
            cities.count == 1 {
            city = cities[0]
        }
        else {
            // create the user as it does not exist yet.
            let entityDescription = NSEntityDescription.entityForName(cityModel, inManagedObjectContext: context)!
            city = City(entity: entityDescription, insertIntoManagedObjectContext: context)
        }
        
        city.name = cityName
        
        return city
    }
}