//
//  StartupNameGeneratorTests.swift
//  StartupNameGeneratorTests
//
//  Created by Lucas Franco on 5/10/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import XCTest
@testable import StartupNameGenerator

class StartupNameGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testClearLatest () {
        LocalDataManager.instance.clearLatestNames()
        XCTAssertTrue(LocalDataManager.instance.latestNames.count == 0)
    }
    func testAddNames() {
        LocalDataManager.instance.clearLatestNames()
        LocalDataManager.instance.addNewName(name: "HEY")
        XCTAssertTrue(LocalDataManager.instance.latestNames.contains("HEY"))
    }
    func testDeleteNonFav() {
        LocalDataManager.instance.deleteNonFav()
        for item in LocalDataManager.instance.history {
            XCTAssertTrue(item.isFavorite)
        }
    }
    
}
