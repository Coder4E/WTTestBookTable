//
//  WTResponseParserTest.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

import XCTest
@testable import WTTest

class WTResponseParserTest: XCTestCase {
    
    let testBundle = Bundle(for: WTResponseParserTest.self)
    var parser: WTResponseParser!
    var json: Data!
    
    override func setUp() {
        super.setUp()
        
        if let url = testBundle.url(forResource: "test", withExtension: "json") {
            json = try! Data(contentsOf: url)
            
        } else {
            XCTFail()
        }
        
        parser = WTResponseParser()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseValidJson() {
        
        let parsedJson = parser.parse(data: json, type: .GetWeather)
        
        XCTAssertTrue((parsedJson as? WTWeather)?.items.count == 2, "Parsing of a valid json failed")
        
    }
    
    func testParseInvalidJson() {
        
        let jsonWrongFormat = "[{>}}]".data(using: .utf8)!
        
        let parsedJson = parser.parse(data: jsonWrongFormat, type: .GetWeather)
        
        XCTAssertTrue( parsedJson == nil  , "Parsing of an Invalid json looks successfull")
        
    }
}
