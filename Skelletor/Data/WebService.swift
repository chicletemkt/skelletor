//
//  WebService.swift
//  Point
//
//  Created by Ronaldo Faria Lima on 14/07/17.
//  Copyright © 2017 Point. All rights reserved.
//

import Foundation


/// Errors thrown by the web service
///
/// - requestError: Error occurred during a given request.
/// - operationTimedOut: Operation has timed out
public enum WebServiceError: Error {
    case requestError(message: String)
    case operationTimedOut
    case invalidDataReceived
    case wrongNumberOfItemsReceived
}

/// Encapsulates all about a given web service
open class WebService {
    public weak var session: URLSession!
    public let rootURL: URL
    public let apiKey: String
    open var entity: String {
        return "Entity"
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - rootURL: Root service URL
    ///   - session: URLSession for communications
    public init(rootURL: URL, apiKey: String, session: URLSession = URLSession.shared) {
        self.session = session
        self.rootURL = rootURL
        self.apiKey = apiKey
    }
    
    /// Builds a request out of an URL, using a closure for proper configuration
    ///
    /// - Parameters:
    ///   - from: URL to use for the request
    ///   - configure: Closure used for request configuration.
    /// - Returns: Fully configured request, ready to use.
    public func request(from: URL, configure: ((URLRequest) -> URLRequest)? = nil) -> URLRequest {
        var request = URLRequest(url: from)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        if let configure = configure {
            request = configure(request)
        }
        return request
    }
    
    /// Executes a given request, synchronously.
    ///
    /// - Parameters:
    ///   - request: Request to execute
    ///   - timeout: Timeout in seconds. Defaults to 30s
    ///   - callback: Callback that receives data returned from the server
    /// - Throws: PointWebServiceStoreError.downloadError,
    ///           PointWebServiceStoreError.operationTimedOut
    public func execute(request: URLRequest, timeout: TimeInterval = 30, callback: @escaping (Data?) throws -> Void) throws {
        let barrier = NSCondition()
        barrier.lock()
        defer {
            barrier.unlock()
        }
        var foundError: WebServiceError?
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil, error?.localizedDescription != nil {
                foundError = WebServiceError.requestError(message: error!.localizedDescription)
            } else {
                do {
                    try callback(data)
                } catch {
                    foundError = WebServiceError.invalidDataReceived
                }
            }
            barrier.signal()
        }
        task.resume()
        if !barrier.wait(until: Date().addingTimeInterval(timeout)) {
            throw WebServiceError.operationTimedOut
        }
        if let error = foundError {
            throw error
        }
    }
}

// MARK: - Hashable & Equatable conformance
extension WebService: Hashable {
    public var hashValue: Int {
        return entity.hashValue
    }
    
    public static func == (a: WebService, b: WebService) -> Bool {
        return a.hashValue == b.hashValue
    }
}
