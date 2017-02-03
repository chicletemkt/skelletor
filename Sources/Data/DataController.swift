//
//  DataController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 03/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import CoreData
import Foundation

/// Errors thrown by Data Controller
enum DataControllerError : Error {
    /// Model definitions file coudn't be found in storage.
    case CantFindModel
    /// Model is corrupted and can't be loaded into memory
    case CantLoadModel
}

/// Data model for this app. This is a façade which maintains all related data operations encapsulated into a single
/// interface. It holds, basically, all boiler plate code for Core Data.
class DataController {
    /// Managed object context. Access point to Core Data stack
    let context: NSManagedObjectContext
    
    /// Initializes the whole core data stack, preparing the data access to be ready to use.
    init(dataModel: String, dataFile: String) throws {
        guard let modelURL = Bundle.main.url(forResource: dataModel, withExtension: "momd") else {
            throw DataControllerError.CantFindModel
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw DataControllerError.CantLoadModel
        }
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        OperationQueue.main.addOperation {
            let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
            let storeURL = urls[urls.endIndex-1].appendingPathComponent(dataFile + ".database")
            do {
                try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch { }
        }
    }
    
    /// Saves any pending changes, only if there are changes.
    /// - returns:
    ///     - true, if the operation completed successfully
    ///     - false, on failure
    @discardableResult func save() -> Bool {
        var result = true
        if self.context.hasChanges {
            self.context.performAndWait {
                do {
                    try self.context.save()
                } catch {
                    result = false
                }
            }
        }
        return result
    }
}
