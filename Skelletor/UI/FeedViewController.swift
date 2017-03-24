//
//  FeedViewController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 22/03/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit

open class FeedViewController: UITableViewController {
    @IBInspectable public var cellId: String! = "FeedCell"
    @IBInspectable public var feedPath: String!
    @IBInspectable public var cacheFileName: String! = "itunesFeedCache"
    @IBInspectable public var sectionTitle: String!

    var feedReader: iTunesFeedReader!
    var feedItems: [iTunesModel] = []
    var urlSession: URLSession!
    let memoryCacheCapacity = 52428800  // 50M
    let diskCacheCapacity   = 262144000 // 250M
    
    override open func viewDidLoad() {
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
        var urlCache: URLCache?
        do {
            var diskCacheURLPath = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            diskCacheURLPath = diskCacheURLPath.appendingPathComponent(cacheFileName)
            urlCache = URLCache(memoryCapacity: memoryCacheCapacity, diskCapacity: diskCacheCapacity, diskPath: diskCacheURLPath.path)
        } catch {
            // Creates an in-memory small cache
            urlCache = URLCache(memoryCapacity: memoryCacheCapacity, diskCapacity: 0, diskPath: nil)
        }
        let urlSessionConfig = URLSessionConfiguration.background(withIdentifier: "iTunes Feed Downloader")
        urlSessionConfig.urlCache = urlCache
        if urlCache != nil {
            urlSessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        }
        urlSession = URLSession(configuration: urlSessionConfig)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let itunesItem = feedItems[indexPath.row]
        cell.textLabel?.text = itunesItem.name
        cell.detailTextLabel?.text = itunesItem.summary
        if let imageItemURL = itunesItem.images?.first {
            downloadImage(for: cell, using: imageItemURL)
        }
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    // MARK: - Table View Delegate
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itunesItem = feedItems[indexPath.row]
        if let link = itunesItem.link {
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Internal Functions
    func downloadImage(for cell: UITableViewCell, using url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                // Do nothing. Failed? So what! No image for the item
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.set(image: UIImage(data: data), forVisibleCell: cell)
                }
            }
        }
        task.resume()
    }
    
    func set(image: UIImage?, forVisibleCell cell: UITableViewCell) {
        if tableView.visibleCells.contains(cell) {
            cell.imageView?.image = image
            cell.imageView?.sizeToFit()
        }
    }
}
