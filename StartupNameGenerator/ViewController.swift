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



private let CellIdentifier: String = "NameTableViewCell"



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NameCellDelegate {
    
    
    var managedObjectContext: NSManagedObjectContext!
    let currentDate = Date()
    var nameGenerator = NameGenerator()

    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var inputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTable.delegate = self
        nameTable.dataSource = self
        LocalDataManager.instance.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        LocalDataManager.instance.loadData()
        nameTable.reloadData()

    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        var userInputText: String = self.inputText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (userInputText.characters.count > 0) {
            LocalDataManager.instance.words = userInputText.components(separatedBy: " ")
            nameGenerator.generateStartupNames()
            self.nameTable.reloadData()
        }
        else {
             self.showToast(text: "Digite ao menos uma palavra")
        }
    }
    
    @IBAction func cleanupButtonTapped(_ sender: Any) {
        LocalDataManager.instance.deleteNonFav()
        self.nameTable.reloadData()
    
    }
    //TableView protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalDataManager.instance.history.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! NameTableViewCell
        
        cell.delegate = self
        let entry = LocalDataManager.instance.history[indexPath.row]
        
        cell.set(entry: entry)
        if LocalDataManager.instance.latestNames.contains(LocalDataManager.instance.history[indexPath.row].startupName as! NSString) {
            cell.startupNameLbl.font = UIFont.boldSystemFont(ofSize: cell.startupNameLbl.font.pointSize)
        } else {
            cell.startupNameLbl.font = UIFont.systemFont(ofSize: cell.startupNameLbl.font.pointSize)
        }
        
        return cell
    }
    
    func favoriteBtnTapped(cell: NameTableViewCell) {
        if let indexPath = self.nameTable.indexPath(for: cell) {
        if (LocalDataManager.instance.history[indexPath.row].isFavorite == false) {
            LocalDataManager.instance.history[indexPath.row].addToFavorites()
            showToast(text: "\(String(describing: LocalDataManager.instance.history[indexPath.row].startupName!)) adicionado aos favoritos!")
            LocalDataManager.instance.saveChangesToDatabase()
            
            cell.favoriteBtn.setImage(UIImage(named:"star-full"), for: UIControlState.normal)
            
        } else {
            LocalDataManager.instance.history[(indexPath.row)].removeFromFavorites()
            cell.favoriteBtn.setImage(UIImage(named:"emptystar"), for: UIControlState.normal)
            
            LocalDataManager.instance.saveChangesToDatabase()
            
        }
        }
        
    }
        
   
    
}
    


    
    


