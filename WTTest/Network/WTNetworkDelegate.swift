//
//  WTNetworkDelegate.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation

public protocol WTNetworkDelegate: AnyObject {
    
    func requestProcessed(type: WTRequestType, data: Any)
    func requestFailed(type: WTRequestType, httpCode: Int?)
    
}
