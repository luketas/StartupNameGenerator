//
//  NameGenerator.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/15/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import CoreData

class NameGenerator {
    
    
    enum KeywordType : Int {
        case wordPrefix = 1
        case wordSuffix
        case partialSuffix
    }
    
    func generateStartupNames() {
        if !hasAnyWord() {
            return
        }
        LocalDataManager.instance.clearLatestNames()
        
        let name1 = generateNameWithWordPrefix()
        if isUnique(name: name1, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name1)
            LocalDataManager.instance.addNewName(name: name1)
        }
        let name2 = generateNameWithWordPrefix()
        if isUnique(name: name2, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name2)
            LocalDataManager.instance.addNewName(name: name2)
        }
        let name3 = generateNameWithWordSuffix()
        if isUnique(name: name3, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name3)
            LocalDataManager.instance.addNewName(name: name3)
        }
        let name4 = generateNameWithPartialSuffix()
        if isUnique(name: name4, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name4)
            LocalDataManager.instance.addNewName(name: name4)
        }
        let name5 = generateNameWithPartialSuffix()
        if isUnique(name: name5, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name5)
           LocalDataManager.instance.addNewName(name: name5)
        }
        let name6 = generateNameWithPartialSuffix()
        if isUnique(name: name6, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name6)
            LocalDataManager.instance.addNewName(name: name6)
        }
        let name7 = generateNameWithMixedWords()
        if isUnique(name: name7, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name7)
            LocalDataManager.instance.addNewName(name: name7)
        }
        let name8 = generateNameWithMixedWords()
        if isUnique(name: name8, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name8)
            LocalDataManager.instance.addNewName(name: name8)
        }
        let name9 = generateNameWithMixedWords()
        if isUnique(name: name9, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name9)
            LocalDataManager.instance.addNewName(name: name9)
        }
        let name10 = generateCrazyName()
        if isUnique(name: name10, list: LocalDataManager.instance.history) {
            LocalDataManager.instance.createHistory(withStartupName: name10)
            LocalDataManager.instance.addNewName(name: name10)        }
        LocalDataManager.instance.loadData()
        
    }
    
    //Word Manipulation funcs
    func hasOnlyOneWord() -> Bool {
        if (LocalDataManager.instance.words.count == 1) {
            return true
        } else {
            return false
        }
    }
    
    func hasAnyWord() -> Bool {
        return LocalDataManager.instance.words.count > 0
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
            word = (LocalDataManager.instance.words.first as! NSString)
        }
        else {
            let index: Int = random(withMax: LocalDataManager.instance.words.count)
            word = (LocalDataManager.instance.words[index] as! NSString)
        }
        return word!
    }
    
    
    func findWordPrefixes() -> [Any] {
        var keywords: [Any]?
        let fetchRequest = NSFetchRequest<Keyword>(entityName: "Keyword")
        fetchRequest.predicate = NSPredicate(format: "type == %d", KeywordType.wordPrefix.rawValue)
        
        do {
            keywords = try LocalDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
        } catch {
            ViewController().showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.wordPrefix)")
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
            keywords = try LocalDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
        } catch {
            ViewController().showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.wordSuffix)")
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
            keywords = try LocalDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
        } catch {
            ViewController().showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.partialSuffix)")
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
            keywords = try LocalDataManager.instance.managedObjectContext.fetch(fetchRequest)
            
        } catch {
            ViewController().showToast(text: "Erro ao obter palavras-chave do tipo \(KeywordType.wordPrefix) e \(KeywordType.wordSuffix)")
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
}
