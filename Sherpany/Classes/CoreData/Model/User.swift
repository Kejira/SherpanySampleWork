//
//  User.swift
//  
//
//  Created by Ramona Vincenti on 02.07.16.
//
//

import Foundation
import CoreData

let userModel = "User"

class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func sortedAlbums() -> [Album] {
        if let unsortedAlbums = albums as? Set<Album> {
            return unsortedAlbums.sort({ (album1, album2) -> Bool in
                return album1.id?.integerValue < album2.id?.integerValue
            })
        }
        return [Album]()
    }
    
}
