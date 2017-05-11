//
//  ViewController.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import UIKit
import CoreData
import Foundation

enum KeywordType : Int {
    case wordPrefix = 1
    case wordSuffix
    case partialSuffix
}

private let CellIdentifier: String = "NameTableViewCell"



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var words = [Any]()
    var lastGenerationRunAt: Date?
    var managedObjectContext: NSManagedObjectContext!
    var history = [History]()
    let currentDate = NSDate()
    let formatter = DateFormatter()

    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var inputText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        nameTable.delegate = self
        nameTable.dataSource = self
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     //   loadData()

    }
    
  

    @IBAction func generateButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cleanupButtonTapped(_ sender: Any) {
    }
    
    //TableView protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! NameTableViewCell
        let entry = history[indexPath.row]
        cell.startupNameLbl.text = entry.startupName
        
        return cell
    }
    
    //Database interaction functions
    func loadData() {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        do {
            history = try managedObjectContext.fetch(fetchRequest)
            self.nameTable.reloadData()
        } catch {
            print ("Could not load data from database \(error.localizedDescription)")
        }
    }
    func addToFavorites(name: String, creationDate: NSDate) {
        let favoriteName = History(context: managedObjectContext)
        favoriteName.setFavoriteName(name: name, createdAt: creationDate)
        
        do {
            try self.managedObjectContext.save()
            self.loadData()
        } catch {
            print("Could not save data \(error.localizedDescription)")
        }
    }
    
    func createHistoryWithStartupName (startupName: NSString) {
        let historyItem = History(context: managedObjectContext)
        
        historyItem.createHistoryEntry(name: startupName as String, createdAt: currentDate)
        
        do {
            try self.managedObjectContext.save()
            self.loadData()
        } catch {
            print("Could not save data \(error.localizedDescription)")
        }
        
    }
    
       

}
