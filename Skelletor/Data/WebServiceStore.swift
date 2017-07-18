//
//  WebServiceStore.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 09/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import CoreData
import Foundation

/// Errors thrown by WebServiceStore methods.
///
/// - noStoreURL: No Store URL was provided
/// - invalidURLType: It was provided an unsupported URL type for this store
/// - noEntity: Fetch request has no entity attached to it
/// - noContext: Managed object context was not provided
/// - mustBeOverriden: Method must be overriden by descendant classes
public enum WebServiceStoreError: Error {
    case unsupportedEntity(entity: String)
    case noStoreURL
    case invalidURLType
    case invalidRequest
    case noEntity
    case noContext
    case mustBeOverriden
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
    
    /// Executes a request against the store
    ///
    /// - Parameters:
    ///   - request: fetch request or save request to be executed.
    ///   - context: managed object context
    /// - Returns: List of managed objects, if it is the case.
    /// - Throws: 
    ///     - WebServiceStoreError.noContext
    ///     - WebServiceStoreError.noEntity
    ///     - WebServiceStoreError.noExecutor(entity)
    open override func execute(_ request: NSPersistentStoreRequest, with context: NSManagedObjectContext?) throws -> Any {
        switch request {
        case let fetchRequest as NSFetchRequest<NSFetchRequestResult>:
            return try execute(fetchRequest: fetchRequest, with: context)
        case let saveRequest as NSSaveChangesRequest:
            return try persistToBackingStore(saveRequest: saveRequest, with: context)
        default:
            throw WebServiceStoreError.invalidRequest
        }
    }
    
    /// Resolves faults by asking the web service about data
    ///
    /// - Parameters:
    ///   - objectID: Object ID
    ///   - context: Managed context
    /// - Returns: The obtained node with fault data resolved
    open override func newValuesForObject(with objectID: NSManagedObjectID, with context: NSManagedObjectContext) throws -> NSIncrementalStoreNode {
        let objectKey = referenceObject(for: objectID)
        let entity = objectID.entity.name!
        var values = try getValuesForObject(for: entity, and: objectKey)
        let version: UInt64 = values["version"] as? UInt64 ?? 0
        if values["version"] != nil {
            values.removeValue(forKey: "version")
        }
        return NSIncrementalStoreNode(objectID: objectID, withValues: values, version: version)
    }

    /// Obtains permanent IDs for a given object
    ///
    /// - Parameter array: array of objects to get permanent IDs
    /// - Returns: list of managed object IDs
    open override func obtainPermanentIDs(for array: [NSManagedObject]) throws -> [NSManagedObjectID] {
        var objectIDs = [NSManagedObjectID]()
        let objects = categorize(array: array)
        let keys = try createObjectKeys(for: objects)
        for (key, object) in keys {
            objectIDs.append(newObjectID(for: object.entity, referenceObject: key))
        }
        return objectIDs
    }
    
    /// Categorizes a list of managed object by type.
    ///
    /// - Parameter objects: Objects to categorize
    /// - Returns: Categorized list of managed objects
    public func categorize(array ofObjects: [NSManagedObject]) -> [String:[NSManagedObject]] {
        var categorizedObjects = [String:[NSManagedObject]]()
        ofObjects.forEach { (managedObject) in
            let entity = managedObject.entity.name!
            if categorizedObjects[entity]?.append(managedObject) == nil {
                categorizedObjects[entity] = [NSManagedObject]()
                categorizedObjects[entity]?.append(managedObject)
            }
        }
        return categorizedObjects
    }
    
    /// Categorize a set of objects, returning a categorized set of it
    ///
    /// - Parameter objects: Set of objects to categorize
    /// - Returns: Categorized objects
    public func categorize(set ofObjects: Set<NSManagedObject>) -> [String: Set<NSManagedObject>] {
        var categorizedObjects = [String: Set<NSManagedObject>]()
        ofObjects.forEach { (managedObject) in
            let entity = managedObject.entity.name!
            if categorizedObjects[entity]?.insert(managedObject) == nil {
                categorizedObjects[entity] = Set<NSManagedObject>()
                categorizedObjects[entity]?.insert(managedObject)
            }
        }
        return categorizedObjects
    }
    
    // MARK: - Extension Points

    /// Returns unique IDs for object creation.
    ///
    /// - Parameter fetchRequest: Fetch request to evaluate
    /// - Returns: A list of unique ids, grabbed from a web service
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    open func getUniqueIds(for fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws -> [Any] {
        throw WebServiceStoreError.mustBeOverriden
    }
    
    /// Get values from the web service for a given entity and key
    ///
    /// - Parameters:
    ///   - entity: Entity name
    ///   - key: Entity key information (e.g., primary key)
    /// - Returns: List of pairs attribute/values
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    open func getValuesForObject(for entity: String, and key: Any) throws -> [String:Any] {
        throw WebServiceStoreError.mustBeOverriden
    }
    
    /// Create permanent object keys for a list of categorized objects
    ///
    /// - Parameter categorizedObjects: List of categorized objects
    /// - Returns: List of tuples Key/Object
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    open func createObjectKeys(for categorizedObjects: [String:[NSManagedObject]]) throws -> [(Any, NSManagedObject)] {
        throw WebServiceStoreError.mustBeOverriden
    }
    
    /// Persist data to the backing store
    ///
    /// - Parameters:
    ///   - saveRequest: Save request to execute
    ///   - context: managed object context
    /// - Returns: An empty list o NSManagedObject on success
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    open func persistToBackingStore(saveRequest: NSSaveChangesRequest, with context: NSManagedObjectContext?) throws -> [NSManagedObject] {
        throw WebServiceStoreError.mustBeOverriden
    }
}

// MARK: - Internal Methods
extension WebServiceStore {
    func execute(fetchRequest: NSFetchRequest<NSFetchRequestResult>, with context: NSManagedObjectContext?) throws -> [NSManagedObject] {
        guard let context = context else {
            throw WebServiceStoreError.noContext
        }
        guard let entityName = fetchRequest.entity?.name else {
            throw WebServiceStoreError.noEntity
        }
        var managedObjects = [NSManagedObject]()
        for key in try getUniqueIds(for: fetchRequest) {
            if let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context) {
                let objectID = newObjectID(for: entityDescription, referenceObject: key)
                managedObjects.append(context.object(with: objectID))
            }
        }
        return managedObjects
    }
}
