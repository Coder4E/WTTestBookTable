//
//  Utils.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

extension Double {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func formatHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func friendlyDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }

}
