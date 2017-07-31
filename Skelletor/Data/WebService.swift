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
    /// Root URL for the web service
    public let root: URL
    /// Authorization token.
    public var authorization: String?
    /// Session current in use
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
    ///   - data: JSON data
    ///   - configure: Callback used to customize the request
    /// - Returns: Created request
    public func request(for resource: String, timeout: TimeInterval = 30, data: [String:Any]? = nil, configure: ((URLRequest)->URLRequest)? = nil) -> URLRequest {
        let url = root.appendingPathComponent(resource)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        if let data = data {
            request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        }
        if let authorization = authorization {
            request.addValue(authorization, forHTTPHeaderField: "Authorization")
        }
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
    ///
    /// - Remarks: It is guaranteed that the completion handler is called from the main queue.
    @discardableResult
    public func execute(request: URLRequest, completionHandler: @escaping ([String:Any]?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            OperationQueue.main.addOperation {
                var json: [String:Any]? = nil
                if let data = data, error == nil {
                    json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any]
                }
                completionHandler(json, response as? HTTPURLResponse, error)
            }
        }
        task.resume()
        return task
    }
}
