//
//  WTRequestEndpoints.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

class WTRequestEndpoints: NSObject {
    
    private var requestSender: WTRequestSender
    // needed for openweather.com requests
    private let APPID = "87c0d4c1b5958d7a87d3de15edc74a5f"
    
    init(requestSender: WTRequestSender) {
        
        self.requestSender = requestSender
    }
    
    /**
     Send the request to get the weather.
     */
    func getWeather(city: String = "London", unit: String = "metric") {
        
        requestSender.sendDataRequest(method: "GET", endpoint: "data/2.5/forecast?q=\(city)&units=\(unit)&APPID=\(APPID)", type: .GetWeather)
        
    }
    
}
