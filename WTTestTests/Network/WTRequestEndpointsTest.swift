//
//  WTRequestEndpointsTest.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import WTTest

class WTRequestEndpointsTest: XCTestCase, WTNetworkDelegate {
    
    var requestFactory: WTRequestFactory!
    var parser : WTResponseParser!
    var requestSender: WTRequestSender!
    var apiInterface: WTRequestEndpoints!
    
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        // Initialise the apiInterface
        class WTRequestFactoryMock: WTRequestFactory {
            
            override func dataRequestWithMethod(method: String, endpoint: String) -> URLRequest? {
                
                let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=87c0d4c1b5958d7a87d3de15edc74a5f")!
                let request = URLRequest.init(url: url as URL)
                return request
            }
        }
        
        // Initialise the requestSender with mocks
        requestFactory = WTRequestFactoryMock()
        parser = WTResponseParser()
    
        requestSender = WTRequestSender(requestFactory: requestFactory, parser: parser, delegate: self)
        
        apiInterface = WTRequestEndpoints(requestSender: requestSender)
        
        // Stub URLSession
        stub(condition: isHost("api.openweathermap.org")) { _ in
            // Stub it with test.json stub file
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )

        }
    }
    
    override func tearDown() {
        
        // Remove everything
        OHHTTPStubs.removeAllStubs()
        
        super.tearDown()
        
    }
    
    func testGetWeather() {
        
        expectation = expectation(description: "weatherRequestExpectation")
        
        apiInterface.getWeather()
        
        waitForExpectations(timeout: 5) { error in
            // timeout is automatically treated as a failed test
        }
    }
    
    //MARK: WTNetworkDelegate
    
    func requestProcessed(type: WTRequestType, data: Any) {
        
        if type == .GetWeather && (data as? WTWeather)?.items.count == 2 && expectation.description == "weatherRequestExpectation" {
            expectation.fulfill()
        }
    }
    
    func requestFailed(type: WTRequestType, httpCode: Int?) {
        XCTFail()
    }
    
}
