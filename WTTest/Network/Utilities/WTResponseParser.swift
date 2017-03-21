//
//  WTResponseParser.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

class WTResponseParser {
    
    /**
     Parse json data.
     
     - parameter data:     Data received from a request.
     
     - returns: The mapped struct.
     
     */
    func parse(data: Data, type: WTRequestType) -> Any? {
        
        var json: [String: AnyObject]!
        
        if let datastring = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            print(datastring)
        }
    
        do {
            json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? Dictionary<String,AnyObject>
        } catch {
            print("JSONSerialization failure!")
            print(error)
            return (nil)
        }
        
        var result: Any?
        
        // Validation and object mapping
        if type == .GetWeather {
            result = WTWeather(json: json)
        }
        
        return result
    }
    
}
