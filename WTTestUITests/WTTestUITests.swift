//
//  WTTesWTTests.swift
//  WTTesWTTests
//
//  Created by Fabio on 22/02/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import XCTest

class WTTestUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainViewDisplayed() {
        
        let title = app.navigationBars.staticTexts["London (gb) Weather"]
        XCTAssertTrue(title.exists)
    }
    
    func testCustomCell() {
        
        let table = app.tables.element
        XCTAssertTrue(table.exists)
        
        let searchBar = app.searchFields.element
        XCTAssertTrue(searchBar.exists)
        
        let cell = table.cells.element(boundBy: 0)
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(cell.exists)
        
        let dateTimeLabel = cell.staticTexts["dateTimeLabelID"]
        XCTAssertTrue(dateTimeLabel.exists)
        
        let icon = app.images["iconID"]
        let descriptionLabel = app.staticTexts["descriptionLabelID"]
        let tempLabel = app.staticTexts["tempLabelID"]
        let timeLabel = app.staticTexts["timeLabelID"]
        
        XCTAssertTrue(icon.exists)
        XCTAssertTrue(descriptionLabel.exists)
        XCTAssertTrue(tempLabel.exists)
        XCTAssertTrue(timeLabel.exists)
    }

}
