//
//  WebServiceStore.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 09/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import CoreData


/// Errors thrown by WebServiceStore methods.
///
/// - noStoreURL: No Store URL was provided
/// - invalidURLType: It was provided an unsupported URL type for this store
public enum WebServiceStoreError: Error {
    case noStoreURL
    case invalidURLType
}

/// General web service store for incremental stores.
open class WebServiceStore: NSIncrementalStore {
    /// Default session. You may override it to initialize with a different type of session. By default,
    /// it uses the default URL session without any configuration changes.
    open var session: URLSession = URLSession.shared
    
    /// Unique Identification for this store (UUID) as a String representation.
    /// - important:
    /// Your subclass must override this property getter
    open class var uuid: String {
        return "uuid"
    }
    
    /// Type of this store. This is a free string. 
    /// - important: 
    /// Your subclass must override this property getter
    open class var type: String {
        return "store"
    }
    
    /// Registers this class as a valid persistent store within coredata. You should call this 
    /// method as soon as possible.
    public static func register() {
        NSPersistentStoreCoordinator.registerStoreClass(self, forStoreType: self.type)
    }
    
    /// Type of this class.
    /// - important:
    /// This is a calculated property. You don´t need to override it.
    open override var type: String {
        return type(of: self).type
    }
    
    /// Unique identifier for this class. 
    /// - important:
    /// This is a calculated property. You don´t need to override it.
    public var uuid: String {
        return type(of: self).uuid
    }
    
    /// Loads this store metadata
    ///
    /// - Throws: WebServiceStoreError.noStoreURL if URL was not provided to the store
    /// - Throws: WebServiceStoreError.invalidURLType if provided URL is a file URL
    open override func loadMetadata() throws {
        guard self.url != nil else {
            throw WebServiceStoreError.noStoreURL
        }
        if self.url!.isFileURL {
            throw WebServiceStoreError.invalidURLType
        }
        self.metadata = [NSStoreUUIDKey: uuid, NSStoreTypeKey: type]
    }
}
