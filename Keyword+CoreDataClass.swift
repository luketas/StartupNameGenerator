//
//  Keyword+CoreDataClass.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import CoreData

@objc(Keyword)
public class Keyword: NSManagedObject {
    
    func createKeywordEntry (name: String, type: Int16) {
        self.name = name
        self.type = type
    }
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, type: Int16) -> Keyword {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Keyword", into: moc) as! Keyword
        newItem.name = name
        newItem.type = type
        
        return newItem
    }

}
