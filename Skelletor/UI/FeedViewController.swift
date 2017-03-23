//
//  FeedViewController.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 22/03/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit
import FeedKit

public class FeedViewController: UITableViewController {
    @IBInspectable var cellId: String! = "FeedCell"
    @IBInspectable var feedPath: String!

    var feed: FeedParser!
    var viewData: (rss: [RSSFeedItem]?, atom: [AtomFeedEntry]?) = (rss: nil, atom: nil)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if feedPath != nil {
            if let url = URL(string: feedPath) {
                feed = FeedParser(URL: url)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] () in
            self.feed?.parse({ [unowned self] (result) in
                switch result {
                case .rss(let feed):
                    self.viewData.rss = feed.items
                case .atom(let feed):
                    self.viewData.atom = feed.entries
                case .failure:
                    break
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
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
        if let items = viewData.rss {
            return items.count
        }
        if let items = viewData.atom {
            return items.count
        }
        return 0
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if let rssItem = viewData.rss?[indexPath.row] {
            cell.textLabel?.text = rssItem.title
            cell.detailTextLabel?.text = rssItem.description
        }
        if let atomItem = viewData.atom?[indexPath.row] {
            cell.textLabel?.text = atomItem.title
            cell.detailTextLabel?.text = atomItem.summary?.value
        }
        return cell
    }
}
