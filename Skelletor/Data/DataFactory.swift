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
public struct DataFactory<DataType: NSManagedObject> {
    weak var context: NSManagedObjectContext!
    
    /// Initializes the factory by providing a proper context to it to operate.
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Instantiates a new instance of the provided data type.
    public func instantiate() -> DataType {
        var instance: DataType!
        context.performAndWait {
            // Ensures that the operation will happen on the same context's run loop to avoid concurrency problems.
            instance = NSEntityDescription.insertNewObject(forEntityName: String(describing: DataType.self), into: self.context) as! DataType
        }
        return instance
    }
}

