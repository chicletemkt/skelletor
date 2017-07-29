//
//  WebService.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 28/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

public class WebService {
    public let root: URL
    public var session: URLSession
    let apiKey: String
    
    public init(root: URL, apiKey: String, session: URLSession = URLSession.shared) {
        self.root = root
        self.session = session
        self.apiKey = apiKey
    }
    
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
