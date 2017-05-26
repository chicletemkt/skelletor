//
//  TvDataSource.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 26/05/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Generic data source for single dimension data
public final class TvCoreDataSource <DataType: NSFetchRequestResult>: NSObject, UITableViewDataSource {
    weak var moc: NSManagedObjectContext!
    public typealias CellConfigurator = (UITableViewCell, DataType) -> Void
    public var cellConfigurator: CellConfigurator?
    public var cellId: String!
    public var predicate: NSPredicate? {
        set {
            dataFetcher.predicate = newValue
        }
        get {
            return dataFetcher.predicate
        }
    }
    public var sortDescriptors: [NSSortDescriptor]? {
        set {
            dataFetcher.sortDescriptors = newValue
        }
        get {
            return dataFetcher.sortDescriptors
        }
    }
    var dataFetcher: DataFetcher<DataType>
    var data: [DataType] {
        return self.dataFetcher.fetch()
    }
    
    public init (using moc: NSManagedObjectContext) {
        self.moc = moc
        dataFetcher = DataFetcher<DataType>(context: moc)
    }
    
    // MARK: Table View Data Source 
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = dataItem(for: indexPath)
        cellConfigurator?(cell, item)
        return cell
    }
    
    // MARK: Helper Methods
    
    public func dataItem(for indexPath: IndexPath) -> DataType {
        return data[indexPath.row]
    }
    
    public func remove(at indexPath: IndexPath) {
        let item: DataType = data[indexPath.row]
        moc.delete(item as! NSManagedObject)
    }
}
