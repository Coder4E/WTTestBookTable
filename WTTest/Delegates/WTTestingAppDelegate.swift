//
//  WTTestingAppDelegate.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation
import OHHTTPStubs

/**
 This class allow to override the application:didFinishLaunchingWithOptions when the unit tests are running;
 This allow to mock the network requests using the OHHTTPStubs framework.
 */
class WTTestingAppDelegate: AppDelegate {
    
    override  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let _ = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Mock all the network requests for this host
        stub(condition: isHost("api.openweathermap.org")) { _ in
            return OHHTTPStubsResponse(data: Data(), statusCode:200, headers:nil)
        }
        
        return true
    }
}
