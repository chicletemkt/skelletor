//
//  IncrementalWebService.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 17/07/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation
import CoreData

public protocol IncrementalWebService {
    /// Returns unique IDs for object creation.
    ///
    /// - Parameter fetchRequest: Fetch request to evaluate
    /// - Returns: A list of unique ids, grabbed from a web service
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    func getUniqueIds(for fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws -> [Any]
    
    /// Get values from the web service for a given entity and key
    ///
    /// - Parameters:
    ///   - key: Entity key information (e.g., primary key)
    /// - Returns: List of pairs attribute/values
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    func getValuesForObject(using key: Any) throws -> [String:Any]
    
    /// Create permanent object keys for a list of categorized objects
    ///
    /// - Parameter objects: List of objects
    /// - Returns: List of tuples Key/Object
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    func createKeys(for objects: [NSManagedObject]) throws -> [(Any, NSManagedObject)]
    
    /// Persist data to the backing store
    ///
    /// - Parameters:
    ///   - saveRequest: Save request to execute
    ///   - context: managed object context
    /// - Returns: An empty list o NSManagedObject on success
    /// - Important:
    /// This method must be overriden. Its default implementation just throws an exception.
    func persistToBackingStore(saveRequest: NSSaveChangesRequest, with context: NSManagedObjectContext?) throws
}
