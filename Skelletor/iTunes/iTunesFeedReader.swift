//
//  iTunesFeedReader.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 23/03/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

public enum iTunesFeedReaderResult {
    case success(items: [iTunesModel])
    case error(error: String)
}

public struct iTunesFeedReader {
    let url: URL
    let resultQueue: DispatchQueue
    
    public init (url: URL, resultQueue: DispatchQueue = DispatchQueue.main) {
        self.url = url
        self.resultQueue = resultQueue
    }
    
    public func read(using callback: @escaping (_ result: iTunesFeedReaderResult)->()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return callback(.error(error: error.localizedDescription))
            }
            if let data = data {
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                        var parsedItems: [iTunesModel] = []
                        if let entries = (jsonDict["feed"] as? [String:Any])?["entry"] as? [[String:Any]] {
                            // We have an array of items
                            parsedItems = self.parse(entries: entries)
                        } else if let entry = (jsonDict["feed"] as? [String:Any])?["entry"] as? [String:Any] {
                            // We have only a single entry
                            parsedItems = self.parse(entries: [entry])
                        }
                        self.resultQueue.async {
                            callback(.success(items: parsedItems))
                        }
                    }
                } catch {
                    callback(.error(error: "Invalid JSON data"))
                }
            }
        }.resume()
    }
    
    func parse(entries: [[String:Any]]) -> [iTunesModel] {
        var parsedItems: [iTunesModel] = []
        for entry in entries {
            let model = iTunesModel()
            model.parse(from: entry)
            parsedItems.append(model)
        }
        return parsedItems
    }
}
