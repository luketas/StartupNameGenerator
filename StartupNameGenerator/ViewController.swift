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
    
   

}
