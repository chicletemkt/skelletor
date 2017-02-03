//
//  DataFactory.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 03/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation
import CoreData

/// Instantiates a given data type by using a provided context.
struct DataFactory<DataType: NSManagedObject> {
    let context: NSManagedObjectContext
    
    /// Initializes the factory by providing a proper context to it to operate.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Instantiates a new instance of the provided data type.
    func instantiate() -> DataType {
        var instance: DataType!
        context.performAndWait {
            // Ensures that the operation will happen on the same context's run loop to avoid concurrency problems.
            instance = NSEntityDescription.insertNewObject(forEntityName: String(describing: DataType.self), into: self.context) as! DataType
        }
        return instance
    }
    
    /// Convenience method: Fetches data by using a Data Fetcher.
    ///
    /// - parameters:
    ///     - predicate: Optional. Predicate to use for data filtering.
    ///     - sortDescriptors: Optional. Sort descriptors for result sorting.
    ///
    /// - returns:
    ///     - A list of found data
    ///     - An empty array if no data was found using the provided criteria.
    func fetch(using predicate: NSPredicate? = nil, sortingBy sortdescriptors: [NSSortDescriptor]? = nil) -> [DataType] {
        var fetcher = DataFetcher<DataType>(context: self.context)
        fetcher.predicate = predicate
        fetcher.sortDescriptors = sortdescriptors
        return fetcher.fetch()
    }
}

