//
//  WeatherItem.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

struct WTWeatherItem {
    
    let dt: Double
    let dt_txt: String
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let desc: String
    let icon: String
}

extension WTWeatherItem {
    
    init?(json: [String: Any]) {
        
        guard let dt = json["dt"] as? Double,
            let dt_txt = json["dt_txt"] as? String,
            let main = json["main"] as? [String: AnyObject],
            let temp = main["temp"] as? Float,
            let temp_min = main["temp_min"] as? Float,
            let temp_max = main["temp_max"] as? Float,
            let weather = json["weather"] as? [[String: AnyObject]],
            let desc = weather.first?["description"] as? String,
            let icon = weather.first?["icon"] as? String
            else {
                return nil
        }
        
        self.dt = dt
        self.dt_txt = dt_txt
        self.temp = temp
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.desc = desc
        self.icon = icon
    }
}
