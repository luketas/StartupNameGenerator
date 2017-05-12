//
//  AppDelegate.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        self.verifyIfKeywordsIsPopulated()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StartupNameGenerator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func verifyIfKeywordsIsPopulated() {
        let context: NSManagedObjectContext? = persistentContainer.viewContext
        let error: Error? = nil
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        fetchRequest.includesSubentities = false
        fetchRequest.returnsObjectsAsFaults = false
        let keywordsCount: Int? = try! context?.count(for: fetchRequest)
        if error != nil {
            print("Erro ao verificar quantidade de palavras-chave. ERROR")
        }
        if keywordsCount! > 0 {
            return
        }
        populateKeywordList()
        
    }
    
    
    func populateKeywordList() {
        
        let context: NSManagedObjectContext? = persistentContainer.viewContext
        var error: Error? = nil
        let keywordListFilePath: String? = Bundle.main.path(forResource: "keyword-list", ofType: "csv")
        if keywordListFilePath == nil {
            return
        }
        let fileContents = try? String(contentsOfFile: keywordListFilePath!, encoding: String.Encoding.utf8)
        if error != nil {
            print("Não foi possível acessar o arquivo da lista de palavras-chave. ERROR")
        }
        let rows: [String]? = fileContents?.components(separatedBy: "\n")
        for row: String in rows! {
            var columns: [String] = row.components(separatedBy: ",")
            let name: String = columns[0]
            let type: String = columns[1]
            print("added keyword \(name) with type \(type) to database")
            let keyword = Keyword.createInManagedObjectContext(moc: context!, name: name, type: Int16(type)!)
            self.saveContext()
        }
        error = nil
     
        context?.reset()
        
}
}

