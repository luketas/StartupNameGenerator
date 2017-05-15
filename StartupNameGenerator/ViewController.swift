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
import Toast_Swift


private let CellIdentifier: String = "NameTableViewCell"



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NameCellDelegate {
    
    enum KeywordType : Int {
        case wordPrefix = 1
        case wordSuffix
        case partialSuffix
    }
    
    var words = [Any]()
    var managedObjectContext: NSManagedObjectContext!
    var history = [History]()
    var keyword = [Keyword]()
    let currentDate = Date()
    var latestNames = [NSString]()

    @IBOutlet weak var nameTable: UITableView!
    @IBOutlet weak var inputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTable.delegate = self
        nameTable.dataSource = self
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()

    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        var userInputText: String = self.inputText.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (userInputText.characters.count > 0) {
            words = userInputText.components(separatedBy: " ")
            generateStartupNames()
        }
        else {
             showToast(text: "Digite ao menos uma palavra")
        }
    }
    
    @IBAction func cleanupButtonTapped(_ sender: Any) {
        deleteNonFav()
    
    }
    //TableView protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! NameTableViewCell
        sortList()
        let entry = history[indexPath.row]
        cell.startupNameLbl.text = entry.startupName
        cell.delegate = self
        if entry.isFavorite {
            cell.favoriteBtn.setImage(UIImage(named:"star-full"), for: UIControlState.normal)
        } else {
                cell.favoriteBtn.setImage(UIImage(named:"emptystar"), for: UIControlState.normal)
        }
        if latestNames.contains(history[indexPath.row].startupName as! NSString) {
            cell.startupNameLbl.font = UIFont.boldSystemFont(ofSize: cell.startupNameLbl.font.pointSize)
        } else {
            cell.startupNameLbl.font = UIFont.systemFont(ofSize: cell.startupNameLbl.font.pointSize)
        }

        
        return cell
    }
    
    func favoriteBtnTapped(cell: NameTableViewCell) {
        if let indexPath = self.nameTable.indexPath(for: cell) {
        if (history[indexPath.row].isFavorite == false) {
            history[indexPath.row].addToFavorites()
            showToast(text: "\(String(describing: history[indexPath.row].startupName!)) adicionado aos favoritos!")
            saveChangesToDatabase()
            
            cell.favoriteBtn.setImage(UIImage(named:"star-full"), for: UIControlState.normal)
            
        } else {
            history[(indexPath.row)].removeFromFavorites()
            cell.favoriteBtn.setImage(UIImage(named:"emptystar"), for: UIControlState.normal)
            print("removed \(history[(indexPath.row)].startupName)")
            saveChangesToDatabase()
            
        }
        }
        
    }
    
    
    //Database interaction functions
    func loadData() {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        do {
            history = try managedObjectContext.fetch(fetchRequest)
          //  sortList()
            
            
            self.nameTable.reloadData()
        } catch {
             showToast(text: "Could not load data from database \(error.localizedDescription)")
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
   
    func sortList() {
        history.sort { ($0.isFavorite && !$1.isFavorite)}
        history.sort {($0.createdAt?.compare($1.createdAt!) == ComparisonResult.orderedAscending)}
    }
    
    func createHistory(withStartupName: NSString) {
        let historyItem = History(context: managedObjectContext)
        historyItem.createHistoryEntry(name: withStartupName as String, createdAt: currentDate)
        
        do {
            try self.managedObjectContext.save()
            self.loadData()
        } catch {
             showToast(text: "Could not save data for item \(String(describing: historyItem.startupName)) \(error.localizedDescription)")
        }
        
    }
    
    func deleteNonFav() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest? = History.fetchRequest()
        var error: Error? = nil
        let historyList: [History]? = try! context?.fetch(fetchRequest!)
        if error != nil {
             showToast(text: "Erro ao obter históricos")
        }
        for history: History in historyList! {
            if history.isFavorite == false {
            context?.delete(history)
                do {
                    try context?.save()
                    self.loadData()
                } catch {
                    showToast(text: "Could not save data for item")
                }
            }
            loadData()
        }
        self.nameTable.reloadData()
    }
    
    func generateStartupNames() {
        if !hasAnyWord() {
            return
        }
        latestNames.removeAll()
    
        let name1 = generateNameWithWordPrefix()
        if isUnique(name: name1, list: history) {
        createHistory(withStartupName: name1)
        latestNames.append(name1)
        }
        let name2 = generateNameWithWordPrefix()
        if isUnique(name: name2, list: history) {
        createHistory(withStartupName: name2)
        latestNames.append(name2)
        }
        let name3 = generateNameWithWordSuffix()
        if isUnique(name: name3, list: history) {
        createHistory(withStartupName: name3)
        latestNames.append(name3)
        }
        let name4 = generateNameWithPartialSuffix()
        if isUnique(name: name4, list: history) {
        createHistory(withStartupName: name4)
        latestNames.append(name4)
        }
        let name5 = generateNameWithPartialSuffix()
        if isUnique(name: name5, list: history) {
        createHistory(withStartupName: name5)
        latestNames.append(name5)
        }
        let name6 = generateNameWithPartialSuffix()
        if isUnique(name: name6, list: history) {
        createHistory(withStartupName: name6)
        latestNames.append(name6)
        }
        let name7 = generateNameWithMixedWords()
        if isUnique(name: name7, list: history) {
        createHistory(withStartupName: name7)
        latestNames.append(name7)
        }
        let name8 = generateNameWithMixedWords()
        if isUnique(name: name8, list: history) {
        createHistory(withStartupName: name8)
        latestNames.append(name8)
        }
        let name9 = generateNameWithMixedWords()
        if isUnique(name: name9, list: history) {
        createHistory(withStartupName: name9)
        latestNames.append(name9)
        }
        let name10 = generateCrazyName()
        if isUnique(name: name10, list: history) {
        createHistory(withStartupName: name10)
        latestNames.append(name10)
        }
        loadData()

    }
    
    //Word Manipulation funcs
    func hasOnlyOneWord() -> Bool {
        if (words.count == 1) {
            return true
        } else {
            return false
        }
    }
    
    func hasAnyWord() -> Bool {
        return words.count > 0
    }
    func hasMoreThan3Char(name: NSString) -> Bool{
        if (name.length < 3) {
            return false
        }
        return true
    }
    
    func isUnique(name: NSString , list: [History]) -> Bool {
        if list.contains(where: {$0.startupName == name as String}) {
            return false
        } else {
            return true
        }
    }
    
    func random(withMax max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    func randomWord() -> NSString {
        var word: NSString? = nil
        if hasOnlyOneWord() {
            word = (words.first as! NSString)
        }
        else {
            let index: Int = random(withMax: words.count)
            word = (words[index] as! NSString)
        }
        return word!
    }
    
    
    func findWordPrefixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest = NSFetchRequest<Keyword>(entityName: "Keyword")
         fetchRequest.predicate = NSPredicate(format: "type == %d", KeywordType.wordPrefix.rawValue)
       
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
             showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.wordPrefix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
    
    func randomWordPrefix() -> NSString {
        let prefixes: [Keyword] = findWordPrefixes() as! [Keyword]
        let index: Int = random(withMax: prefixes.count)
        let result = prefixes[index].name! as NSString
    
            return result
       
        
    }
    func findWordSuffixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.wordSuffix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
    
    func randomWordSuffix() -> NSString {
        let suffixes: [Keyword] = findWordSuffixes() as! [Keyword]
        let index: Int = random(withMax: suffixes.count)
        return suffixes[index].name! as NSString
    }
    func randomPartialSuffix() -> NSString {
        let suffixes: [Keyword] = findPartialSuffixes() as! [Keyword]
        let index: Int = random(withMax: suffixes.count)
        return suffixes[index].name! as NSString
    }
    func findPartialSuffixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.partialSuffix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
    
    func findWordPrefixesAndSuffixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
        do {
            keywords = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
            showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.wordPrefix) e \(KeywordType.wordSuffix)")
        }
        
        if keywords == nil {
            return [Any]()
        }
        return keywords!
    }
    
    
    func randomWordToMix() -> NSString {
        let words: [Keyword] = findWordPrefixesAndSuffixes() as! [Keyword]
        let index: Int = random(withMax: words.count)
        return words[index].name! as NSString
    }
    
    //NAME GENERATING FUNCTIONS
    func generateNameWithWordSuffix() -> NSString {
        let word: NSString = randomWord()
        let suffix: NSString = randomWordSuffix()
        let suffixresult = "\(word)\(suffix)" as NSString

        if hasMoreThan3Char(name: suffixresult){
                return suffixresult
            } else {
                return generateNameWithWordSuffix()
            }
    }
    
    func generateNameWithPartialSuffix() -> NSString {
        let word: NSString = randomWord()
        let suffix: NSString = randomPartialSuffix()
        let partialSuffixResult = "\(word)\(suffix)" as NSString
        if hasMoreThan3Char(name: partialSuffixResult){
                    return partialSuffixResult
            } else {
            return generateNameWithPartialSuffix()
            }
    }
    
    func generateNameWithMixedWords() -> NSString {
        let word: NSString = randomWord()
        let suffix: NSString = randomWordToMix()
        let firstWord: NSString = (word as? NSString)!.substring(to: word.length - 2) as NSString
        let secondWord: NSString? = (suffix as? NSString)!.substring(from: 1) as NSString
        let firstSecondWord = "\(firstWord)\(secondWord!)" as NSString
        if hasMoreThan3Char(name: firstSecondWord){
                return firstSecondWord
        } else {
          return generateNameWithMixedWords()
        }
    }

    
    func generateNameWithWordPrefix() -> NSString {
        let word: NSString = randomWord()
        let prefix: NSString = randomWordPrefix()
        let prefixResult = "\(prefix) \(word)" as NSString
        if hasMoreThan3Char(name: prefixResult){
       
                return prefixResult
            } else {
                return generateNameWithWordPrefix()
            }
    }
    func generateCrazyName() -> NSString {
        if !hasAnyWord() {
            return ""
        }
        let word: NSString = randomWord()
        let suffix: NSString = randomPartialSuffix()
        let vowelCharacterSet = CharacterSet(charactersIn: "aáãeêéiíoõuy")
        let unvowelWord: NSString = (word.components(separatedBy: vowelCharacterSet) as NSArray).componentsJoined(by: "") as NSString
        let crazyResult = "\(unvowelWord)\(suffix)" as NSString
        if hasMoreThan3Char(name: crazyResult){
                return crazyResult
            } else {
                return generateCrazyName()
            }
        }
    
    
    //USER WARNING
    func showToast(text: String) {
        var style = ToastStyle()
        style.messageColor = UIColor.white
        self.view.makeToast(text, duration: 3.0, position: .center, style: style)
        
    }
}
    


    
    


