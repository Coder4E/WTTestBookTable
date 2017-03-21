//
//  WTRequestFactoryTest.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import XCTest
@testable import WTTest

class WTRequestFactoryTest: XCTestCase {
    
    var requestFactory: WTRequestFactory!
    
    override func setUp() {
        super.setUp()
        
        requestFactory = WTRequestFactory()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateBaseRequest() {
        
        let endpoint = "forecast"
        let method = "GET"
        
        let request = requestFactory.createBaseRequest(endpoint: endpoint, method: method)
        
        XCTAssert(request != nil, "Request is nil")
        
        if request != nil {
            
            XCTAssert(request!.httpMethod == method, "HTTPMethod is incorrect")
            
            XCTAssert(request!.url?.absoluteString.range(of: endpoint) != nil, "Absolute URL is incorrect")
            
            XCTAssert(request!.allHTTPHeaderFields != nil, "HTTPHeaderFields is empty")
        }
    }
    
    func testDataRequestWithMethod() {
        
        let endpoint = "forecast"
        let method = "GET"
        
        let request = requestFactory.dataRequestWithMethod(method: method, endpoint: endpoint)
        
        XCTAssert(request != nil, "Request is nil")
        
        if request != nil {
            XCTAssert(request!.allHTTPHeaderFields != nil, "HTTPHeaderFields is empty")
        }
    }
    
}
