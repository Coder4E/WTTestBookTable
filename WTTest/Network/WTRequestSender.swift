//
//  WTRequestSender.swift
//  WTTest
//
//  Created by Fabio on 15/03/2017.
//  Copyright © 2017 Fabio. All rights reserved.
//

import Foundation
import UIKit

class WTRequestSender: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    var tasksBeingExecuted = Dictionary<String, Data>()
    
    var session: URLSession!
    var requestFactory: WTRequestFactory!
    var parser: WTResponseParser!
    
    weak var delegate: WTNetworkDelegate?
    
    // Show the spinner while a request is in progress
    var active: Bool = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = active
        }
    }
    
    //MARK: Initialiser
    
    init(requestFactory: WTRequestFactory, parser: WTResponseParser, urlSession: URLSession? = nil, delegate: WTNetworkDelegate?) {
        
        super.init()
        
        self.requestFactory = requestFactory
        self.parser = parser
        self.delegate = delegate
        
        if let session = urlSession {
            self.session = session
        } else {
            self.session = initializeSession()
        }
    }
    
    /**
     Create and initializes URL session.
     */
    private func initializeSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 10
        sessionConfiguration.timeoutIntervalForResource = 10
        return URLSession(configuration: sessionConfiguration, delegate:self, delegateQueue:nil)
    }
    
    /**
     Create and sends data request. If request result is cached, function will not send request.
     
     - parameter method:             HTTP method string, either "GET", "PUT", "POST" or "DELETE"
     - parameter endpoint:           Relative path to API endpoint.
     - parameter type:               Type of the request. See WTRequestType enumeration for possible values.
     */
    
    func sendDataRequest(method: String, endpoint: String, type: WTRequestType) {
        
        let request = requestFactory.dataRequestWithMethod(method: method, endpoint: endpoint)
        
        let taskId = "\(type.rawValue)"
        
        //check if the task is in execution
        if let req = request, self.tasksBeingExecuted[taskId] == nil {
            
            self.tasksBeingExecuted[taskId] = Data()
            
            let task = self.session.dataTask(with: req, completionHandler: {
                (data,response,error) in
                
                WTLogger.networkRequestLog(request: req, type: type)
                
                var httpCode: Int = 0
                
                if let httpResponse = response as? HTTPURLResponse {
                    httpCode = httpResponse.statusCode
                }
                
                if let receivedData = data, error == nil {
                    self.dataTaskCompleted(data: receivedData, requestType: type, httpCode: httpCode)
                } else {
                    // Framework error
                    self.notifyDelegateRequestFailed(requestType: type, httpCode: httpCode)
                }
                
                //remove task from dictionary
                self.tasksBeingExecuted.removeValue(forKey: taskId)
                self.active = self.tasksBeingExecuted.count > 0
            })
            
            task.resume()
        }
    }
    
    /**
     Callback function which is called when data request is completed.
     
     - parameter data:          Received data.
     - parameter httpCode:      HTTP response code.
     */
    func dataTaskCompleted(data: Data, requestType: WTRequestType, httpCode: Int) {
        
        let parsedData = parser.parse(data: data, type: requestType)
        
        if let pData = parsedData as Any?,
            httpCode < 400 {
            // parsing was successfull
            self.notifyDelegateRequestProcessed(requestType: requestType, data: pData)
        } else {
            // parsing failed, client error (40x), server error (50x)
            self.notifyDelegateRequestFailed(requestType: requestType, httpCode: httpCode)
        }
    }
    
    /**
     Notifies observers if request is completed successfully.
     
     - parameter requestType: Type of the request. See WTRequestType enumeration for possible values.
     - parameter data: Data returned from the api.
     */
    func notifyDelegateRequestProcessed(requestType: WTRequestType, data: Any) {
        
        DispatchQueue.main.async {
            if let delegate = self.delegate as WTNetworkDelegate? {
                delegate.requestProcessed(type: requestType, data: data)
            }
        }
    }
    
    /**
     Notifies observers if request is completed with error.
     
     - parameter requestType:       Type of the request. See WTRequestType enumeration for possible values.
     - parameter httpCode:          HTTP response code.
     */
    func notifyDelegateRequestFailed(requestType: WTRequestType, httpCode: Int?) {
        
        DispatchQueue.main.async {
            if let delegate = self.delegate as WTNetworkDelegate? {
                delegate.requestFailed(type: requestType, httpCode: httpCode)
            }
        }
    }
    
}
