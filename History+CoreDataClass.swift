//
//  History+CoreDataClass.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import CoreData

@objc(History)
public class History: NSManagedObject {

   
    
    func createHistoryEntry(name: String, createdAt: Date) {
        self.startupName = name
        self.createdAt = createdAt
    }
    func addToFavorites() {
        self.isFavorite = true
    }
    func removeFromFavorites() {
        self.isFavorite = false
    }
}
