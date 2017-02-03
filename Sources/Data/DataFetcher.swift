//
//  DataFetcher.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 03/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation
import CoreData

/// Data fetcher. Used to fetch stuff from the context.
public struct DataFetcher <DataType: NSFetchRequestResult> {
    fileprivate weak var context: NSManagedObjectContext!
    
    /// Sort descriptors to apply for a given fetch
    public var sortDescriptors: [NSSortDescriptor]?
    /// Predicate used to filter data
    public var predicate: NSPredicate?
    
    /// - parameters:
    ///     - context: Managed context to use for data operations
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func fetch() -> [DataType] {
        let request = NSFetchRequest<DataType>(entityName: String(describing: DataType.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            return try context.fetch(request)
        } catch {}
        return []
    }
}
