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
struct DataFetcher <DataType: NSFetchRequestResult> {
    let context: NSManagedObjectContext
    var sortDescriptors: [NSSortDescriptor]?
    var predicate: NSPredicate?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetch() -> [DataType] {
        let request = NSFetchRequest<DataType>(entityName: String(describing: DataType.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
            return try context.fetch(request)
        } catch {}
        return []
    }
}
