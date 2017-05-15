//
//  LocalDataManager.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/15/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class LocalDataManager {
    static let instance = LocalDataManager()
    
    private var _latestNames = [NSString]()
    private var _history = [History]()
    var words = [Any]()
    var managedObjectContext: NSManagedObjectContext!
    let currentDate = Date()
    var latestNames: [NSString] {
        return _latestNames
    }
    var history: [History] {
        return _history
    }
    
    func loadData() {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        do {
            self._history = try managedObjectContext.fetch(fetchRequest)
            self.sortList()
            
            
        } catch {
            ViewController().showToast(text: "Could not load data from database \(error.localizedDescription)")
        }
    }
    func saveChangesToDatabase() {
        do {
            try self.managedObjectContext.save()
            self.loadData()
        } catch {
            print(error)
        }
    }
    
    func createHistory(withStartupName: NSString) {
        let historyItem = History(context: managedObjectContext)
        historyItem.createHistoryEntry(name: withStartupName as String, createdAt: currentDate)
        
        do {
            try self.managedObjectContext.save()
            LocalDataManager.instance.loadData()
        } catch {
            ViewController().showToast(text: "Could not save data for item \(String(describing: historyItem.startupName)) \(error.localizedDescription)")
        }
        
    }
    
    func sortList() {
        //        history.sort { ($0.isFavorite && !$1.isFavorite)}
        //        history.sort {($0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedAscending)}
        _history = history.sorted { t1, t2 in
            if t1.isFavorite == t2.isFavorite {
                return t1.createdAt!.timeIntervalSince1970 < t2.createdAt!.timeIntervalSince1970
            }
            return t1.isFavorite && !t2.isFavorite
        }
    }
    
    func clearLatestNames() {
        self._latestNames.removeAll()
    }
    
    func addNewName(name: NSString) {
        self._latestNames.append(name)
    }
    
    func deleteNonFav() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest? = History.fetchRequest()
        var error: Error? = nil
        let historyList: [History]? = try! context?.fetch(fetchRequest!)
        if error != nil {
            ViewController().showToast(text: "Erro ao obter históricos")
        }
        for history: History in historyList! {
            if history.isFavorite == false {
                context?.delete(history)
                do {
                    try context?.save()
                    LocalDataManager.instance.loadData()
                } catch {
                    ViewController().showToast(text: "Could not save data for item")
                }
            }
            LocalDataManager.instance.loadData()
        }
    }
    
}
