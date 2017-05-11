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



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum KeywordType : Int {
        case wordPrefix = 1
        case wordSuffix
        case partialSuffix
    }
    
    var words = [Any]()
    var lastGenerationRunAt: Date?
    var managedObjectContext: NSManagedObjectContext!
    var history = [History]()
    var keyword = [Keyword]()
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
        loadData()

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
    
    func createHistory(withStartupName: NSString) {
        let historyItem = History(context: managedObjectContext)
        
        historyItem.createHistoryEntry(name: withStartupName as String, createdAt: currentDate)
        
        do {
            try self.managedObjectContext.save()
            self.loadData()
        } catch {
            print("Could not save data for item \(historyItem.startupName) \(error.localizedDescription)")
        }
        
    }
    
    func generateStartupNames() {
        if !hasAnyWord() {
            return
        }
        lastGenerationRunAt = Date()
        createHistory(withStartupName: generateNameWithWordPrefix())
        createHistory(withStartupName: generateNameWithWordPrefix())
        createHistory(withStartupName: generateNameWithWordSuffix())
        createHistory(withStartupName: generateNameWithPartialSuffix())
        createHistory(withStartupName: generateNameWithPartialSuffix())
        createHistory(withStartupName: generateNameWithPartialSuffix())
        createHistory(withStartupName: generateNameWithMixedWords())
        createHistory(withStartupName: generateNameWithMixedWords())
        createHistory(withStartupName: generateNameWithMixedWords())
        createHistory(withStartupName: generateCrazyName())

    }
    
    //Word Manipulation funcs
    func hasOnlyOneWord() -> Bool {
        if ( words.count == 1) {
            return true
        } else {
            return false
        }
    }
    
    func hasAnyWord() -> Bool {
        return words.count > 0
    }
    
    func random(withMax max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    func randomWord() -> NSString {
        var word: NSString? = nil
        if hasOnlyOneWord() {
            word = words.first as! NSString
        }
        else {
            let index: Int = random(withMax: words.count)
            word = words[index] as! NSString
        }
        return word!
    }
    
    func findWordPrefixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
           
        } catch {
            print("Erro ao obter palavras-chave do tipo \(KeywordType.wordPrefix)")
        }

        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
    
    func findWordPrefixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            print("Erro ao obter palavras-chave do tipo \(KeywordType.wordPrefix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
    
    func randomWordPrefix() -> NSString {
        let prefixes: [Keyword] = findWordPrefixes()
        let index: Int = random(withMax: prefixes.count)
        return prefixes[index].name! as NSString
    }
    
    func generateNameWithWordPrefix() -> NSString {
        let word: NSString = randomWord()
        let prefix: NSString = randomWordPrefix()
        return "\(prefix) \(word)" as NSString
    }
    func findWordSuffixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            print("Erro ao obter palavras-chave do tipo \(KeywordType.wordSuffix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
   
    func randomWordSuffix() -> NSString {
        let suffixes: [Keyword] = findWordSuffixes() as! [Keyword]
        let index: Int = random(withMax: suffixes.count)
        return suffixes[index].name as! NSString
    }
    func randomPartialSuffix() -> NSString {
        let suffixes: [Keyword] = findPartialSuffixes() as! [Keyword]
        let index: Int = random(withMax: suffixes.count)
        return suffixes[index].name as! NSString
    }
    func findPartialSuffixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            print("Erro ao obter palavras-chave do tipo \(KeywordType.partialSuffix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }

    func generateNameWithWordSuffix() -> NSString {
        let word: NSString = randomWord()
        let suffix: NSString = randomWordSuffix()
        return "\(word)\(suffix)" as NSString
    }
    
    func generateNameWithPartialSuffix() -> NSString {
        let word: NSString = randomWord()
        let suffix: NSString = randomPartialSuffix()
        return "\(word)\(suffix)" as NSString
    }
    
    func generateNameWithMixedWords() -> NSString {
        let word: NSString = randomWord()
        let suffix: NSString = randomWordToMix()
        let firstWord: NSString = (word as? NSString)?.substring(to: (word.characters.count ?? 0) - 2)
        let secondWord: NSString? = (suffix as? NSString)?.substring(from: 1)
        return "\(firstWord)\(secondWord!)" as NSString
    }
    
    func randomWordToMix() -> NSString {
        let words: [Keyword] = findWordPrefixesAndSuffixes()
        let index: Int = random(withMax: words.count)
        return words[index].name as! NSString
    }
    func generateCrazyName() -> NSString {
        if !hasAnyWord() {
            return nil
        }
        let word: NSString = randomWord()
        let suffix: NSString = randomPartialSuffix()
        let vowelCharacterSet = CharacterSet(charactersInString: "aáãeêéiíoõuy")
        let unvowelWord: NSString = (word.components(separatedBy: vowelCharacterSet) as NSArray).componentsJoined(byString: "")
        return "\(unvowelWord)\(suffix)" as NSString
    }
    
    

}
