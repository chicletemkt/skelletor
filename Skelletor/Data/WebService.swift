//
//  WebService.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 28/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

/// Simple RESTful web service interface
public class WebService {
    public let root: URL
    public var session: URLSession
    let apiKey: String
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - root: web service ROOT URL
    ///   - apiKey: apikey to be used with the web service.
    ///   - session: Session to use.
    public init(root: URL, apiKey: String, session: URLSession = URLSession.shared) {
        self.root = root
        self.session = session
        self.apiKey = apiKey
    }
    
    /// Build a proper request for the web service
    ///
    /// - Parameters:
    ///   - resource: Resource to contact
    ///   - timeout: Timeout. Defaults to 30 seconds.
    ///   - configure: Callback used to customize the request
    /// - Returns: Created request
    public func request(for resource: String, timeout: TimeInterval = 30, configure: ((URLRequest)->URLRequest)? = nil) -> URLRequest {
        let url = root.appendingPathComponent(resource)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if configure != nil {
            request = configure!(request)
        }
        return request
    }
    
    /// Executes an URLRequest using the internal session
    ///
    /// - Parameters:
    ///   - request: request to execute
    ///   - completionHandler: callback for data return and error processing
    /// - Returns: Data task created, already running in background
    @discardableResult
    public func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            OperationQueue.main.addOperation {
                completionHandler(data, response, error)
            }
        }
        task.resume()
        return task
    }
}
