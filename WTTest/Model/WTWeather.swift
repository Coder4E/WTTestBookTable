//
//  WTMain.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

struct WTWeather {
    
    let cityName: String
    let location : (lat: Double, lon: Double)
    let country: String
    
    let items: Array<WTWeatherItem>
}

extension WTWeather {
    
    init?(json: [String: Any]) {
        
        guard let city = json["city"] as? [String: AnyObject],
            let cityName = city["name"] as? String,
            let coordinates = city["coord"] as? [String: Double],
            let latitude = coordinates["lat"],
            let longitude = coordinates["lon"],
            let country = city["country"] as? String,
            let weatherItemsJSON = json["list"] as? [[String: AnyObject]]
            else {
                return nil
        }
        
        var items: Array<WTWeatherItem> = []
        for itemJSON in weatherItemsJSON {
            guard let weatherItem = WTWeatherItem(json: itemJSON) else {
                return nil
            }
            
            items.append(weatherItem)
        }
        
        self.cityName = cityName
        self.location = (latitude, longitude)
        self.country = country
        self.items = items
    }
}
