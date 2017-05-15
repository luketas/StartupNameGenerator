//
//  StartupNameGeneratorUITests.swift
//  StartupNameGeneratorUITests
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import XCTest

class StartupNameGeneratorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testGenerateBtn() {
        
        let app = XCUIApplication()
        app.textFields.containing(.button, identifier:"Clear text").element.typeText("na")
        app.typeText("me")
        app.tables.cells.containing(.staticText, identifier:"Easy name").buttons["Button"].tap()
        app.buttons["Gerar"].tap()
        
    }
    func testCleanBtn() {
        
        let app = XCUIApplication()
        let limparButton = app.buttons["Limpar"]
        limparButton.tap()
        app.buttons["Gerar"].tap()
        app.tables.cells.containing(.staticText, identifier:"Clube name").buttons["Button"].tap()
        limparButton.tap()
        
    }
    func testFavoriteBtn() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.buttons["Button"].tap()
        
        let limparButton = app.buttons["Limpar"]
        limparButton.tap()
        app.buttons["Gerar"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Clube name").buttons["Button"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"99 name").buttons["Button"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"nameClube").buttons["Button"].tap()
        limparButton.tap()
        
    }
    
}
