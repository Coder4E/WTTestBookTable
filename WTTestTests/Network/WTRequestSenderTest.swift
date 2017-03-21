//
//  WTRequestSenderTest.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import WTTest

class WTRequestSenderTest: XCTestCase, WTNetworkDelegate {
    
    var requestFactory: WTRequestFactory!
    var parser : WTResponseParser!
    var requestSender: WTRequestSender!
    
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        
        // Initialise the apiInterface
        class WTRequestFactoryMock: WTRequestFactory {
            
            override func dataRequestWithMethod(method: String, endpoint: String) -> URLRequest? {
                
                let url = URL(string: "https://www.testendpoint.com/test1")!
                let request = URLRequest.init(url: url as URL)
                return request
            }
        }
        
        requestFactory = WTRequestFactoryMock()
        parser = WTResponseParser()
        
        requestSender = WTRequestSender(requestFactory: requestFactory, parser: parser, delegate: self)
    }
    
    override func tearDown() {
        
        // Remove everything
        OHHTTPStubs.removeAllStubs()
        
        super.tearDown()
    }
    
    func testSendDataRequest() {
        
        stub(condition: isHost("www.testendpoint.com")) { request in
            // Stub it with test.json stub file
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        expectation = expectation(description: "requestExpectation")
        
        requestSender.sendDataRequest(method: "GET", endpoint: "", type: .GetWeather)
        
        waitForExpectations(timeout: 5) { error in
            // timeout is automatically treated as a failed test
        }
    }
    
    func testSendRequestFailWrongFormat() {
        
        // simulate wrong format json
        let jsonWrongFormat = "{>}}".data(using: .utf8)!
        
        stub(condition: isHost("www.testendpoint.com")) { _ in
            return OHHTTPStubsResponse(data: jsonWrongFormat, statusCode:200, headers:nil)
        }
        
        expectation = expectation(description: "requestFailExpectation")
        
        requestSender.sendDataRequest(method: "GET", endpoint: "", type: .GetWeather)
        
        waitForExpectations(timeout: 5) { error in
            // timeout is automatically treated as a failed test
        }
        
    }
    
    func testSendRequestFailClientError() {
        
        stub(condition: isHost("www.testendpoint.com")) { request in
            // Stub it with test.json stub file
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test.json", type(of: self))!,
                statusCode: 400,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        expectation = expectation(description: "requestFailClientExpectation")
        
        requestSender.sendDataRequest(method: "GET", endpoint: "", type: .GetWeather)
        
        waitForExpectations(timeout: 5) { error in
            // timeout is automatically treated as a failed test
        }
    }
    
    func testSendRequestFailServerError() {
        
        stub(condition: isHost("www.testendpoint.com")) { request in
            // Stub it with test.json stub file
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("test.json", type(of: self))!,
                statusCode: 500,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        expectation = expectation(description: "requestFailServerExpectation")
        
        requestSender.sendDataRequest(method: "GET", endpoint: "", type: .GetWeather)
        
        waitForExpectations(timeout: 5) { error in
            // timeout is automatically treated as a failed test
        }
    }
    
    //MARK: WTNetworkDelegate
    
    func requestProcessed(type: WTRequestType, data: Any) {
        
        if type == .GetWeather && (data as? WTWeather)?.items.count == 2 && expectation.description == "requestExpectation" {
            
            self.expectation.fulfill()
        }
        
    }
    
    func requestFailed(type: WTRequestType, httpCode: Int?) {
        
        if expectation.description == "requestFailExpectation" ||
            expectation.description == "requestFrameworkFailExpectation" {
            expectation.fulfill()
        }
        
        if expectation.description == "requestFailClientExpectation" && httpCode == 400 {
            expectation.fulfill()
        }
        
        if expectation.description == "requestFailServerExpectation" && httpCode == 500 {
            expectation.fulfill()
        }
    }
    
}

