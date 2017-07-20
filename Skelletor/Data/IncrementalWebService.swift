//
//  WebService.swift
//  Point
//
//  Created by Ronaldo Faria Lima on 14/07/17.
//  Copyright © 2017 Point. All rights reserved.
//

import Foundation
import CoreData

/// Errors thrown by the web service
///
/// - requestError: Error occurred during a given request.
/// - operationTimedOut: Operation has timed out
public enum IncrementalWebServiceError: Error {
    case requestError(message: String)
    case operationTimedOut
    case invalidDataReceived
    case wrongNumberOfItemsReceived
    case mustBeOverriden
}

/// Encapsulates all about a given web service
open class IncrementalWebService {
    public weak var store: IncrementalWebServiceStore!
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
    public init(rootURL: URL, apiKey: String, store: IncrementalWebServiceStore) {
        self.rootURL = rootURL
        self.apiKey = apiKey
        self.store = store
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
    public func execute(request: URLRequest, timeout: TimeInterval = 30, callback: ((Data?) throws -> Void)? = nil) throws {
        let barrier = NSCondition()
        barrier.lock()
        defer {
            barrier.unlock()
        }
        var foundError: IncrementalWebServiceError?
        let task = store.session.dataTask(with: request) { (data, response, error) in
            if error != nil, error?.localizedDescription != nil {
                foundError = IncrementalWebServiceError.requestError(message: error!.localizedDescription)
            } else {
                do {
                    try callback?(data)
                } catch {
                    foundError = IncrementalWebServiceError.invalidDataReceived
                }
            }
            barrier.signal()
        }
        task.resume()
        if !barrier.wait(until: Date().addingTimeInterval(timeout)) {
            throw IncrementalWebServiceError.operationTimedOut
        }
        if let error = foundError {
            throw error
        }
    }
    
    //
    // MARK: - Methods to be overriden
    //
    
    open func getUniqueIds(for fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
        throw IncrementalWebServiceError.mustBeOverriden
    }
    
    open func getValuesForObject(using key: Any) throws -> [String : Any] {
        throw IncrementalWebServiceError.mustBeOverriden
    }
    
    open func createKeys(for objects: [NSManagedObject]) throws -> [(Any, NSManagedObject)] {
        throw IncrementalWebServiceError.mustBeOverriden
    }
    
    open func persistToBackingStore(saveRequest: NSSaveChangesRequest, with context: NSManagedObjectContext?) throws {
        throw IncrementalWebServiceError.mustBeOverriden
    }
}

//
// MARK: - Hashable & Equatable conformance
//

extension IncrementalWebService: Hashable {
    public var hashValue: Int {
        return entity.hashValue
    }
    
    public static func == (a: IncrementalWebService, b: IncrementalWebService) -> Bool {
        return a.hashValue == b.hashValue
    }
}
