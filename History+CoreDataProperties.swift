//
//  History+CoreDataProperties.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var startupName: String?
    @NSManaged @objc(isFavorite) var isFavorite: Bool
    

}
