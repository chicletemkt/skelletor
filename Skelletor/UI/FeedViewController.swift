//
//  FeedViewController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 22/03/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

public class FeedViewController: UITableViewController {
    @IBInspectable var cellId: String! = "FeedCell"
    @IBInspectable var feedPath: String!
    @IBInspectable var cacheFileName: String! = "itunesFeedCache"

    var feedReader: iTunesFeedReader!
    var feedItems: [iTunesModel] = []
    var urlCache: URLCache!
    let memoryCacheCapacity = 52428800  // 50M
    let diskCacheCapacity   = 262144000 // 250M
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if feedPath != nil  {
            if let url = URL(string: feedPath) {
                feedReader = iTunesFeedReader(url: url)
            }
        }
        if feedReader != nil {
            feedReader.read { (result) in
                switch result {
                case .success(let items):
                    self.feedItems = items
                    self.tableView.reloadData()
                case .error(_):
                    break
                }
            }
        }
        do {
            var diskCacheURLPath = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            diskCacheURLPath = diskCacheURLPath.appendingPathComponent(cacheFileName)
            urlCache = URLCache(memoryCapacity: memoryCacheCapacity, diskCapacity: diskCacheCapacity, diskPath: diskCacheURLPath.path)
        } catch {
            // Creates an in-memory small cache
            urlCache = URLCache(memoryCapacity: memoryCacheCapacity, diskCapacity: 0, diskPath: nil)
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let itunesItem = feedItems[indexPath.row]
        cell.textLabel?.text = itunesItem.name
        cell.detailTextLabel?.text = itunesItem.summary
        if let imageItemURL = itunesItem.images?.last {
            downloadImage(for: indexPath, using: imageItemURL)
        }
        return cell
    }
    
    // MARK: - Internal Functions
    func downloadImage(for indexPath: IndexPath, using url: URL) {
        let request = URLRequest(url: url)
        if let cachedResponse = urlCache.cachedResponse(for: request) {
            set(image:  UIImage(data: cachedResponse.data), forVisibleCellAt: indexPath)
        }
        else {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    // Do nothing. Failed? So what! No image for the item
                    return
                }
                if let response = response, let data = data {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    self.urlCache.storeCachedResponse(cachedResponse, for: request)
                    DispatchQueue.main.async {
                        self.set(image: UIImage(data: data), forVisibleCellAt: indexPath)
                    }
                }
            }
            task.resume()
        }
    }
    
    func set(image: UIImage?, forVisibleCellAt indexPath: IndexPath) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            if visibleIndexPaths.contains(indexPath) {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.imageView?.image = image
            }
        }
    }
}
