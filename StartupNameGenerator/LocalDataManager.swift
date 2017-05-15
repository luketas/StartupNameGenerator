//
//  LocalDataManager.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/15/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import CoreData


class LocalDataManager {
    static let instance = LocalDataManager()
    
    private var latestNames = [History]()
    private var history = [History]()
    var managedObjectContext: NSManagedObjectContext!
    
    
}
